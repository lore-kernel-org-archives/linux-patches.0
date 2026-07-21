Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C4B30EF9A;
	Tue, 21 Jul 2026 19:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662429; cv=none; b=TNWDprDOdgDaA06eCx1SOTWNrJ3PS+4ps1vOXx+bU6/mx492exeF3OPjF0scgMTKQwE4+vNmEG6JdDMZif5OWw3iXrL1pZAsutcmq/5cerpwcgeqkH8W3NFSvudH/PdA1db5Rqtw9GfNf47oo8L77KbCNuq2lGcAcfxWiEQGZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662429; c=relaxed/simple;
	bh=4zru547EVyA/nTx54Ea9U9sUQjIKnpvDXH1b0Bp8VYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Na1zJ97SrNyiASunO5tK/dbuuy3qbMJzY/QfyYQyVPXAQzqSwWu3PrkHPKdFe4uzf3amXTdY3buc3YuBdD4kZJqssP1DGfZmnAQuHj/UbFo/sN44cNgJZU0lt2fueVwOLk73c77qF5G7UfevtLohUEq6g3XDRXoa1HvVaXBX8SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ez4KnZpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ez4KnZpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FECD1F000E9;
	Tue, 21 Jul 2026 19:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662428;
	bh=U+mYS3ij1Y/P20DC0UcPoPNo9X8qsAWmlHWMF72TngI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ez4KnZpjLTfsjB+R2oBgb0ZFxgETZZrLXUCw26ZuRGLF3rMZqjeTKqP+v87szTlpn
	 V3GlyaZHFSscwUOAKP9N5I+gT2/PR39xMd6ektFZ2lr5/UvCCFE6Kw/nwHjLBmwTyB
	 oLsm1aN2m8/w5aCK5xCJ5GewkPTDBG6hx3whoUD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0441/1276] char: tlclk: fix use-after-free in tlclk_cleanup()
Date: Tue, 21 Jul 2026 17:14:44 +0200
Message-ID: <20260721152455.969416337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: James Kim <james010kim@gmail.com>

[ Upstream commit bbf003b7794d6ad6f939fdd29f1f1bde8ac554c1 ]

This patch improves the module cleanup process in the tlclk driver to
prevent potential use-after-free and race conditions.

Currently, the file_operations structure does not specify the .owner
field, which could allow the module to be unloaded while user-space
processes are still interacting with the device. Additionally, the
tlclk_cleanup() function frees the alarm_events memory before ensuring
that blocked processes in the waitqueue are fully awakened and that the
switchover_timer has completed.

To address these cases, this patch:
- Sets '.owner = THIS_MODULE' in tlclk_fops to safely defer module
  unloading while the device is in use.
- Updates tlclk_cleanup() to explicitly wake up all blocked readers
  (wake_up_all), properly release hardware I/O regions, and safely
  delete the timer (timer_delete_sync) prior to freeing memory.

Fixes: 1a80ba882730 ("[PATCH] Telecom Clock Driver for MPCBL0010 ATCA computer blade")
Signed-off-by: James Kim <james010kim@gmail.com>
Link: https://patch.msgid.link/20260503101131.64219-1-james010kim@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tlclk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 377bebf6c925da..103127c2aeabcd 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -264,6 +264,7 @@ static ssize_t tlclk_read(struct file *filp, char __user *buf, size_t count,
 }
 
 static const struct file_operations tlclk_fops = {
+	.owner = THIS_MODULE,
 	.read = tlclk_read,
 	.open = tlclk_open,
 	.release = tlclk_release,
@@ -853,6 +854,9 @@ static void __exit tlclk_cleanup(void)
 	misc_deregister(&tlclk_miscdev);
 	unregister_chrdev(tlclk_major, "telco_clock");
 
+	got_event = 1;
+	wake_up_all(&wq);
+
 	release_region(TLCLK_BASE, 8);
 	del_timer_sync(&switchover_timer);
 	kfree(alarm_events);
-- 
2.53.0



