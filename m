Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E96425F7A9;
	Wed, 30 Sep 2026 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785662; cv=none; b=W1VBmKWOBHp6AJbDwgG0g+8gTK15n28y7CkrAiKm7ojzlge20TWH25lxmHqygqFi/W0rr00mPH9vbb9/uIb2f58dNMj+VWQYyjZB8koqd1kzrIeCfNwWWfi2Q2TB1/uT48pK4hVZ5LuhufI4m25C/66/AT4TFC/6qTETtTk4wgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785662; c=relaxed/simple;
	bh=kHHjXZWXnyTpdLGaeiG7L68uHniLsDRBMd5zrwPhNHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQYx2u+ABWaoXhc9dSZXb8wOq9YFf6Sqqm7GEYb9aUINoxaq1MYxycFjGiEkOIs5KQ3pYSObkADaa+dsMphJq++Mz9gfRlD0+oSI5oXeYJKpSKikDk0jKFf9BWkiY7qAHI/pH59etp1psYm7Vfb69FCEuVPZCeFRJddfNnwZ0tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssJSgDy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssJSgDy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B231F000FF;
	Wed, 30 Sep 2026 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785659;
	bh=2oi6RTTPSg5VMccwrTNUOLY/F6hs8XGFaSe3LpwNVRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssJSgDy50CE1Rd99IlNiGETWzIHMX99XRptyDHMoTKkKR+dnRLYxwwXpSBPVd8dJO
	 M1HMybQRUAAJiM8M7V08HTOrkS9JT65foQVqgaJorhuLBCsvi5NO8p4LC9j2zIV+fi
	 zW6lKeX14EqZpQRiJVA0AG8q4EJgn3mPHyPJUJ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 585/982] Revert "perf cs-etm: Flush thread stacks after decoder reset"
Date: Wed, 30 Sep 2026 17:22:01 +0200
Message-ID: <20260930152429.347771010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 097df36140476ce86b23bfaa2fb9104a9c095752.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 45 ----------------------------------------
 1 file changed, 45 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 361b75b0882c4..3b54baf79bd4a 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1635,45 +1635,6 @@ static int cs_etm__end_block(struct cs_etm_queue *etmq,
 
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
@@ -1696,12 +1657,6 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
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



