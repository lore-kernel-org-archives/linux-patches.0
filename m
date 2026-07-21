Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D28471246;
	Tue, 21 Jul 2026 19:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661035; cv=none; b=F5bt4SKHHxH3b7iSMHd3HQ/x+1g8iEtX+2NFXiTenvmyOWQ1lvPvmx41a8jx2F2hNv4EqcWAdbU7Ra/25fVc0K5FSa2j9mWjFyKQED/QBsyzgo0GLx8P2mOq4lgIzR42dWrvQKMIvzhzfiun1sovpPwp+AUOKZObfGl4tv432h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661035; c=relaxed/simple;
	bh=mq8Mgt4q0wr0JgtS+1NgNvMOhHtj5SSCJy5UTUUWsy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmJMQeuJtgDN6Hd4BJA/o0iqh2255KvJuIU3l8bhASUm6asfZNIqxE+pjv2lzRdPU4i0wlbKTUYVSF+keVsYn6AIeCgkP0IDxBoHnpy7vFTgluIXGokhFOzMX0YXvgkK8/6ErznozD5L7pJ7D3nYbVqQcxuby7eIuiTnSZMkNN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPn4riuJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPn4riuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE051F000E9;
	Tue, 21 Jul 2026 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661034;
	bh=dInbZwKeIxNQ7TiBrNVMc89fEFXUrvruQOaLeWB/vcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPn4riuJkJMj14oy6yuut/TyovJKuo9z3InlE2TPrTtz9rEuwTFJg21EctPx8waWh
	 1CLIkMHzFHot4KSJOSO1xlYF5eUOlDKHVPe5kQEZkrgPg9QgLRp3M3SG9tAwEcS5r4
	 5/Tq57ANjVnh3B6LfBCr7vcgOQ1qmNS0qfEGV1Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1207/2077] bpf: Preserve pointer spill metadata during half-slot cleanup
Date: Tue, 21 Jul 2026 17:14:40 +0200
Message-ID: <20260721152621.282205183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit 3a354149bceacadbcf7d7b4766f5ef26a85892ab ]

__clean_func_state() cleans dead stack slots in 4-byte halves. When the
high half of a STACK_SPILL slot is dead and the low half remains live,
cleanup converts the live low half to STACK_MISC or STACK_ZERO and clears
the saved spilled_ptr metadata.

That conversion is safe only for scalar spills. For a pointer spill, this
metadata clear lets a later 32-bit fill from the still-live half avoid the
normal non-scalar register-fill check and be treated as an ordinary scalar
stack read.

Leave non-scalar spill slots intact in this half-live shape. This is
conservative for pruning and preserves the existing
check_stack_read_fixed_off() rejection path for partial fills from pointer
spills.

Fixes: be23266b4a08 ("bpf: 4-byte precise clean_verifier_state")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/r/20260617-f01-06-half-slot-pointer-spill-v2-1-42b9cdc3cf64@mails.tsinghua.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/states.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index 8478d2c6ed5b62..1dd99b3194d7c7 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -437,12 +437,10 @@ static void __clean_func_state(struct bpf_verifier_env *env,
 				continue;
 
 			/*
-			 * Only destroy spilled_ptr when hi half is dead.
-			 * If hi half is still live with STACK_SPILL, the
-			 * spilled_ptr metadata is needed for correct state
-			 * comparison in stacksafe().
-			 * is_spilled_reg() is using slot_type[7], but
-			 * is_spilled_scalar_after() check either slot_type[0] or [4]
+			 * Only scalar spills can be degraded to raw stack bytes
+			 * when their high half is dead. Pointer spills need the
+			 * saved spilled_ptr metadata so partial fills keep
+			 * rejecting as non-scalar register fills.
 			 */
 			if (!hi_live) {
 				struct bpf_reg_state *spill = &st->stack[i].spilled_ptr;
@@ -450,6 +448,9 @@ static void __clean_func_state(struct bpf_verifier_env *env,
 				if (lo_live && stype == STACK_SPILL) {
 					u8 val = STACK_MISC;
 
+					if (spill->type != SCALAR_VALUE)
+						continue;
+
 					/*
 					 * 8 byte spill of scalar 0 where half slot is dead
 					 * should become STACK_ZERO in lo 4 bytes.
-- 
2.53.0



