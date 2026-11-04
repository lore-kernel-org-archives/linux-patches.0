Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827222;
	b=trGraF3wCsYcgPuQ64hFPEK4+6BEO2/2xYP06LnLgRgjV5fPbYSR+3OOgTFJSJiF0WGF
	 GNteSNNaQB6S965QRLNQqpcV0CaDxMJd0isstUOY2vAjHN8c5y6AR5QGWcuED6IV01C3E
	 PN9W8DZTrA/c8flpM9grVaZwbhbujqYUviiegcbcV7WsMOqNfE1voxz6u39OTW4kwfh7Z
	 +b57xXXl8IbYLRRR54VjG4LntkSM5cvzqmhnNCtZKWs0F/dZEYfS+O9V3QG5Ejh0lFIrW
	 v12ps3kftBt3P8YJRPdgiUu43++dSWn2+EHjbbvPcw7z9P6thsJMMRS8v1gNuaX78/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQukiRTDsvDkvelNuLG2+9zTJs4obElNpR/TzfoDgZA=;
	b=UZBo1r5Q2N8a4/pt59WrEhQCfh/Iv8IAqk8wxGfEGgIayyBL3b27oAtllt0G/tTuzPvn
	 iWqhvyitI/oFNOKaZEWo3jxzbu/D70MphaeA1zhSjoDNZII+P0XDk+dT3A381jjPPgS2J
	 QGFICuWFvCH/FBavGnXoj10EqBGBrn2r4xcBoermaSE0K1Apaneb3bggCUWZCk1icXzFj
	 CHHEyTatxvTvcy87dFz42NuH+0QCfXYaEAmpxS/5gTkat4p5zdRAkZnPwBp/jRsz4S0MJ
	 1welRfRRT6Ms62bTK0OuYiWR6qiLx0lA+YUUyQ/86YlWrX4+u5kHQy03rk372bWS30g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ns4qgefA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A1606B3B1;
	Wed,  4 Nov 2026 21:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ns4qgefA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ED51F00A17;
	Wed,  4 Nov 2026 21:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827222;
	bh=bQukiRTDsvDkvelNuLG2+9zTJs4obElNpR/TzfoDgZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ns4qgefAw8l72Vk5DLeUvmsspCNt9DeR1YFaCbbhGeGAcjBw9ZXYIOS03On9yRmMG
	 /Ohz2N1sLgfycerzrsXdkYa3jbyBwuyqlT09v/EIr+vUXdFJP/Ha6ArSOdy6PrLQDJ
	 e9Qb+4sjOnz1oFe0Z/9K0TO5w7cB+TNtw378CC78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 219/547] io_uring/io-wq: save worker type before dropping its reference
Date: Wed,  4 Nov 2026 16:06:43 -0500
Message-ID: <20261104211044.375247236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 37e425460b7c41687e51e3254b1eb1d799da9614 upstream.

io_wq_cancel_tw_create() inspects cb->func after calling
io_worker_cancel_cb(). For an existing worker, that call can drop the
last worker reference and wake io_worker_exit(). If the canceling task
is preempted, the worker can be unlinked and freed by kfree_rcu() before
the callback function is inspected. KASAN reports a slab-use-after-free
read in this path.

Save whether the callback belongs to an unpublished continuation worker
while its reference is still held, then use the saved result for the
conditional free. This preserves the existing accounting and frees only
the worker allocated for the canceled continuation.

Fixes: e6db6f9398da ("io_uring/io-wq: only free worker if it was allocated for creation")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1424,14 +1424,16 @@ static void io_wq_cancel_tw_create(struc
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
 		struct io_worker *worker;
+		bool free_worker;
 
 		worker = container_of(cb, struct io_worker, create_work);
-		io_worker_cancel_cb(worker);
 		/*
 		 * Only the worker continuation helper has worker allocated and
-		 * hence needs freeing.
+		 * hence needs freeing. Save this before dropping its reference.
 		 */
-		if (cb->func == create_worker_cont)
+		free_worker = cb->func == create_worker_cont;
+		io_worker_cancel_cb(worker);
+		if (free_worker)
 			kfree(worker);
 	}
 }


