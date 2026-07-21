Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058683B42F9;
	Tue, 21 Jul 2026 20:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666280; cv=none; b=TU9DIKj/Ayyi//gq3QH45NPAFf9QSc7o3wvOfwyYVCTtQnl5o/NePAXlhwxmWFyOM48zwetNCWbbrWtImxxBBcOVj/sJF71ObAJOMjcp9JdVp6qukNn1e3uHUvTtUHjVN5qRdAZHulWPI31RuFKe14dIWXh94Esslt95KWQ6gXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666280; c=relaxed/simple;
	bh=rX+gXe46cBoNp2O9Yb7HQ7AnQ34NAmc0TQSmi497Hlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mlx3Zs89C87717q1Kfb8IX5IAsZEpDNUiFP7BWsgu32TWyl15Vl3IaXr27caZOnUhsvavTflvRSdXzd6I3n3o0teLLk8jxAPCPJKAZHUteUom7m7PtL5bhTToSdfQyrglj/HEbZq3rdAmsQ6Ol8Cmlwo7rQejjsULy5tM+t714c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iC/NAr0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iC/NAr0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461941F00A3A;
	Tue, 21 Jul 2026 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666274;
	bh=SKNp+HPGwSQNb3yhJJ7Ne+ff4No/eUd3hVquOYiwn4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iC/NAr0uV8FvZJQEDewxSeBUGFd4In3dRL+RNp9WkfRpsJQTOUCCSGwH7x5oXBEDn
	 Iqp0XQlDOoduvd23BT/in2yj32Ar0mxZeDFVxCax2NydfIainKlIplHdycC+mpquaR
	 U76DILpx6ngmtiALT8xRaAHbkditFui4eWw1qNM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0621/1266] char: tlclk: fix use-after-free in tlclk_cleanup()
Date: Tue, 21 Jul 2026 17:17:38 +0200
Message-ID: <20260721152455.760205286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 896a3550fba9f3..6b993744f2d781 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -263,6 +263,7 @@ static ssize_t tlclk_read(struct file *filp, char __user *buf, size_t count,
 }
 
 static const struct file_operations tlclk_fops = {
+	.owner = THIS_MODULE,
 	.read = tlclk_read,
 	.open = tlclk_open,
 	.release = tlclk_release,
@@ -852,6 +853,9 @@ static void __exit tlclk_cleanup(void)
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



