Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE1E25A2AB;
	Thu, 17 Apr 2025 18:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913151; cv=none; b=GTId8VRDUgT7c4Zwr6UZnjiJTJVBsYIxo2kpBKSTYaPJ1m8NVJvaPh+oFrJB0fExSNi/YxDtuIMHm0RM63OFtSDmJorQbnW5+AZlNgpaDoUEtmTntyAxJKlLoIr91W+3pKvtSrr/VrEE2rXFekl0waNa2rwRgutSw19FDMJdMUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913151; c=relaxed/simple;
	bh=Ut24wZ/XLySZXf5LuGwwEqpidcxp8T31pi1eM0NugA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvrGpBDHfGSF9gNKzICIJcsQW0GGKeiB1ruiylcyK/C+BBXTPJjfMrLO6N3uwVxz7lC092KeBZK6ld4/yzqeI9CSNxkGQeAt1e1/dg7JGyJdAFfPTTuj738z72RvhBgdjs76rfZL8RUvl+Sf9udIEG9o5a9soaozBgJIJnCZkco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leXMdCqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leXMdCqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26070C4CEE7;
	Thu, 17 Apr 2025 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913150;
	bh=Ut24wZ/XLySZXf5LuGwwEqpidcxp8T31pi1eM0NugA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leXMdCqIsUjYCtF+OC4u4VOQUfC9PZHE0X7MI/Iw5Lo5LaJGyqL9NGR974Id5Z5iI
	 vCmkJKzy7DvEI5eMkUoUY75H9hNw9TqZpCzXe7BZUW/bxadm/sSOYYinST6/CvrBIQ
	 hO95Thu9n9/4BLC9cJ788R7eFT6muNkNwcwGYtC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 244/449] media: streamzap: prevent processing IR data on URB failure
Date: Thu, 17 Apr 2025 19:48:52 +0200
Message-ID: <20250417175127.818456550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

commit 549f6d348167fb2f7800ed7c8d4bce9630c74498 upstream.

If streamzap_callback() receives an urb with any non-critical error
status, i.e. any error code other than -ECONNRESET, -ENOENT or -ESHUTDOWN,
it will try to process IR data, ignoring a possible transfer failure.

Make streamzap_callback() process IR data only when urb->status is 0.
Move processing logic to a separate function to make code cleaner and
more similar to the URB completion handlers in other RC drivers.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 19770693c354 ("V4L/DVB: staging/lirc: add lirc_streamzap driver")
Cc: stable@vger.kernel.org
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/streamzap.c |   68 ++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -138,39 +138,10 @@ static void sz_push_half_space(struct st
 	sz_push_full_space(sz, value & SZ_SPACE_MASK);
 }
 
-/*
- * streamzap_callback - usb IRQ handler callback
- *
- * This procedure is invoked on reception of data from
- * the usb remote.
- */
-static void streamzap_callback(struct urb *urb)
+static void sz_process_ir_data(struct streamzap_ir *sz, int len)
 {
-	struct streamzap_ir *sz;
 	unsigned int i;
-	int len;
-
-	if (!urb)
-		return;
-
-	sz = urb->context;
-	len = urb->actual_length;
-
-	switch (urb->status) {
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-		/*
-		 * this urb is terminated, clean up.
-		 * sz might already be invalid at this point
-		 */
-		dev_err(sz->dev, "urb terminated, status: %d\n", urb->status);
-		return;
-	default:
-		break;
-	}
 
-	dev_dbg(sz->dev, "%s: received urb, len %d\n", __func__, len);
 	for (i = 0; i < len; i++) {
 		dev_dbg(sz->dev, "sz->buf_in[%d]: %x\n",
 			i, (unsigned char)sz->buf_in[i]);
@@ -219,6 +190,43 @@ static void streamzap_callback(struct ur
 	}
 
 	ir_raw_event_handle(sz->rdev);
+}
+
+/*
+ * streamzap_callback - usb IRQ handler callback
+ *
+ * This procedure is invoked on reception of data from
+ * the usb remote.
+ */
+static void streamzap_callback(struct urb *urb)
+{
+	struct streamzap_ir *sz;
+	int len;
+
+	if (!urb)
+		return;
+
+	sz = urb->context;
+	len = urb->actual_length;
+
+	switch (urb->status) {
+	case 0:
+		dev_dbg(sz->dev, "%s: received urb, len %d\n", __func__, len);
+		sz_process_ir_data(sz, len);
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/*
+		 * this urb is terminated, clean up.
+		 * sz might already be invalid at this point
+		 */
+		dev_err(sz->dev, "urb terminated, status: %d\n", urb->status);
+		return;
+	default:
+		break;
+	}
+
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
 


