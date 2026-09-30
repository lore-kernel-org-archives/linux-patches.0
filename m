Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB1E383C86;
	Wed, 30 Sep 2026 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791810; cv=none; b=an28S6wJFqy8bL7mnOfgu3DbBe1fzvs5JssuMDglGIhx+1PERx2sxCXqQRZog1+nc+C5c8TH9uz6zpCbBfP7tKrzc16RttMylE+BwwoexeycZmOPYFmL9npw1GX5f+BFMDep1er74aVcj430c/MBkBrqVNqZKxbyJIzYoNa4Y/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791810; c=relaxed/simple;
	bh=UTATIEZ306u9QF/YMNVf5Lcm9twNxSgmw5w7CifWUr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8KVfQz/qGoBLgQnjmYMod00f9wzGoq4Ip5u+b0YD6TLNG09ESUnaCXr3HhCIrZv9MDW1OdGek1+lrlEnmbi85MUqSuUndc/78d2hoXqg6Q4teqToDRMXWb6/0vnOW52ck0vHC3ObG0RQo3W96xWqEo3bJbAD3LZS2jweTwG+bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoQ1Ueg3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoQ1Ueg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DCA1F000FF;
	Wed, 30 Sep 2026 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791808;
	bh=NG5j8CM+0BaYGMDH9vytdTLXcA3ZLH+wklIiCpQSAO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoQ1Ueg3DiFMu/tVCkNm8ForKSCnhYMsW7ECxPtTfNHyWCwbWO6sG/XoTPqfG47aY
	 n/3++ucmdqyB19IuKwTdS9590Lf22gbqfVD91vCYyBLM0iGpAR7JD6w6FxesIc6SSh
	 0/EVJcT+GCKSnB+dirkaTtEY6SbdmHFUc0mmiO34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 433/752] Revert "perf cs-etm: Flush thread stacks after decoder reset"
Date: Wed, 30 Sep 2026 17:25:03 +0200
Message-ID: <20260930152407.654347332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 455f6895facd943bbbe8ffc7a191eda038276b31.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 45 ----------------------------------------
 1 file changed, 45 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index be5a2e2d226d8..6fa698186f0b6 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1637,45 +1637,6 @@ static int cs_etm__end_block(struct cs_etm_queue *etmq,
 
 	return 0;
 }
-
-static int cs_etm__flush_stack_cb(struct thread *thread,
-				  void *data __maybe_unused)
-{
-	thread_stack__flush(thread);
-	return 0;
-}
-
-static void cs_etm__flush_machine_stack(struct cs_etm_queue *etmq, pid_t pid)
-{
-	struct machine *machine;
-
-	machine = machines__find(&etmq->etm->session->machines, pid);
-	if (machine)
-		machine__for_each_thread(machine, cs_etm__flush_stack_cb, NULL);
-}
-
-static void cs_etm__flush_all_stack(struct cs_etm_queue *etmq)
-{
-	enum cs_etm_pid_fmt pid_fmt = cs_etm__get_pid_fmt(etmq);
-
-	if (!etmq->etm->synth_opts.last_branch)
-		return;
-
-	switch (pid_fmt) {
-	case CS_ETM_PIDFMT_CTXTID2:
-		/* Clear the guest stack if virtualization is supported */
-		cs_etm__flush_machine_stack(etmq, DEFAULT_GUEST_KERNEL_ID);
-		fallthrough;
-	case CS_ETM_PIDFMT_CTXTID:
-		cs_etm__flush_machine_stack(etmq, HOST_KERNEL_ID);
-		break;
-	case CS_ETM_PIDFMT_NONE:
-	default:
-		break;
-
-	}
-}
-
 /*
  * cs_etm__get_data_block: Fetch a block from the auxtrace_buffer queue
  *			   if need be.
@@ -1698,12 +1659,6 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
 		ret = cs_etm_decoder__reset(etmq->decoder);
 		if (ret)
 			return ret;
-
-		/*
-		 * Since the decoder is reset, this causes a global trace
-		 * discontinuity. Flush all thread stacks.
-		 */
-		cs_etm__flush_all_stack(etmq);
 	}
 
 	return etmq->buf_len;
-- 
2.53.0



