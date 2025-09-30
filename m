Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4470201017;
	Tue, 30 Sep 2025 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244305; cv=none; b=WHXJpiNF5IvXxNUGu43D3WhJEC2R6DzpP3dw3X/aPzPDTTviST4S8H0nbpoowbjc/9nKYu6yrcuCLNWoHM2SD6qZgVlKsG0R+5Qvm18CPbFSZIE/P1Js81fp1sqzHuVxQfoDeldDyS8SJHEI33P5tP1jw40c7oakSowRSL/l7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244305; c=relaxed/simple;
	bh=+hCB+RAfdfM8ooGl2L0APJW/yXbXVDmq8jPfWVp1f6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q9ZjfHo+EVAXDg/dBqQmc9EFbxyKwMep/EXmkiO4VNbeS/Nk7p4blFeliiNO9G1BjMgGcB3//6UPPXakLSh9gM25/8n2+I0nRKwBymBGbl+TzC533ivDvb4PrefxgUtCG3RTHj2Ta7ZH8LFYd1NfMl7X1ixJs6zkQcFqtgOtPs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqVBodes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqVBodes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1BAC4CEF0;
	Tue, 30 Sep 2025 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244305;
	bh=+hCB+RAfdfM8ooGl2L0APJW/yXbXVDmq8jPfWVp1f6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqVBodesz9XFnB6kscXCP4UpvArlSlxwbo/LNjYfHjUmdUCsSrSqqN18xVlb0/ScF
	 QeGC0dwPAenpUpwILegCYEUUNf2XqZIEJssVbs89+/iRZNmHpKtzMATeKDzx9qUZJy
	 p6r+DrLjrWRvwz3+9bQeFGEzRoNHv9kMUDFLOKSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/122] cnic: Fix use-after-free bugs in cnic_delete_task
Date: Tue, 30 Sep 2025 16:46:28 +0200
Message-ID: <20250930143825.332309134@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f7f10cfb3476e..582ca97532868 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -4223,8 +4223,7 @@ static void cnic_cm_stop_bnx2x_hw(struct cnic_dev *dev)
 
 	cnic_bnx2x_delete_wait(dev, 0);
 
-	cancel_delayed_work(&cp->delete_task);
-	flush_workqueue(cnic_wq);
+	cancel_delayed_work_sync(&cp->delete_task);
 
 	if (atomic_read(&cp->iscsi_conn) != 0)
 		netdev_warn(dev->netdev, "%d iSCSI connections not destroyed\n",
-- 
2.51.0



