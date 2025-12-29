Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005193191AC;
	Mon, 29 Dec 2025 16:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025501; cv=none; b=TEOLziIP0NhKoZGTyMng0fIft8c/YAyfiqpHSJ2XRfxW0VWX3Pt9+qqMICKrleMh9COFD6QebaElwneMCOdLOZnCBwnYw/Tr16VLRabJgxaZ/ZLkiWbzG7GPvy8XuFV8qsMBcuAC6TTZoqqjI/2pX+xNawqGUMHKXdi40UQ6hVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025501; c=relaxed/simple;
	bh=S55iQuSn+4yXVTqUncTaMYA4mgUDo3YFB8SrnnSvylA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWmW7MaansHTQTOy/qTUDaJEEAY9prgEUpwAL2ieXwONGe/k7fAY1Dm2H20LNNdcWErjPXIAffwFP/+FvWbJg/I2O2v16u2HVpp4Pu5E3VtLrGMwJB2bo6OOpQ4KWJwKk8qiWkMgenq/ZbtdR5veT3BseBpbHu15uf9KAtkByC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VX3Kdwtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VX3Kdwtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F81C4CEF7;
	Mon, 29 Dec 2025 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025500;
	bh=S55iQuSn+4yXVTqUncTaMYA4mgUDo3YFB8SrnnSvylA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VX3KdwtldiiHKprZ1WDSXpaUfS0kuW8Ra4czDwtRiyC3vR0CDuE3U5Dm4WxDuRq5X
	 ooqOHsruhVeEn4GXcsi9QlWyZkkLHuqV9Ezhf3XyJoQzL9Hy6YXS6Vx3sFDnXATW8r
	 2U0H8WEcsq0w3phVB7OTREel8XvnrRI2RCqJu9I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 234/430] sched_ext: Fix the memleak for sch->helper objects
Date: Mon, 29 Dec 2025 17:10:36 +0100
Message-ID: <20251229160732.965282900@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Zqiang <qiang.zhang@linux.dev>

commit 517a44d18537ef8ab888f71197c80116c14cee0a upstream.

This commit use kthread_destroy_worker() to release sch->helper
objects to fix the following kmemleak:

unreferenced object 0xffff888121ec7b00 (size 128):
  comm "scx_simple", pid 1197, jiffies 4295884415
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
    ff ff ff ff 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  backtrace (crc 587b3352):
    kmemleak_alloc+0x62/0xa0
    __kmalloc_cache_noprof+0x28d/0x3e0
    kthread_create_worker_on_node+0xd5/0x1f0
    scx_enable.isra.210+0x6c2/0x25b0
    bpf_scx_reg+0x12/0x20
    bpf_struct_ops_link_create+0x2c3/0x3b0
    __sys_bpf+0x3102/0x4b00
    __x64_sys_bpf+0x79/0xc0
    x64_sys_call+0x15d9/0x1dd0
    do_syscall_64+0xf0/0x470
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: bff3b5aec1b7 ("sched_ext: Move disable machinery into scx_sched")
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3512,7 +3512,7 @@ static void scx_sched_free_rcu_work(stru
 	int node;
 
 	irq_work_sync(&sch->error_irq_work);
-	kthread_stop(sch->helper->task);
+	kthread_destroy_worker(sch->helper);
 
 	free_percpu(sch->pcpu);
 
@@ -4504,7 +4504,7 @@ static struct scx_sched *scx_alloc_and_a
 	return sch;
 
 err_stop_helper:
-	kthread_stop(sch->helper->task);
+	kthread_destroy_worker(sch->helper);
 err_free_pcpu:
 	free_percpu(sch->pcpu);
 err_free_gdsqs:


