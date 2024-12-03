Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450421F8AF4;
	Tue,  3 Dec 2024 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240050; cv=none; b=tLYNFMWjXAolJFJZoqUqipGwi2B2TAM/xAMtJFzXwpIM3KVYKnUuoa7CZEEURMvCjemfAx0Bbf+tFuTygiJID1UeigEyrcsY/sY6B5q6Z1IpeSjHwxq2Rks4GO6nR8q83C2tiDr4Bx3LKvCJRq49rCH57OqTQVCSM2z803mEIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240050; c=relaxed/simple;
	bh=cmQI48wx34cOO2hJVPybgupZVKVS4WXIB++8TOjCql8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ25xFpP3Zdn5WbJEsHdg/dGsw1qPbHLJVqcxNrrPCAnze9rbkO2KTB1vfGOwwPc0auoSH2CBwsh9SVtperKVpfcLqIZ1dl2tgTCCzvkq65wRwnoQA+mOYd8P5hXo9YdvbZ7hCaouP2wFLtjv368eFLfX41LlGs2aOJYY1WsiO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeDKm4ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeDKm4ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28DAC4CED6;
	Tue,  3 Dec 2024 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240050;
	bh=cmQI48wx34cOO2hJVPybgupZVKVS4WXIB++8TOjCql8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeDKm4htxUawn3b+LdabkdXQyWIeMNvALBxbpLar2ilV8jltXJqXxxroN8DzWTZuq
	 3++QvEV1ajK3YF8TPnJAlXFw74WxGPmY12nIPwAapUxS2bapJ9jdPcLTXz/jvjpdfI
	 O86x2U6sDgO5HPZnzldm2+WsLDtrEnN6j+hPspc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lai Yi <yi1.lai@linux.intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 817/817] block: dont verify IO lock for freeze/unfreeze in elevator_init_mq()
Date: Tue,  3 Dec 2024 15:46:29 +0100
Message-ID: <20241203144028.347617923@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 357e1b7f730bd85a383e7afa75a3caba329c5707 upstream.

elevator_init_mq() is only called at the entry of add_disk_fwnode() when
disk IO isn't allowed yet.

So not verify io lock(q->io_lockdep_map) for freeze & unfreeze in
elevator_init_mq().

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reported-by: Lai Yi <yi1.lai@linux.intel.com>
Fixes: f1be1788a32e ("block: model freeze & enter queue as lock for supporting lockdep")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241031133723.303835-5-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/elevator.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/block/elevator.c
+++ b/block/elevator.c
@@ -598,13 +598,19 @@ void elevator_init_mq(struct request_que
 	 * drain any dispatch activities originated from passthrough
 	 * requests, then no need to quiesce queue which may add long boot
 	 * latency, especially when lots of disks are involved.
+	 *
+	 * Disk isn't added yet, so verifying queue lock only manually.
 	 */
-	blk_mq_freeze_queue(q);
+	blk_freeze_queue_start_non_owner(q);
+	blk_freeze_acquire_lock(q, true, false);
+	blk_mq_freeze_queue_wait(q);
+
 	blk_mq_cancel_work_sync(q);
 
 	err = blk_mq_init_sched(q, e);
 
-	blk_mq_unfreeze_queue(q);
+	blk_unfreeze_release_lock(q, true, false);
+	blk_mq_unfreeze_queue_non_owner(q);
 
 	if (err) {
 		pr_warn("\"%s\" elevator initialization failed, "


