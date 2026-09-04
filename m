Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875724156F0;
	Fri,  4 Sep 2026 05:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499424; cv=none; b=WiNT3pW22bZ96esxA5yQnmH6vbG5ubmzh6p72MrnYpQPPJNpibf157IiD+dWIRlBrFvnTlp6MWvGkBWFVbS5dhFn1vpfx/CSG0TDC0NoZR6Lf1UMvsZ4DgP2B0ky1a+5t0ECJljYXq2gL6HulPOov2hyas06XOjHYd1v3JylGk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499424; c=relaxed/simple;
	bh=OJ/Gt3qIXVMLNvN4OMeH37lYCyq4QQRTXLpEn+1hZjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTyvMlAiseKlYKzZ70gKcK012iZIpfWItSoU/zLSmG8nXscgXg7WkbWEuEwbxCdbaKIriFPmdVXbQNBPE2N84GsAxZCoAUD6X75kSMawigU8cNyVk7CIZFiefTv2VRQ17Sgr64zRZWgp7IfkzdhfBPivf5Mo5eEOeVKqfGyE+LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmxydCLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmxydCLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4931F00A3D;
	Fri,  4 Sep 2026 05:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499423;
	bh=GW/kV2l10wRSgbmvqoILH9DHoDK0VMGee+iiiPEFKAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmxydCLEV6btaxhMt1sxaOIVaNBvvpvBeGVwOt3QkjGVZB61A0hGYbqluLUnkd26Y
	 yojH1/Metpp80/3WzCvvBH9QmHbcLOVhG6AJ8pSJeLJJ0CWvAsUvp6zlXcS2dc3IQN
	 0cr8ALORZ332VPO5ky8dNh2cFr7C1cyI1I7WShoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fangqiurong <fangqiurong@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 413/713] sched_ext: Fix scx_bpf_dsq_move_to_local___v2 compat detection
Date: Fri,  4 Sep 2026 06:56:21 +0200
Message-ID: <20260904045813.087040514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangqiurong <fangqiurong@kylinos.cn>

commit 56bbc91219c0711f1580a8ba7cd60471b6e1684e upstream.

libbpf strips the last ___flavor suffix when resolving kfunc externs, so
the bare ___v2 declaration resolves to scx_bpf_dsq_move_to_local, whose
BTF proto lacks @enq_flags. The extern never matches, bpf_ksym_exists()
returns false on every kernel that has the ___v2 kfunc, and the macro
falls back to ___v1, silently dropping @enq_flags.

Add the trailing ___compat suffix used by the other versioned externs in
this file (scx_bpf_dsq_insert___v2, scx_bpf_reenqueue_local___v2).

Any caller passing non-zero @enq_flags through the compat macro silently
loses them.

Fixes: 860683763ebf ("sched_ext: Add enq_flags to scx_bpf_dsq_move_to_local()")
Cc: stable@vger.kernel.org # v7.1+
Assisted-by: Z.ai:glm-5.2
Signed-off-by: fangqiurong <fangqiurong@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/sched_ext/include/scx/compat.bpf.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/sched_ext/include/scx/compat.bpf.h b/tools/sched_ext/include/scx/compat.bpf.h
index bddbf83831cb..5767647f8c49 100644
--- a/tools/sched_ext/include/scx/compat.bpf.h
+++ b/tools/sched_ext/include/scx/compat.bpf.h
@@ -31,7 +31,7 @@ struct cgroup *scx_bpf_task_cgroup___new(struct task_struct *p) __ksym __weak;
  *
  * v7.1: scx_bpf_dsq_move_to_local___v2() to add @enq_flags.
  */
-bool scx_bpf_dsq_move_to_local___v2(u64 dsq_id, u64 enq_flags) __ksym __weak;
+bool scx_bpf_dsq_move_to_local___v2___compat(u64 dsq_id, u64 enq_flags) __ksym __weak;
 bool scx_bpf_dsq_move_to_local___v1(u64 dsq_id) __ksym __weak;
 void scx_bpf_dsq_move_set_slice___new(struct bpf_iter_scx_dsq *it__iter, u64 slice) __ksym __weak;
 void scx_bpf_dsq_move_set_vtime___new(struct bpf_iter_scx_dsq *it__iter, u64 vtime) __ksym __weak;
@@ -45,8 +45,8 @@ bool scx_bpf_dispatch_from_dsq___old(struct bpf_iter_scx_dsq *it__iter, struct t
 bool scx_bpf_dispatch_vtime_from_dsq___old(struct bpf_iter_scx_dsq *it__iter, struct task_struct *p, u64 dsq_id, u64 enq_flags) __ksym __weak;
 
 #define scx_bpf_dsq_move_to_local(dsq_id, enq_flags)				\
-	(bpf_ksym_exists(scx_bpf_dsq_move_to_local___v2) ?			\
-	 scx_bpf_dsq_move_to_local___v2((dsq_id), (enq_flags)) :		\
+	(bpf_ksym_exists(scx_bpf_dsq_move_to_local___v2___compat) ?		\
+	 scx_bpf_dsq_move_to_local___v2___compat((dsq_id), (enq_flags)) :	\
 	 (bpf_ksym_exists(scx_bpf_dsq_move_to_local___v1) ?			\
 	  scx_bpf_dsq_move_to_local___v1((dsq_id)) :				\
 	  scx_bpf_consume___old((dsq_id))))
-- 
2.55.0



