Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672162DF137;
	Thu, 16 Jul 2026 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209125; cv=none; b=RUb2z/DR/fk5NYGhrjMqZVqrkb6HgHA5MQ5F+1zMtjqrsAtEWIVSGK6gFIcaaMVyQP+24J9bQiTwxieXu670zReECzBiNYXR9jAUlM3trj7V8kx3364AfQROgwLj5PcXwypapYo47CL2s0fJicXkHfdSjd6DAy1ZefrOpmiisiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209125; c=relaxed/simple;
	bh=6kD6KXLmCtpZA0N5hP94AzDYctr0Cb8k8FIbp9ooQGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hg3Br/OYDLBY5mihWzjVMUSpg7DGR0cWCleRNmXPLk4wylwVwXPff81bR+RMXWQ1X9uxsjVgnzAgGnH4g2lzB8433EAgl4kSGe/tbrLoIu0ci4ywQAlP3uhBa95ky1iRteFKIjUSl8MPI1IIwgMLiDuC/jq1gCC/zyRPt25qEP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lW7fsfh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lW7fsfh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818C51F000E9;
	Thu, 16 Jul 2026 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209124;
	bh=YM+Aa9TGbtbTGQAp34sxKuila042C6UGk4acBB3n8mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lW7fsfh7ZlBt51FdR8QZC5agMtk12Wi2uOBBXrFvEMuJycYjJtDZnld8DIdRRGgTb
	 txbaor7sxe95JC4oQmFy4KN0n8r1TseMVTiYz0EWOTWWZuqJFzYLzJu/wcWrwgfMXt
	 zbypb/UM/rZwmOmeRNU5EJmHhK5/Ewtw4nQ7+Lvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 029/518] bpf: Prefer dirty packs for eBPF allocations
Date: Thu, 16 Jul 2026 15:24:57 +0200
Message-ID: <20260716133048.414692710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
index bba4acd61d4126..de61e1894452ef 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -988,10 +988,10 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool
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



