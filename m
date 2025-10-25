Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9733043C3;
	Sat, 25 Oct 2025 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408690; cv=none; b=KVrc36GoZX0hVE6xQbsdEabA6lBTXkowcuZUXgOE3PXcS3zge++dtMRl/SAivBZ2+QiBGZj1DzA0d9y0hK/yFl6kpSEB1C77V7+9QHuYVB4bhT1hCOmkMmJFDZXM+vrsHAJZecsQ3a0iRs+ijQHtgf9dbHMRA19CnvBmXBzBqBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408690; c=relaxed/simple;
	bh=vrmfGPPZkkFSTu8sMYYwr9TG++mbACEvOKTUh9kuzwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fqmwl/Q/9JkoTIl+bSFRzBNVeVFl7e0pLmFl6fDh/uHNfrNKniU7EhaguIGe4AYG4A8wVv881tUEqZBcKSVzjIzWnl+AJymprkPoUSWy0/ozqRWHw1lzV5UIHet2bxb/v0oJ7WLFEqGpP4CuQJhSSFZJCZwA6Vojwp58md8LTJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtFGxYzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtFGxYzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B243AC4CEFB;
	Sat, 25 Oct 2025 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408690;
	bh=vrmfGPPZkkFSTu8sMYYwr9TG++mbACEvOKTUh9kuzwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtFGxYzgw9mkwhoWbVyMBwFgof4ZvEFQOhYmsHQd4b+fruOvuy/YcMb05g9c1AGAl
	 Vqasrl4pkSgoBiH27S+clZjTzyqRDFLoUVhzUxgc8ZSC1ye318FJRz7uiUor+vkk+0
	 agsSqw0VQIsi5ebdvRvZ1EIyLy9JAIBYORHUbG7Jz41UqEp69GafZnx9hUigwEhD8K
	 YamrvaNKypV7Lx5xvn4kSV7+pPmQS/CVJMngB5yHeJR4NL4HjaedXLKVOVyoRe1jVU
	 MhBc15p+Sb3HvcrGedFEWSKHLSlbomLJUjDWqN1ciCnLXsjTrQLxgrWtxKg/8yhiMD
	 iuUcn36IEth6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	rmk+kernel@armlinux.org.uk,
	andrew@lunn.ch,
	0x1207@gmail.com,
	pabeni@redhat.com,
	alexandre.f.demers@gmail.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] net: stmmac: Correctly handle Rx checksum offload errors
Date: Sat, 25 Oct 2025 11:54:33 -0400
Message-ID: <20251025160905.3857885-42-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit ee0aace5f844ef59335148875d05bec8764e71e8 ]

The stmmac_rx function would previously set skb->ip_summed to
CHECKSUM_UNNECESSARY if hardware checksum offload (CoE) was enabled
and the packet was of a known IP ethertype.

However, this logic failed to check if the hardware had actually
reported a checksum error. The hardware status, indicating a header or
payload checksum failure, was being ignored at this stage. This could
cause corrupt packets to be passed up the network stack as valid.

This patch corrects the logic by checking the `csum_none` status flag,
which is set when the hardware reports a checksum error. If this flag
is set, skb->ip_summed is now correctly set to CHECKSUM_NONE,
ensuring the kernel's network stack will perform its own validation and
properly handle the corrupt packet.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250818090217.2789521-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Bug fixed and user-visible
  - Current code marks all IP packets as hardware-verified when Rx
    checksum offload is enabled, even if hardware flagged a checksum
    error. See
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:5738-5741: it sets
    `skb->ip_summed = CHECKSUM_UNNECESSARY` whenever `coe` is enabled
    and the packet has an IP ethertype, without considering hardware
    error status.
  - With enhanced descriptors, the hardware reports header or payload
    checksum failures via the `csum_none` status. The driver currently
    ignores this and can pass corrupted packets up the stack as if
    checksum was valid.

- What the patch changes
  - The patch adds the hardware error check to the decision: if `status
    & csum_none` is set, the driver does not mark the checksum as
    verified. Concretely, it changes the condition to
    - from: `if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb)) ...
      else skb->ip_summed = CHECKSUM_UNNECESSARY;`
    - to: `if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb) ||
      (status & csum_none)) ... else skb->ip_summed =
      CHECKSUM_UNNECESSARY;`
  - This ensures `skb->ip_summed` remains `CHECKSUM_NONE` (asserted by
    `skb_checksum_none_assert(skb)`), so the network stack will
    compute/verify checksums in software and properly drop/handle
    corrupted packets.

- Why this is correct
  - For enhanced descriptors, the driver maps hardware status
    combinations indicating IP header or payload checksum errors to
    `csum_none` (i.e., “checksum not good”). See
    drivers/net/ethernet/stmicro/stmmac/enh_desc.c:105, 107, 109 where
    `enh_desc_coe_rdes0()` returns `csum_none` when the hardware
    indicates header/payload checksum errors.
  - The `csum_none` bit is explicitly defined as an Rx frame status in
    drivers/net/ethernet/stmicro/stmmac/common.h:343 (`enum
    rx_frame_status { ... csum_none = 0x2, ... }`).
  - Normal descriptor paths already drop errored frames early (e.g., see
    drivers/net/ethernet/stmicro/stmmac/norm_desc.c:52-100), so this
    change primarily corrects behavior for enhanced descriptors.

- Scope and risk
  - The change is small, localized to a single if-condition in
    `stmmac_rx()`. No architectural changes, no ABI changes.
  - If `csum_none` is set, the fix only downgrades to software
    verification, which is conservative and safe. The worst-case impact
    is mild extra CPU work for packets with checksum errors, which is
    acceptable.
  - For hardware/paths that never set `csum_none` (e.g., normal
    descriptors), behavior is unchanged.

- Security and correctness impact
  - Previously, packets with failed L3/L4 checksum could be marked as
    checksum-validated and accepted by upper layers. This is a
    correctness bug with potential security implications (transport-
    layer checksum bypass). The patch prevents that by forcing software
    verification when hardware signals errors.

- Additional note for completeness
  - There is a similar unconditional checksum-trust in the zero-copy/XDP
    dispatch path:
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:5221-5224. It uses
    the same pattern and likely needs the same `(status & csum_none)`
    check. While not a blocker for this fix, stable trees should
    consider pulling a companion patch for the ZC path to ensure
    consistent behavior across receive paths.

- Stable backport criteria
  - Important bugfix affecting data integrity/correctness.
  - Minimal, contained change in a driver subsystem.
  - No new features, no architectural change, low regression risk.
  - Clear positive safety/security implications.

Given the above, this commit is a strong candidate for backporting to
stable trees.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b9f55e4e360fb..7a375de2258c4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5735,7 +5735,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
+		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb) ||
+		    (status & csum_none))
 			skb_checksum_none_assert(skb);
 		else
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.51.0

