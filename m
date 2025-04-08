Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B9C26868E;
	Tue,  8 Apr 2025 11:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110729; cv=none; b=r+BdGszjPpAPKqj21RU6H+5AeQ001y/jHIac5KwWNYhTm5GbJPcRM5giv9NCNvzLpTNon186DQHUrv/JrtCJBzYJ9r8XxCHCN/3UlmrVGf0mdQNPBJAqJO1hjAAZP/hJMNAfgLnotzPRvVWYED/GwVWyl5nmIYx8dZDSECL+ztc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110729; c=relaxed/simple;
	bh=Q3my8K142GmnTtDaA/pcOH/DhY3qmGGpkudTGi5S2ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hm8GmgKtpgRaQLEfutBna45jC8mHC4n19GM0kGWNckjWkh6PsEbcpnmmpA+Ccm8yEAxXB9vlKEGsKOGtoX1K6f2pxzOZ8lT2tk0bZbnKx069wrSO8VJwv3df3pDyobu49qukoKP/ssAnNKM7WrKd5/3V+2gIjJ0KHbNTmJrCoD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkle/OXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkle/OXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524C3C4CEE5;
	Tue,  8 Apr 2025 11:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110729;
	bh=Q3my8K142GmnTtDaA/pcOH/DhY3qmGGpkudTGi5S2ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkle/OXDUwiWo7jrw1f4p9NSB/VfLeEZX23QSwfn1Wv85SiHpx19TvJ/Y7WQW6aXO
	 kayrbaHqbJrKsFuoO+k+E/kPu8J2uAqHwOiTPqwSzlY6jRfEezmtq8EFVsTMsINWiI
	 6Pb49/YjzVtWOEthM09XldVLKSA5+4mn4MN1VYDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	Guillaume Morin <guillaume@morinfr.org>
Subject: [PATCH 6.14 132/731] md: fix mddev uaf while iterating all_mddevs list
Date: Tue,  8 Apr 2025 12:40:29 +0200
Message-ID: <20250408104917.350425530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 8542870237c3a48ff049b6c5df5f50c8728284fa ]

While iterating all_mddevs list from md_notify_reboot() and md_exit(),
list_for_each_entry_safe is used, and this can race with deletint the
next mddev, causing UAF:

t1:
spin_lock
//list_for_each_entry_safe(mddev, n, ...)
 mddev_get(mddev1)
 // assume mddev2 is the next entry
 spin_unlock
            t2:
            //remove mddev2
            ...
            mddev_free
            spin_lock
            list_del
            spin_unlock
            kfree(mddev2)
 mddev_put(mddev1)
 spin_lock
 //continue dereference mddev2->all_mddevs

The old helper for_each_mddev() actually grab the reference of mddev2
while holding the lock, to prevent from being freed. This problem can be
fixed the same way, however, the code will be complex.

Hence switch to use list_for_each_entry, in this case mddev_put() can free
the mddev1 and it's not safe as well. Refer to md_seq_show(), also factor
out a helper mddev_put_locked() to fix this problem.

Cc: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-raid/20250220124348.845222-1-yukuai1@huaweicloud.com
Fixes: f26514342255 ("md: stop using for_each_mddev in md_notify_reboot")
Fixes: 16648bac862f ("md: stop using for_each_mddev in md_exit")
Reported-and-tested-by: Guillaume Morin <guillaume@morinfr.org>
Closes: https://lore.kernel.org/all/Z7Y0SURoA8xwg7vn@bender.morinfr.org/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 827646b3eb594..f501bc5f68f1a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -629,6 +629,12 @@ static void __mddev_put(struct mddev *mddev)
 	queue_work(md_misc_wq, &mddev->del_work);
 }
 
+static void mddev_put_locked(struct mddev *mddev)
+{
+	if (atomic_dec_and_test(&mddev->active))
+		__mddev_put(mddev);
+}
+
 void mddev_put(struct mddev *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
@@ -8461,9 +8467,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
 		status_unused(seq);
 
-	if (atomic_dec_and_test(&mddev->active))
-		__mddev_put(mddev);
-
+	mddev_put_locked(mddev);
 	return 0;
 }
 
@@ -9895,11 +9899,11 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
-	struct mddev *mddev, *n;
+	struct mddev *mddev;
 	int need_delay = 0;
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
@@ -9911,8 +9915,8 @@ static int md_notify_reboot(struct notifier_block *this,
 			mddev_unlock(mddev);
 		}
 		need_delay = 1;
-		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
+		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
@@ -10245,7 +10249,7 @@ void md_autostart_arrays(int part)
 
 static __exit void md_exit(void)
 {
-	struct mddev *mddev, *n;
+	struct mddev *mddev;
 	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
@@ -10266,7 +10270,7 @@ static __exit void md_exit(void)
 	remove_proc_entry("mdstat", NULL);
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
@@ -10278,8 +10282,8 @@ static __exit void md_exit(void)
 		 * the mddev for destruction by a workqueue, and the
 		 * destroy_workqueue() below will wait for that to complete.
 		 */
-		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
+		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
-- 
2.39.5



