Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5971282F29;
	Mon, 17 Aug 2026 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979065; cv=none; b=lP3FuXnwKMiovmCDrDA8eMbR9oTXAbtqPjA5xPJ0t6Tfpw5e71MbTFiOzr8CyJAYXhDLkVEr3yqInrXb37klgJsm7PPsG4nV5ktEF91A1piJ+F9lvnzycrnxBJqVC2IsF2z1gZjd0CpixeJUWoL7UvfsaeY2h04rhwwHIQiMGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979065; c=relaxed/simple;
	bh=jhUEtpf/5PXFo1DLXzA8ioDgnNwlO7iCP1jOqNLf7Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUzRtGPf/6mJ9jVfvWkEf1aWa2SDkykbWID7nXN0X4LX1oYkhqU8sM5uNcw0mkzU1tOadjZawybwL6/lRwSwJ0CQvtE0GrCt5o4RtUo/N1h/uk8TOfFZuXGg93Y4S54IgeJcnmrB+pSgtlc2gvTKcnEp57IhanIZ4bowcFWZYwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5Aau4xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5Aau4xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5B21F00A3D;
	Mon, 17 Aug 2026 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979064;
	bh=oY4UdJnk4Oi9Ls2hPSgdUzUUR0Fhi+I//aTTjDDTfZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5Aau4xPLltl/ZbQpXv6kDBpumoKIFzFD1+wVJQRnuFGkUY54MqNCSAtzGb0hcK/5
	 jFRrDAp05PhFGbGshmBZFw3bVPT7rJc95KIRzByfKOKkrv3OoTkr9LxL6AiRyfjTVN
	 QSyERxmJAtI0cyMbubkkbX2naD+e2h/kqd96x/Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/609] bpf: Prefer dirty packs for eBPF allocations
Date: Mon, 17 Aug 2026 15:26:31 +0200
Message-ID: <20260817132546.835765509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit b72e29e0f7ee329d89f86db8700c8ea99b4a370a upstream.

The pack allocator only flushes predictors when reusing a dirty pack for
cBPF, eBPF allocations never trigger a flush. Currently, eBPF picks the
first free pack, which could be a clean pack. As an optimization, leaving
a clean pack for cBPF can avoid flushes.

Prefer dirty packs for eBPF and keep clean packs free for cBPF. This
mirrors the existing cBPF preference for clean packs: each program kind
prefers the pack that avoids an extra flush, and falls back to the other
kind only when no preferred pack has room. eBPF reuse of a dirty pack is
harmless since eBPF being privileged does not flush.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 926bf11aeaf21a..4ea21434bf78e6 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -946,10 +946,10 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool
 			goto found_free_area;
 		/*
 		 * cBPF reuse of a dirty pack triggers a flush, so prefer a
-		 * clean pack for cBPF. eBPF never flushes, so pick the first
-		 * free pack, dirty or clean.
+		 * clean pack for cBPF. eBPF never flushes, so steer it to a
+		 * dirty pack and keep clean packs free for cBPF.
 		 */
-		if (!was_classic || !pack->arch_flush_needed)
+		if (was_classic ^ pack->arch_flush_needed)
 			goto found_free_area;
 		if (!fallback_pack) {
 			fallback_pack = pack;
-- 
2.53.0



