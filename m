Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057788;
	b=DrDffxrYtMYa5vIDY1nbOCOYiDznae4tRwkrQ7HAg/wSrSuVuywgNyr8bFlWuoLEUq4q
	 lcOnITaxsRcdIPlsUP2Lkulmdbs+dCgi37kf06TRSNfoplV1iZ8hyxBIIRPTSqyx0LHAY
	 KGFwOB1gXIQzoOqkmbQhj7+XDiRsSA+NzH0sXE5BRoJejs5sgJTNao7ncc4hLpmtC99Hb
	 CwpZpsPjr0GWeS80GBhorBytYCEpplcj9nMfJCve6s6/dKqlmxL9M+S1rcKBAFxbwzftB
	 cSWq4+mNKYrscIYj+qXDnRbDg0Je4w3lOcqI0Q1zgJGWWW/MtE3ez/Oy8CPXs8fgUPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SgBluaz4dKMxoZWeAAFg5SeRtaLxlzRACTyzh51U/gg=;
	b=5qTPVrDTGge7tIqCbMjNeCD+i4Q9WG/sE6e/GLmsXEAYtRG9ce5hZJliJI3XeSu5BdaO
	 ++4NNGR1zIPP3VqjXX5/NyDXDymdADQS8Ir/EfX8xtoNbBEZR4I0LlTKC78BOZT+xSMQv
	 mU4Jec9nNcuHYANVsiz0vLqleupCEFybMpLPL4QpRaWim82eBxCFclEGLy9ZWzsq17+o7
	 MKEtqnMFjJfD9UhCuhVAfMcaJxDiO6BaMfe2ReCsInVCp+WpMyweTOBIIEXm3Fv5jjvaZ
	 P1b16Iu17X92UEKgjAITewOasK9oyNeZ8c0Og04dcuMdlzfA8FUdg1vGWlTitz5pGPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fi2mNVwX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CE1606A32F;
	Thu, 19 Nov 2026 03:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fi2mNVwX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1621F000C4;
	Thu, 19 Nov 2026 03:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057788;
	bh=SgBluaz4dKMxoZWeAAFg5SeRtaLxlzRACTyzh51U/gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fi2mNVwXVIAxBiPv6tip6QZYSHz1Q+yHZ2efehzoKA4pYjadb+v45+oFjoKi2GjB+
	 kgPLUsSo6r8L0abKMjEwp4BcXwSG5jNGRHTVju4e48TfpkYblDHAnHzt5emApfAULt
	 jCjrT0ZQDessgtfhtjYPNYVQCRasCtiS5+9IWnyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 0253/1848] io_uring/io-wq: save worker type before dropping its reference
Date: Wed, 18 Nov 2026 15:38:11 +0100
Message-ID: <20261118145922.667869786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1232,14 +1232,16 @@ static void io_wq_cancel_tw_create(struc
 
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


