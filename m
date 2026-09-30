Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9EB370AF3;
	Wed, 30 Sep 2026 15:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783280; cv=none; b=BsQu7nlzNViJVhR5eqhalhGwprTbl6ey6NgWS31BV4CTUIVi26w30P3PhSQTwlkzimaqay0gXyCdf9g2Sp/D2rwdoo8YEbbhrfKr45ZoQqxTqicua6Q9fhafuV/SzcjL0yg+J4EI/hxdO34UWxI/JFw1rslV46AVmbSG29wsNvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783280; c=relaxed/simple;
	bh=Ob2i3/OuWRZWG4EUTaQXmYhqCSzjP2MTrZexg3spj5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL2zc4OGxC8ha/DI2j1fz0h8hI0JQ0M0agKKSfVrl+EANJUyDNEXSgbI888Creeefv23905vT22NlOsVsSshcEs0g2ebfnWKuUv09rbVGIX0KcpQiQEI4Lm5Uu0hp3qRxkGGtzhsq+FkGOgSO0ZBI6hfXmFi7iGuGc0nQ2gE1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJyvQLhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJyvQLhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F27E1F000FF;
	Wed, 30 Sep 2026 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783276;
	bh=/oupnASdGmvdYSl9zkyFRHEJgUS0dILxLfIj96+BDDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJyvQLhR7nlKWV98VTlKUqodYrw1V1FQ9+8o9ZNu5dVeAmOLECu7QKwV2zhdfLC0Z
	 n9DWYpS+3kODKVnkkCdbnMdxIpcWbiF3yc7gOOXztzB6KQhIjqmSBUdAZMzGoIQ+He
	 rFQdWq9XNnxLKvSa9uG/JIZsQIF3uTUHQHNqJ+30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/595] Revert "perf cs-etm: Flush thread stacks after decoder reset"
Date: Wed, 30 Sep 2026 17:23:54 +0200
Message-ID: <20260930152355.013273723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit e7e168699270235880344e3a0c9b8ce5c947ff3a.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 45 ----------------------------------------
 1 file changed, 45 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 9b38eedabc9fc..2055d582a8a43 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1609,45 +1609,6 @@ static int cs_etm__end_block(struct cs_etm_queue *etmq,
 
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
@@ -1670,12 +1631,6 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
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



