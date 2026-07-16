Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF6B3FE660;
	Thu, 16 Jul 2026 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211294; cv=none; b=Mx/x+SOpEW0Gv+QsYHr9OtGYHm5ptzgZraFXyTs/fegO0cF1B5o5/EUgRKj7XZfQXHjBI3CzxfFbquhcTOq1n7UoWMkVW54q2seTfJCTwBUU1XXqFpSLXxhUjx35ViWOeF6qql7FA/w8kZqgqxsVv0HXjIZkuFrhJ2pq0gtLiU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211294; c=relaxed/simple;
	bh=y5992fomf7Fjj3vE1nhZIiotf9jUdyeQKLJ/areFr+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCHzx3MK6mQhFlsVvwmM94C702RZ0omSlKKp3JKAcERs33dgVnCekVZ7a0smaHZ3aqUDIS3uZkP3kK3cPpVSHbY0jyVxN2eXtQ+vZ3ndBL8VFUKuecOB+qA4Uj6LgTRE317MncHF7JISU7G46JASzaW9XPpk1M3DKdcQruMkNO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNbAWye7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNbAWye7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D79B1F000E9;
	Thu, 16 Jul 2026 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211293;
	bh=c+iQyqN0/mDQZGGzEarEy3eAbzYvvIu3kUEi3E/SWXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNbAWye7Qu3KdibrZWopAGu7kEvMA99/g6zdjHSQ2JOr4N8whsbf97xjFiVH0CvWL
	 TmGwy5518XFcREMWG+Z9tYXYYRn+2E2bVMob9kP/A5ZbR6ZFwfAa/lX4u3Mdz5+JZK
	 nDXaGz83teeycz9aNPe9zP4kBxw5AFzFHaz88NQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 330/480] bpf: Prefer dirty packs for eBPF allocations
Date: Thu, 16 Jul 2026 15:31:17 +0200
Message-ID: <20260716133051.954949996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e0ffdd985eb5d7..b102704f89bc77 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -970,10 +970,10 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool
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



