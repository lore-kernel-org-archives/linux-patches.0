Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B4389104;
	Tue, 13 Oct 2026 11:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892520; cv=none; b=HCfxc7NqyArKE2MXiJZJvUeg7nBnlT7vC2JgVhPerHaxFsfaBQ2N8dUDCm6+9XT5ySbEv3acb2U8NDDm/w+4ChQXyMc8i6jQm8yC7Gqe2CgkQLSxYAh++P2aW3fZtRibgIt7MTBJot/ocupHTBKhg5IUcyOBumaWIfyFS1bvUzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892520; c=relaxed/simple;
	bh=sMhZkrfQjQYsQiCHiUEwgBFyWo7WTV6vRdlhMLDTtkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3axV+x6X1L7WIw+agibqYbJSmOqi1YsWI16N4C5MAZMstCSSEzaT+qHJzQJipP37f3+LqyNkKhzA6HbcKLFEyzPK9IH/5zBkHtysSFBuk8BfAud7gNyeaq5btJKI9L1TZtzBOH5j5hLwxGAhLUZCx0WxIw8BSv1epkU+7OH2nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dpbdfVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dpbdfVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86341F000FF;
	Tue, 13 Oct 2026 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892518;
	bh=i1VL15RO8h4zXdE366PxepNTS9yKZbk/XEjsjaJcq40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dpbdfVc2gqdL/2Tt7hVWRXoNCQvDKglStalKE4n0jwskxqMvDs7WWvQlntNlIpAT
	 Xn38AAYHJAHWIaasj7tQU7S9F4ln9tauGQhPoGvafXN5Lc/bhLYZJRpu2PiC7Nct+p
	 kOtqrV68jHzZ7Sl9IDhES3iCVXV07uJ7B7WOtHPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 199/281] lib/dim: fix 32-bit overflow in dim_calc_stats() rates
Date: Tue, 13 Oct 2026 13:38:35 +0200
Message-ID: <20261013112859.994366632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Shashank Mohan Jain <jain.sm@gmail.com>

[ Upstream commit 0843b23890642a02ff85c36406224e8874e30664 ]

dim_calc_stats() computes the per-millisecond rates as

	DIV_ROUND_UP(nbytes * USEC_PER_MSEC, delta_us)

where nbytes is a u32 and USEC_PER_MSEC is 1000L. On 64-bit the product
is done in 64-bit long arithmetic, but on 32-bit architectures long is
32 bits wide and the product wraps as soon as a measurement window
carries more than 4294967 bytes (about 4.3 MB). The same applies to the
packet and completion counts, although those need more than 4.29
million packets or completions per window.

A DIM window spans DIM_NEVENTS (64) events. Drivers count events per
interrupt or per NAPI poll, so under sustained load a window can easily
carry more than 4.3 MB: 64 full NAPI polls of 64 MTU-sized frames are
already 6.2 MB, and drivers such as mtk_eth_soc count one event per
interrupt while NAPI keeps polling with the interrupt masked. On 32-bit
users of the library (for example mtk_eth_soc on MT7621, bcmgenet and
bcmsysport on 32-bit ARM, or virtio_net in a 32-bit guest) bpms then
becomes the product modulo 2^32 divided by the window length, and
net_dim_stats_compare() makes its BETTER/WORSE decisions on a value
that has little to do with the real throughput.

For example, a 1 Gbit/s link at line rate that moves 5 MB in a 40 ms
window gives bpms = 125000 on 64-bit but 17626 on 32-bit, and 5 million
packets in 2 s gives ppms = 353 instead of 2500.

Widen the products to 64 bits and divide with DIV_ROUND_UP_ULL(). The
results are unchanged on 64-bit.

Fixes: cb3c7fd4f839 ("net/mlx5e: Support adaptive RX coalescing")
Fixes: 4c4dbb4a7363 ("net/mlx5e: Move dynamic interrupt coalescing code to include/linux")
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dim/dim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/dim/dim.c b/lib/dim/dim.c
index 97c3d084ebf02..7f3eebae73cb9 100644
--- a/lib/dim/dim.c
+++ b/lib/dim/dim.c
@@ -69,11 +69,15 @@ bool dim_calc_stats(const struct dim_sample *start,
 	if (!delta_us)
 		return false;
 
-	curr_stats->ppms = DIV_ROUND_UP(npkts * USEC_PER_MSEC, delta_us);
-	curr_stats->bpms = DIV_ROUND_UP(nbytes * USEC_PER_MSEC, delta_us);
+	/* u32 * USEC_PER_MSEC overflows a 32-bit long */
+	curr_stats->ppms = DIV_ROUND_UP_ULL((u64)npkts * USEC_PER_MSEC,
+					    delta_us);
+	curr_stats->bpms = DIV_ROUND_UP_ULL((u64)nbytes * USEC_PER_MSEC,
+					    delta_us);
 	curr_stats->epms = DIV_ROUND_UP(DIM_NEVENTS * USEC_PER_MSEC,
 					delta_us);
-	curr_stats->cpms = DIV_ROUND_UP(ncomps * USEC_PER_MSEC, delta_us);
+	curr_stats->cpms = DIV_ROUND_UP_ULL((u64)ncomps * USEC_PER_MSEC,
+					    delta_us);
 	if (curr_stats->epms != 0)
 		curr_stats->cpe_ratio = DIV_ROUND_DOWN_ULL(
 			curr_stats->cpms * 100, curr_stats->epms);
-- 
2.53.0



