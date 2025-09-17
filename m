Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2625636D;
	Wed, 17 Sep 2025 12:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112655; cv=none; b=CRpkw4QIwqiUKgWyDBAeKXPYMuu+wZZNalAPch/ibQ7gNH9qVdIwWXpa0IOMBx40Ow9EFbPhnJNmw1bu3FmtzM4FzVQ2mwofeU19j8YSlC1sdKG+DP0bGDiV9xVkw7aG1hbnUAxTMpl8xES5iZTfQfGmWEjd0RFGb7kB0aHvlRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112655; c=relaxed/simple;
	bh=fTvUVdtQpykjR4xNfPfjOPwDUUdI8Gwrmvyj6ztS0AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zdy7ckkYxh4domCFb0xeoUKzkhtYISkpj6muS9bl9HWdSsQevh0Ho8AacLUtd0/LDIWwPuaLgnYstdo3WOra6O3DFsBONJpsGTSS1MCkZ7B2BZNT1NPkPprU9bjS/pLgUgzV+gR/CYlMxTFWWaMyqxxwTIHU5QdOTuPI02980c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7TEC3fD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7TEC3fD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DB5C4CEF0;
	Wed, 17 Sep 2025 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112654;
	bh=fTvUVdtQpykjR4xNfPfjOPwDUUdI8Gwrmvyj6ztS0AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7TEC3fDotaca6gc6E5TZLJZyknsDRCa5cJqr8nNKEX63EH4duirFDc3i9x9+MGl9
	 5pQ2riO1FxQh18xpBWGUjkSv7Mu4aD5yGQFNsmmDzOHoEYKD8fBR0I56f062jxUnC5
	 T9ktiisZW7HYg6CodoTzHV0bD2VfOvSwI8cy/zMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Chris Arges <carges@cloudflare.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 036/189] bpf, cpumap: Disable page_pool direct xdp_return need larger scope
Date: Wed, 17 Sep 2025 14:32:26 +0200
Message-ID: <20250917123352.740333422@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <hawk@kernel.org>

[ Upstream commit 2b986b9e917bc88f81aa1ed386af63b26c983f1d ]

When running an XDP bpf_prog on the remote CPU in cpumap code
then we must disable the direct return optimization that
xdp_return can perform for mem_type page_pool.  This optimization
assumes code is still executing under RX-NAPI of the original
receiving CPU, which isn't true on this remote CPU.

The cpumap code already disabled this via helpers
xdp_set_return_frame_no_direct() and xdp_clear_return_frame_no_direct(),
but the scope didn't include xdp_do_flush().

When doing XDP_REDIRECT towards e.g devmap this causes the
function bq_xmit_all() to run with direct return optimization
enabled. This can lead to hard to find bugs.  The issue
only happens when bq_xmit_all() cannot ndo_xdp_xmit all
frames and them frees them via xdp_return_frame_rx_napi().

Fix by expanding scope to include xdp_do_flush(). This was found
by Dragos Tatulea.

Fixes: 11941f8a8536 ("bpf: cpumap: Implement generic cpumap")
Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
Reported-by: Chris Arges <carges@cloudflare.com>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Chris Arges <carges@cloudflare.com>
Link: https://patch.msgid.link/175519587755.3008742.1088294435150406835.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 67e8a2fc1a99d..cfcf7ed57ca0d 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -186,7 +186,6 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 	struct xdp_buff xdp;
 	int i, nframes = 0;
 
-	xdp_set_return_frame_no_direct();
 	xdp.rxq = &rxq;
 
 	for (i = 0; i < n; i++) {
@@ -231,7 +230,6 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 		}
 	}
 
-	xdp_clear_return_frame_no_direct();
 	stats->pass += nframes;
 
 	return nframes;
@@ -255,6 +253,7 @@ static void cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu, void **frames,
 
 	rcu_read_lock();
 	bpf_net_ctx = bpf_net_ctx_set(&__bpf_net_ctx);
+	xdp_set_return_frame_no_direct();
 
 	ret->xdp_n = cpu_map_bpf_prog_run_xdp(rcpu, frames, ret->xdp_n, stats);
 	if (unlikely(ret->skb_n))
@@ -264,6 +263,7 @@ static void cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu, void **frames,
 	if (stats->redirect)
 		xdp_do_flush();
 
+	xdp_clear_return_frame_no_direct();
 	bpf_net_ctx_clear(bpf_net_ctx);
 	rcu_read_unlock();
 
-- 
2.51.0



