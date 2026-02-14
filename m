Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF17A142E83;
	Sat, 14 Feb 2026 21:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104370; cv=none; b=IkjXULV2eKkD3NlEoqMRqMI1v3zbSnoG4/TNsayx06sGCLE6wQGuc2S+W/IDJd0pdGx5ubDzMbV/9dPysZcmCvO+Pjp9bIlfcWfTXOLXi+QpAGG6JmJyn6+DkpbkM1WkqPI2qDJURvcODraVDpo67J9w0LsuzSCrdvE6Cofs0/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104370; c=relaxed/simple;
	bh=Onzrktd5vADawuAhphT9wgldwaxCtyshJhJuIApQSE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzvW48jT7U3ON1RMcp/UtEc0USTeEr/MQ+ITasB3bXcpvvOhLJlIFKSvEMMccHQSL3YxddDiG4LmaaYxOeYhsgtxwBMSaWfR01c3rQSUI8r0UA4yKt5SP916Sxzb/y1DhwPGfbrWmIza7cS1/8VqHEXfpGcJxquhU7Dw7EtiDw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJ7MWlua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJ7MWlua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D46EC19422;
	Sat, 14 Feb 2026 21:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104370;
	bh=Onzrktd5vADawuAhphT9wgldwaxCtyshJhJuIApQSE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJ7MWluadm7eO3wk+0sTI2LsjsK++N8ImUv46D4mvzYynoXfU7UMCfFs5ssFVSzQw
	 19wa39357DMwONxE2y1tVpi1aZZ9lR//gcssw7k0C0GvqHss8GxUablZKZpxBUtOuU
	 M+S8CZhkcguQwlwIKUIbiSGrVU6QhLK+ot/TKsHX2L32isttpkFv3Egn0h4xNFu+C6
	 fW4Iq3OjVY+apm98dH5SuGk3sSq6BtZ1I/Zz8AuSOnLEHEl5iOoisuleQfwcTc0bh5
	 Zdh5ATjcX3l29beM2L6E06GcK9kPEmVoDij9rrRhHEisyI+5syJwNMUbZCGCM4B/y+
	 0Qvl7IfnvOmfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Geetha sowjanya <gakula@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sgoutham@marvell.com,
	lcherian@marvell.com,
	jerinj@marvell.com,
	hkelam@marvell.com,
	sbhatta@marvell.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] octeontx2-af: Workaround SQM/PSE stalls by disabling sticky
Date: Sat, 14 Feb 2026 16:23:12 -0500
Message-ID: <20260214212452.782265-47-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 70e9a5760abfb6338d63994d4de6b0778ec795d6 ]

NIX SQ manager sticky mode is known to cause stalls when multiple SQs
share an SMQ and transmit concurrently. Additionally, PSE may deadlock
on transitions between sticky and non-sticky transmissions. There is
also a credit drop issue observed when certain condition clocks are
gated.

work around these hardware errata by:
- Disabling SQM sticky operation:
  - Clear TM6 (bit 15)
  - Clear TM11 (bit 14)
- Disabling sticky → non-sticky transition path that can deadlock PSE:
  - Clear TM5 (bit 23)
- Preventing credit drops by keeping the control-flow clock enabled:
  - Set TM9 (bit 21)

These changes are applied via NIX_AF_SQM_DBG_CTL_STATUS. With this
configuration the SQM/PSE maintain forward progress under load without
credit loss, at the cost of disabling sticky optimizations.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260127125147.1642-1-gakula@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The register definition exists in the codebase, and the code modifying
it exists. This is a self-contained change that modifies existing
initialization code — no new dependencies needed.

### 8. Summary

**What it fixes**: Hardware errata causing network stalls, PSE deadlock,
and credit drops on OcteonTX2 hardware under concurrent transmission
load.

**Why it matters for stable**: Users running OcteonTX2 hardware on
stable kernels will experience these hardware bugs (stalls, deadlocks,
packet loss) without this workaround. These are reliability/availability
issues for networking hardware commonly used in production.

**Meets stable rules**:
- Obviously correct: Simple register bit manipulation with clear
  documentation
- Fixes real bugs: Hardware stalls, deadlocks, and credit drops
- Small and contained: Single file, ~10 lines of actual change
- No new features: Hardware errata workaround only
- Reviewed by networking maintainers

**Risk**: Minimal. Only affects OcteonTX2 hardware initialization. The
trade-off (disabling sticky optimizations) is explicitly acknowledged
and accepted.

**YES**

 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 2f485a930edd1..49f7ff5eddfc8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4938,12 +4938,18 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	/* Set chan/link to backpressure TL3 instead of TL2 */
 	rvu_write64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL, 0x01);
 
-	/* Disable SQ manager's sticky mode operation (set TM6 = 0)
+	/* Disable SQ manager's sticky mode operation (set TM6 = 0, TM11 = 0)
 	 * This sticky mode is known to cause SQ stalls when multiple
-	 * SQs are mapped to same SMQ and transmitting pkts at a time.
+	 * SQs are mapped to same SMQ and transmitting pkts simultaneously.
+	 * NIX PSE may deadlock when there are any sticky to non-sticky
+	 * transmission. Hence disable it (TM5 = 0).
 	 */
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS);
-	cfg &= ~BIT_ULL(15);
+	cfg &= ~(BIT_ULL(15) | BIT_ULL(14) | BIT_ULL(23));
+	/* NIX may drop credits when condition clocks are turned off.
+	 * Hence enable control flow clk (set TM9 = 1).
+	 */
+	cfg |= BIT_ULL(21);
 	rvu_write64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS, cfg);
 
 	ltdefs = rvu->kpu.lt_def;
-- 
2.51.0

