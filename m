Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD212E2847;
	Mon, 22 Sep 2025 19:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569674; cv=none; b=swheEZIIftD6QdhTu/ZoYvQaG3/WIDB/CsWzwZmK3JtG+nVlBhUz/FtkZdps7JDBQw7otO02CnhaXjTCH0ef1sjh7mdlZsdmggCus2R2Eut9mWCOdAS9KEbkEzBqTlDRnUKk5fotHKSRp8u5HGwdGtvdBYiqXVga4ZqdXR6r3wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569674; c=relaxed/simple;
	bh=0AzPbMtc3w4WiW1M9ZNHh8J2zURSkbYVyE/RkFbC7XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=odMa1tEvNMh+cT3ZNySXied4QZRkaibnpmcYBFotwYcMI0MSHgl+dHoYaak1X1iDx2D9njKmSx6l0IXVRjBSzyykk75OV6xVWDBq4cbSt17KHOzDpjKQYDNwAYBUN5s6LovVUZY5+aQ9paSeFblGZEKfsM1PUJMW+gRIfLcQypI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzmSqTSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzmSqTSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58608C4CEF0;
	Mon, 22 Sep 2025 19:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569673;
	bh=0AzPbMtc3w4WiW1M9ZNHh8J2zURSkbYVyE/RkFbC7XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzmSqTSLnTSwn94RATt1pG+eeR6403zeS/Vl0vIHBcybwIS7lX68O8Z0WgwMlTh97
	 70xay4rJz+VZeWCA6s+oeEqrI/6s4ozLdjBYmDIi/16TUkaxUl20q8W56LCwbjUQ1J
	 1Z2yNcCDy79mnLaB2fFLepFHC157K718GD7ZHE2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/70] cnic: Fix use-after-free bugs in cnic_delete_task
Date: Mon, 22 Sep 2025 21:29:24 +0200
Message-ID: <20250922192405.214298464@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7926aaef8f0c5..ad2745c07c1ae 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -4220,8 +4220,7 @@ static void cnic_cm_stop_bnx2x_hw(struct cnic_dev *dev)
 
 	cnic_bnx2x_delete_wait(dev, 0);
 
-	cancel_delayed_work(&cp->delete_task);
-	flush_workqueue(cnic_wq);
+	cancel_delayed_work_sync(&cp->delete_task);
 
 	if (atomic_read(&cp->iscsi_conn) != 0)
 		netdev_warn(dev->netdev, "%d iSCSI connections not destroyed\n",
-- 
2.51.0



