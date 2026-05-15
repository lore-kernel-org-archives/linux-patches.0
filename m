Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E93FF1A2;
	Fri, 15 May 2026 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860294; cv=none; b=cOlPmEO+uqYl/FhTkaetdcuE6kBzr8Hd39KJhPaKr7yzfDVnmKFKmTnW2bkWtw6ZtQoJYqs/Q+mr5WqbKVqWVlRe56dpF4GXsETvSWrBmOjF7qLwzQEEspMAQF9vnO75i2Zxei50D5+d75sUqlZP9WsmALmN1IQJjoG6mCb2vyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860294; c=relaxed/simple;
	bh=izXdzrdt0+LVWC/IYvn7h5GXm56+dOp19s2HDjYWya4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV+JY+Guyj6IofeoiCUsED4E8gjHQXjGkOpXEgl1vdWLNdNV9qBncDmyRAT46ABzqt4nloFq0wMq6yC/Cghr05GzXncw3LKDsFCn53uEJBKmB1uvRmumXnlYs68RsdXQUEr8HmaU8/chYXWxz7U72Dwlm132LZJCFwq+y/HUdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1sLBNTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1sLBNTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E92C2BCB0;
	Fri, 15 May 2026 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860294;
	bh=izXdzrdt0+LVWC/IYvn7h5GXm56+dOp19s2HDjYWya4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1sLBNTTiemNtYlcTb5ef2wI8bSfDhJHUOH/e3izGHR9zn7Qpe4R4dO+MqrpIWn9i
	 PgmTFBYXYsKL3QHm3sSekXnjf81s4SxMr3/UxOC9LETqUrpqzjVGQRbd7Mvbdl4ZKr
	 8uwcJe8xCKsLd7ScjXwSP4qm1FgWn9wZ5BTVicQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 016/144] media: rc: streamzap: Error handling in probe
Date: Fri, 15 May 2026 17:47:22 +0200
Message-ID: <20260515154653.870313180@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 42844992664f03ef9f930e64f7370fa481e9c267 upstream.

If submitting the URB fails, the device will be unusable.
Probe() must fail.

Fixes: 7a569f524dd36 ("V4L/DVB: IR/streamzap: functional in-kernel decoding")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/streamzap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -219,9 +219,8 @@ static void streamzap_callback(struct ur
 	case -ESHUTDOWN:
 		/*
 		 * this urb is terminated, clean up.
-		 * sz might already be invalid at this point
 		 */
-		dev_err(sz->dev, "urb terminated, status: %d\n", urb->status);
+		dev_dbg(sz->dev, "urb terminated, status: %d\n", urb->status);
 		return;
 	default:
 		break;
@@ -358,11 +357,16 @@ static int streamzap_probe(struct usb_in
 
 	usb_set_intfdata(intf, sz);
 
-	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
+	retval = usb_submit_urb(sz->urb_in, GFP_ATOMIC);
+	if (retval < 0) {
 		dev_err(sz->dev, "urb submit failed\n");
+		goto rc_submit_fail;
+	}
 
 	return 0;
-
+rc_submit_fail:
+	rc_free_device(sz->rdev);
+	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
 	usb_free_urb(sz->urb_in);
 free_buf_in:


