Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263D2335BA;
	Thu, 13 Feb 2025 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459968; cv=none; b=A/BkWLNxY7sT0/GDMpCy2sws/jMqUkSeYCZITz7Y6QnMx+DNdUZ+KJ7zPgKfQ/8pipbAqvups7Bxp29oUY/Us7EkeR+DRJdQvS40x05qdfd9P+b108T/4cASbPy0/J1zqg2nRIHuRd7FgIJzf/aIzmUKZ+nQ024pLvz/FeSsrTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459968; c=relaxed/simple;
	bh=6HHbDhSn1qx38aA+c2rdNldmjRzTR5zzZuQDOEm3Rs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK50aaI22fVNSbErXhU/SgzB71zVJ4FS8FdCJg9p4kM1ibrlZkBXUlYynnXlrH7ssBKAnW/fLxJBBE9bGEklL0Xe2/0jEVTuIZ1Z8tGh2a7JCKUr0RQemwnFgO8fMm6K5iQd936mHEpglPOTwIAkFKflMXOALEJw9ECNyeNbJ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAUGmQb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAUGmQb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8581CC4CED1;
	Thu, 13 Feb 2025 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459968;
	bh=6HHbDhSn1qx38aA+c2rdNldmjRzTR5zzZuQDOEm3Rs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAUGmQb8GABey9PRjDh5flC1g5TIHHmCE70t4zIkwPV3PZhDikzENzpp6mpNn434W
	 n+X4/e13CTALRl2w5qwGWbO6QPOXVE9dasXFMUn4+9tWGZezB1jaCmt4nzgNs/AVoI
	 XUsuNRCX8njz0qVeebtJkxztbL80Ech03lsxckzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vimal Agrawal <vimal.agrawal@sophos.com>,
	Dirk VanDerMerwe <dirk.vandermerwe@sophos.com>
Subject: [PATCH 6.13 411/443] misc: misc_minor_alloc to use ida for all dynamic/misc dynamic minors
Date: Thu, 13 Feb 2025 15:29:36 +0100
Message-ID: <20250213142456.470290065@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vimal Agrawal <vimal.agrawal@sophos.com>

commit 6d04d2b554b14ae6c428a9c60b6c85f1e5c89f68 upstream.

misc_minor_alloc was allocating id using ida for minor only in case of
MISC_DYNAMIC_MINOR but misc_minor_free was always freeing ids
using ida_free causing a mismatch and following warn:
> > WARNING: CPU: 0 PID: 159 at lib/idr.c:525 ida_free+0x3e0/0x41f
> > ida_free called for id=127 which is not allocated.
> > <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
...
> > [<60941eb4>] ida_free+0x3e0/0x41f
> > [<605ac993>] misc_minor_free+0x3e/0xbc
> > [<605acb82>] misc_deregister+0x171/0x1b3

misc_minor_alloc is changed to allocate id from ida for all minors
falling in the range of dynamic/ misc dynamic minors

Fixes: ab760791c0cf ("char: misc: Increase the maximum number of dynamic misc devices to 1048448")
Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
Reviewed-by: Dirk VanDerMerwe <dirk.vandermerwe@sophos.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241021133812.23703-1-vimal.agrawal@sophos.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/misc.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -63,16 +63,30 @@ static DEFINE_MUTEX(misc_mtx);
 #define DYNAMIC_MINORS 128 /* like dynamic majors */
 static DEFINE_IDA(misc_minors_ida);
 
-static int misc_minor_alloc(void)
+static int misc_minor_alloc(int minor)
 {
-	int ret;
+	int ret = 0;
 
-	ret = ida_alloc_max(&misc_minors_ida, DYNAMIC_MINORS - 1, GFP_KERNEL);
-	if (ret >= 0) {
-		ret = DYNAMIC_MINORS - ret - 1;
+	if (minor == MISC_DYNAMIC_MINOR) {
+		/* allocate free id */
+		ret = ida_alloc_max(&misc_minors_ida, DYNAMIC_MINORS - 1, GFP_KERNEL);
+		if (ret >= 0) {
+			ret = DYNAMIC_MINORS - ret - 1;
+		} else {
+			ret = ida_alloc_range(&misc_minors_ida, MISC_DYNAMIC_MINOR + 1,
+					      MINORMASK, GFP_KERNEL);
+		}
 	} else {
-		ret = ida_alloc_range(&misc_minors_ida, MISC_DYNAMIC_MINOR + 1,
-				      MINORMASK, GFP_KERNEL);
+		/* specific minor, check if it is in dynamic or misc dynamic range  */
+		if (minor < DYNAMIC_MINORS) {
+			minor = DYNAMIC_MINORS - minor - 1;
+			ret = ida_alloc_range(&misc_minors_ida, minor, minor, GFP_KERNEL);
+		} else if (minor > MISC_DYNAMIC_MINOR) {
+			ret = ida_alloc_range(&misc_minors_ida, minor, minor, GFP_KERNEL);
+		} else {
+			/* case of non-dynamic minors, no need to allocate id */
+			ret = 0;
+		}
 	}
 	return ret;
 }
@@ -219,7 +233,7 @@ int misc_register(struct miscdevice *mis
 	mutex_lock(&misc_mtx);
 
 	if (is_dynamic) {
-		int i = misc_minor_alloc();
+		int i = misc_minor_alloc(misc->minor);
 
 		if (i < 0) {
 			err = -EBUSY;
@@ -228,6 +242,7 @@ int misc_register(struct miscdevice *mis
 		misc->minor = i;
 	} else {
 		struct miscdevice *c;
+		int i;
 
 		list_for_each_entry(c, &misc_list, list) {
 			if (c->minor == misc->minor) {
@@ -235,6 +250,12 @@ int misc_register(struct miscdevice *mis
 				goto out;
 			}
 		}
+
+		i = misc_minor_alloc(misc->minor);
+		if (i < 0) {
+			err = -EBUSY;
+			goto out;
+		}
 	}
 
 	dev = MKDEV(MISC_MAJOR, misc->minor);


