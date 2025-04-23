Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC4C28A3F9;
	Wed, 23 Apr 2025 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422467; cv=none; b=GSDc35ygeCCfhl5WIcYa6tiFb8kg00KtwotfoYHU1PyVCQD+2gxaMtiva5tbgsenenF/6UumrsEPqUUiwxu0A9fPjyBr/rZAOzy9znJix6LrMUuXbkgY/eW+4w0Jgdl/C7vxwcA/5dLSjxiHXuvV1XBTSyASUYilRrOG4YFEfjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422467; c=relaxed/simple;
	bh=9igSEkd2fbtfGa3sFdhf4gAi8+og9v7wKih+uDLU2GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcsNQClUV3v3abnBIBgFyKPsXwjSZlPfguTNe1eKHtDesxbLlFB+AGWA0IksHw9wTjP+ETb9/BVu0dEQJ8HLpEwHbd69Gp3EqGH2Ifb4UNRa6KDdbHqyoAqaRwob7f0jpsukzg3tpdiQNgk9dOg9UGBhs5nmyds/eUIeD4gd/m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8uzhQ2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8uzhQ2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA82C4CEE2;
	Wed, 23 Apr 2025 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422467;
	bh=9igSEkd2fbtfGa3sFdhf4gAi8+og9v7wKih+uDLU2GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8uzhQ2qilKb9LlKsWbmuXDg9Cm6FhkE+Fq1uVzDuRfWqRLtApCNiPNpZpReqplqZ
	 SMYti+BUCakPMwhGWlWnTA+SBEfCMeMoXb0gUb/d0Hnpe2wdpzNc1BkA+BTxdL95Fa
	 ItxpTF+KdVkVyq+AOrhK4yZzsZymzXes17dHbnu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Guillaume Morin <guillaume@morinfr.org>
Subject: [PATCH 6.6 362/393] md: fix mddev uaf while iterating all_mddevs list
Date: Wed, 23 Apr 2025 16:44:18 +0200
Message-ID: <20250423142658.290049411@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 8542870237c3a48ff049b6c5df5f50c8728284fa upstream.

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
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -649,6 +649,12 @@ static void __mddev_put(struct mddev *md
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
@@ -8417,9 +8423,7 @@ static int md_seq_show(struct seq_file *
 	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
 		status_unused(seq);
 
-	if (atomic_dec_and_test(&mddev->active))
-		__mddev_put(mddev);
-
+	mddev_put_locked(mddev);
 	return 0;
 }
 
@@ -9699,11 +9703,11 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
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
@@ -9715,8 +9719,8 @@ static int md_notify_reboot(struct notif
 			mddev_unlock(mddev);
 		}
 		need_delay = 1;
-		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
+		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
@@ -10039,7 +10043,7 @@ void md_autostart_arrays(int part)
 
 static __exit void md_exit(void)
 {
-	struct mddev *mddev, *n;
+	struct mddev *mddev;
 	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
@@ -10060,7 +10064,7 @@ static __exit void md_exit(void)
 	remove_proc_entry("mdstat", NULL);
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
@@ -10072,8 +10076,8 @@ static __exit void md_exit(void)
 		 * the mddev for destruction by a workqueue, and the
 		 * destroy_workqueue() below will wait for that to complete.
 		 */
-		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
+		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 


