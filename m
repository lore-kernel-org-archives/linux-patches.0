Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C6B46A5E7;
	Tue, 21 Jul 2026 18:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657035; cv=none; b=i1ydywMW2SbtYTD0FRS316BqVeIhGCmQhSWCoKab+jkPXtfXkwXfVPfklNEFgjzU8Ba1xbDTsrnzsh6a2BbA2DirRsGIdAGqBV1vm+Cwofa4pdnLQG7fM+cJEHSYn5JIIwDR+DxPAKPU8yI//9I3T0mfD8iNT1tWjiMBgcxsQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657035; c=relaxed/simple;
	bh=cJIrsz2HL56uTWL3EoVv9NnWXaQhtodyhPzF123khDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pv/MJTKgqep4s8Medo+mIndRUijx1f+EkLyijOkcJerr8+4qTqPocLgIhVWEWmpusk6GCfxR9BLFukntYmPzGsbrN0reic6ZjzJr0jkzExU7aMHc/mYXMKt+/1qzq9OnVLnR+EQlt7nn6q/PEIEa8dnyJAdhX3vjmhO4AcCZuLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq5Pu4he; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq5Pu4he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3431F00A3D;
	Tue, 21 Jul 2026 18:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657034;
	bh=/FdaK6PLZLto9hQ47Rqz71u9B9cLtt0aTaZCruphsKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq5Pu4heUmcaJxbEJ7d0XyELzwIbKP9aLL85UTc60ZHtD2JaiJfq3Msea+qGoeaei
	 HF2HUtQ1bY8bVOcRubrt5BUngiBQRxwWQ6ncXOSyY1X5aS11KuhIxJCuHQCq/v4ziz
	 B248FZYsyrySKXdiWMLIeuScLFZ+TePYlfvxQfaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0613/1611] char: tlclk: fix use-after-free in tlclk_cleanup()
Date: Tue, 21 Jul 2026 17:12:09 +0200
Message-ID: <20260721152529.172941808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b381ea7e85d2f4..d08948cdb2b89d 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -264,6 +264,7 @@ static ssize_t tlclk_read(struct file *filp, char __user *buf, size_t count,
 }
 
 static const struct file_operations tlclk_fops = {
+	.owner = THIS_MODULE,
 	.read = tlclk_read,
 	.open = tlclk_open,
 	.release = tlclk_release,
@@ -837,6 +838,9 @@ static void __exit tlclk_cleanup(void)
 	misc_deregister(&tlclk_miscdev);
 	unregister_chrdev(tlclk_major, "telco_clock");
 
+	got_event = 1;
+	wake_up_all(&wq);
+
 	release_region(TLCLK_BASE, 8);
 	timer_delete_sync(&switchover_timer);
 	kfree(alarm_events);
-- 
2.53.0



