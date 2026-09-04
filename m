Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FFE4189DD;
	Fri,  4 Sep 2026 05:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499435; cv=none; b=m92Vq3TWn/D1PySvWOt0iVAd4Qh/076ZkV0iQKzZiYrSREa5rHJIhj4dIclt1hxeMJxD17bMof8TrozHm4MnEOJEKdQhzmTeHtlXsMesaUPP+6zzdKD5McP7seUqn5ySEaJIieNxaAM2GlW/vprZ+9756MHybCjFvw8u1HjYRiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499435; c=relaxed/simple;
	bh=Eycz4MUiQpbi/REDFYsYDjOcMcOW6ldQ3xRVEKehauo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWvg3DXo2+O3rchSypmIEJSw/xV615OaePRPmssfc2FseCvAeIaWoqgIZCRHuYZJe/DT8vdxO3FCkRvKkj2CPG7W055+eP+Pi1+GXxqhluJWZtR1US4mSQCOR16u797mDGKUUUkjeLe2jkB415j94QAm/lRRvz5HdJJqP4Oy5dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5YxVJcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5YxVJcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C7C1F00A3D;
	Fri,  4 Sep 2026 05:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499434;
	bh=JWVvspU37enQpN4qC1dvUCIBYfHpcigIAyNoMk0OKLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5YxVJcMfYxXWf1rm9BKTHEexfuQEns1NH4QvTQ69/aKhbAbyjOJ6aaSURJTTrBgv
	 oCdopnro06ZmgE8bzpEx2j6RgtzXekvytYaqToL7R28ExXkIHeIpKmtsgFDeecvoVb
	 WlRk9mRj9vDVAkzEO3r05q2VtQaj0EPC4BeAdkJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 417/713] sched_ext: Fix scx_bpf_dsq_reenq___compat kfunc extern prototype
Date: Fri,  4 Sep 2026 06:56:25 +0200
Message-ID: <20260904045813.177969628@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit 62f3d531e41a7e6e0dc8d37ea377c50488decb56 upstream.

scx_bpf_dsq_reenq() is registered with KF_IMPLICIT_ARGS and its kernel BTF
prototype omits the trailing bpf_prog_aux argument. The ___compat extern
declares the argument explicitly, so libbpf never matches the prototype and
the weak extern silently stays unresolved on every kernel. The wrapper
always takes the old fallback path, which disables generic reenq users like
scx_qmap's lowpri mechanism and fails non-local reenq with "kernel too old"
even on kernels that have the kfunc.

Drop the explicit aux argument. Also correct the stale v6.20 reference, the
kfunc was added in v7.1.

Fixes: 9c34c5074d1b ("sched_ext: Introduce scx_bpf_dsq_reenq() for remote local DSQ reenqueue")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/sched_ext/include/scx/compat.bpf.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/sched_ext/include/scx/compat.bpf.h
+++ b/tools/sched_ext/include/scx/compat.bpf.h
@@ -414,10 +414,10 @@ static inline void scx_bpf_reenqueue_loc
 }
 
 /*
- * v6.20: New scx_bpf_dsq_reenq() that allows re-enqueues on more DSQs. This
+ * v7.1: New scx_bpf_dsq_reenq() that allows re-enqueues on more DSQs. This
  * will eventually deprecate scx_bpf_reenqueue_local().
  */
-void scx_bpf_dsq_reenq___compat(u64 dsq_id, u64 reenq_flags, const struct bpf_prog_aux *aux__prog) __ksym __weak;
+void scx_bpf_dsq_reenq___compat(u64 dsq_id, u64 reenq_flags) __ksym __weak;
 
 static inline bool __COMPAT_has_generic_reenq(void)
 {
@@ -427,7 +427,7 @@ static inline bool __COMPAT_has_generic_
 static inline void scx_bpf_dsq_reenq(u64 dsq_id, u64 reenq_flags)
 {
 	if (bpf_ksym_exists(scx_bpf_dsq_reenq___compat))
-		scx_bpf_dsq_reenq___compat(dsq_id, reenq_flags, NULL);
+		scx_bpf_dsq_reenq___compat(dsq_id, reenq_flags);
 	else if (dsq_id == SCX_DSQ_LOCAL && reenq_flags == 0)
 		scx_bpf_reenqueue_local();
 	else


