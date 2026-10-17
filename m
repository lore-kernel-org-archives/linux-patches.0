Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EB84CF461;
	Sat, 17 Oct 2026 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260076; cv=none; b=EY01Sdyr4B4zfdQPWwErUskulAD02I+bKwV5/DB78+dh1lBhaTWhujoqplBce0Skwp92uIEqJzfpf2Q+agFGwFrTUXDFCZ15RSLpNNs9iFrr1u0oR91KOf/xIuOijap8Qq/cGAlqemVGxTIWDM445K1u05ZcMjNHoKsg1dpao3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260076; c=relaxed/simple;
	bh=iAXnfMNCGhWwyuwDyrXVLWy6ntITpjIe4vhPklvKCOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXsnXh0pFP0+iDsjB1eQnwUdUUXfzNrdtWpBF+15vQaABv7ONxDWKXTrjIVuFpckzXTlfXS2//CXoaNqpv2BiyLIXobM+QVdMUqwxUCOv1YfHV7ZMZmwoykRiAbSwVRGCCSMuxTDV+disH3HaT21G1Twb0K/W+nTr+4XhiUu17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7xuIiKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7xuIiKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB751F000C4;
	Sat, 17 Oct 2026 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260075;
	bh=cXqYo9YpiHjp9vNgGNRgqXLhi/pEesLrrV+YKCRMpAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7xuIiKEAoFxK+4rsOo3zHB8WDjSDCHiOJOXWaMPmmh3L4VlDATIedPSnticWviLx
	 mIwbiqaxwPuViNVjhDI1v5PLX5ZUEWCuHvzLzFy/TAy8GjX66bov5uQenaKNKX95Tu
	 GjdsYm8T3IfOtJi/xsInhshIaCz0VJxMMahmpoVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1426/1674] bpf: Clear buf on error in __bpf_get_task_stack
Date: Sat, 17 Oct 2026 18:01:38 +0200
Message-ID: <20261017160507.785932639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f5d242825ca417bb6afe35fde6e8880f97ca43fb ]

Both bpf_get_task_stack and bpf_get_task_stack_sleepable helpers that
use __bpf_get_task_stack have buf defined as ARG_PTR_TO_UNINIT_MEM
argument and we should initialize the buf on every return path.

Adding missing buf memset for __bpf_get_task_stack fail paths. This
provides deterministic buffer contents, which is useful when the buffer
is used directly as a map key.

Fixes: 06ab134ce8ec ("bpf: Refcount task stack in bpf_get_task_stack")
Fixes: b992f01e6615 ("bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-10-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 648e9cebb517d..4db255334617c 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -493,14 +493,17 @@ BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
 	struct pt_regs *regs;
 	long res = -EINVAL;
 
-	if (!try_get_task_stack(task))
+	if (!try_get_task_stack(task)) {
+		memset(buf, 0, size);
 		return -EFAULT;
+	}
 
 	regs = task_pt_regs(task);
 	if (regs)
 		res = __bpf_get_stack(regs, task, NULL, buf, size, flags);
+	else
+		memset(buf, 0, size);
 	put_task_stack(task);
-
 	return res;
 }
 
-- 
2.53.0



