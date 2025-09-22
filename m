Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE872F0C5C;
	Mon, 22 Sep 2025 19:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569869; cv=none; b=CkBBfdqV5nGABhRxfaXDsDB+I7xeqA9qn6gJ9eplpRKyxzWxvech3vnEtARc7wfLr/crXqkCoBCSF7G/c0eShEomojxAS/8Yh3UiWzQlKfQXLDimOPV+QBCkKOOL0IdOQLz/zxV4VrOxbyTBMhoyDTmhgHTkokiMytb0EOQ7J48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569869; c=relaxed/simple;
	bh=x+H7XW8u2acmSK3NYItdRKfVfjlR5mIM2aaJLdTdB44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qcsUnCIfOoCwjBSuq4zLeiYHDY5U9bUWZ72T3IBwvRNXqy/VlwUVOcBovtzXhE/8pFNtgMB8jWvwsMTQzPZQATE/P7Pmvri+9D8uvD5CTZuN5EGx4BEZ5oJ8sWAPYdhyth3+EHv1hTEL9PVvxaHs9zSX1kKN4spL9YbCMeYEOG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YI2yLRsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YI2yLRsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352D4C4CEF0;
	Mon, 22 Sep 2025 19:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569869;
	bh=x+H7XW8u2acmSK3NYItdRKfVfjlR5mIM2aaJLdTdB44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YI2yLRsm19888/n10mpUIovIIakfY3h8O1sPYkh3vhSVVGd283ntyd3KDBq9E8lYU
	 pGY17C/ZuC2A6ULm1teSUR8fa5c5dl9bk4pDl8dGv1RD33/9EaJMghaLMVby7HWu4e
	 IsTHXkV52tXEvYLuiSA8of9XydmGotf+Eaz7+bhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/105] cnic: Fix use-after-free bugs in cnic_delete_task
Date: Mon, 22 Sep 2025 21:29:14 +0200
Message-ID: <20250922192409.724149850@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit cfa7d9b1e3a8604afc84e9e51d789c29574fb216 ]

The original code uses cancel_delayed_work() in cnic_cm_stop_bnx2x_hw(),
which does not guarantee that the delayed work item 'delete_task' has
fully completed if it was already running. Additionally, the delayed work
item is cyclic, the flush_workqueue() in cnic_cm_stop_bnx2x_hw() only
blocks and waits for work items that were already queued to the
workqueue prior to its invocation. Any work items submitted after
flush_workqueue() is called are not included in the set of tasks that the
flush operation awaits. This means that after the cyclic work items have
finished executing, a delayed work item may still exist in the workqueue.
This leads to use-after-free scenarios where the cnic_dev is deallocated
by cnic_free_dev(), while delete_task remains active and attempt to
dereference cnic_dev in cnic_delete_task().

A typical race condition is illustrated below:

CPU 0 (cleanup)              | CPU 1 (delayed work callback)
cnic_netdev_event()          |
  cnic_stop_hw()             | cnic_delete_task()
    cnic_cm_stop_bnx2x_hw()  | ...
      cancel_delayed_work()  | /* the queue_delayed_work()
      flush_workqueue()      |    executes after flush_workqueue()*/
                             | queue_delayed_work()
  cnic_free_dev(dev)//free   | cnic_delete_task() //new instance
                             |   dev = cp->dev; //use

Replace cancel_delayed_work() with cancel_delayed_work_sync() to ensure
that the cyclic delayed work item is properly canceled and that any
ongoing execution of the work item completes before the cnic_dev is
deallocated. Furthermore, since cancel_delayed_work_sync() uses
__flush_work(work, true) to synchronously wait for any currently
executing instance of the work item to finish, the flush_workqueue()
becomes redundant and should be removed.

This bug was identified through static analysis. To reproduce the issue
and validate the fix, I simulated the cnic PCI device in QEMU and
introduced intentional delays — such as inserting calls to ssleep()
within the cnic_delete_task() function — to increase the likelihood
of triggering the bug.

Fixes: fdf24086f475 ("cnic: Defer iscsi connection cleanup")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/cnic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index a9040c42d2ff9..6e97a5a7daaf9 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -4230,8 +4230,7 @@ static void cnic_cm_stop_bnx2x_hw(struct cnic_dev *dev)
 
 	cnic_bnx2x_delete_wait(dev, 0);
 
-	cancel_delayed_work(&cp->delete_task);
-	flush_workqueue(cnic_wq);
+	cancel_delayed_work_sync(&cp->delete_task);
 
 	if (atomic_read(&cp->iscsi_conn) != 0)
 		netdev_warn(dev->netdev, "%d iSCSI connections not destroyed\n",
-- 
2.51.0



