Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76587303A1E;
	Sat, 25 Oct 2025 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408763; cv=none; b=cZeQVnBAIOX7oNg1KEkEtzZv74RP/2qoMt+5cmZjLVTx4CAO2UUBqBh7IdDzxD43Ob42PlsiLXwQyt3K7pQS/mUn5ckUSPP+DbfDqbGKMXiGXjPCo1/eQFJCUTVdomHv2bqpScBifC7q56WwI/sbr0stImpwwaPAhm23nnqmXHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408763; c=relaxed/simple;
	bh=0jWwah1zhTKumZp6Mb5YBVvNxs8JPcx2zvfeOuKDXeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BAsuuccdeUSg/YH72IHbRVIhYX9rpDE9yTh2bTF0H0Slx91suviDZuPnYDwp60jyJlk75torqZkrlWcjiMvZeS2/0fIRumorWe3FS+f1IRm445C/S7tcxsEzaJ1rDLDvqK/OSxtqizUc9bXkViICwWNtX/xKMK038uKQo9zKg8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EeaqrJZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EeaqrJZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57391C4CEF5;
	Sat, 25 Oct 2025 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408763;
	bh=0jWwah1zhTKumZp6Mb5YBVvNxs8JPcx2zvfeOuKDXeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeaqrJZH6zAAG5b1ul2MYUj25vRL9I42AQSA0E3YvwLfrs3LpT4/aT/r5BF2fHIEi
	 ytQiZSVv6cjRCvAXtNL15XV13a9Y+2j+TPrk6tqBN3dEwe3m7h4s41evNqnb52bJiu
	 3qDK3htwyW9wtVN3OpuFX2sqTCqrIBRInSfn4ZiMCZLkm4NqPg0r1cUNhgw0+w3hlb
	 cTyS8PGWxazmGFDX8ghDtD/6z/eZWS6NL4U32H7rR8NwzvE/fgvK3HHmjtaPbTWorV
	 u5SxunfxqO+LS4T1SR7zSBUtN0wKfPwJ/4r8e5rVWqXys9Ljxoa8gkC0aQXBDU0/Al
	 j+bMEHqxoKy5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nicolas.ferre@microchip.com,
	claudiu.beznea@tuxon.dev
Subject: [PATCH AUTOSEL 6.17-5.4] net: macb: avoid dealing with endianness in macb_set_hwaddr()
Date: Sat, 25 Oct 2025 11:54:54 -0400
Message-ID: <20251025160905.3857885-63-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 70a5ce8bc94545ba0fb47b2498bfb12de2132f4d ]

bp->dev->dev_addr is of type `unsigned char *`. Casting it to a u32
pointer and dereferencing implies dealing manually with endianness,
which is error-prone.

Replace by calls to get_unaligned_le32|le16() helpers.

This was found using sparse:
   ⟩ make C=2 drivers/net/ethernet/cadence/macb_main.o
   warning: incorrect type in assignment (different base types)
      expected unsigned int [usertype] bottom
      got restricted __le32 [usertype]
   warning: incorrect type in assignment (different base types)
      expected unsigned short [usertype] top
      got restricted __le16 [usertype]
   ...

Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250923-macb-fixes-v6-5-772d655cdeb6@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this should go to stable.

- `drivers/net/ethernet/cadence/macb_main.c:276-283` now programs the
  MAC address with `get_unaligned_le32()` / `get_unaligned_le16()`
  instead of casting `bp->dev->dev_addr` to wider pointers and
  dereferencing. Because `struct net_device::dev_addr` is only byte-
  aligned, the old `*((u32 *)...)` / `*((u16 *)...)` pattern could fault
  on architectures without efficient unaligned loads; this code runs
  every time the interface comes up (`macb_init_hw`,
  `macb_set_mac_addr`, `at91ether_open`), so the bug hits real users on
  strict-alignment platforms.
- The helpers retain the little-endian layout expectations of the
  hardware (the value is converted through `macb_or_gem_writel()` just
  as before), so behaviour remains unchanged on little-end systems while
  eliminating undefined behaviour on stricter CPUs. No other logic is
  touched, and the change is confined to two register writes.

Small, well-scoped bug fix with clear user impact and negligible
regression risk – good stable material. Next steps if you want extra
assurance: (1) boot a platform with `CONFIG_DEBUG_ALIGN_RODATA` / strict
alignment and bring the interface up; (2) sanity-check MAC programming
via `ip link show`.

 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index fc082a7a5a313..4af2ec705ba52 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -274,9 +274,9 @@ static void macb_set_hwaddr(struct macb *bp)
 	u32 bottom;
 	u16 top;
 
-	bottom = cpu_to_le32(*((u32 *)bp->dev->dev_addr));
+	bottom = get_unaligned_le32(bp->dev->dev_addr);
 	macb_or_gem_writel(bp, SA1B, bottom);
-	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
+	top = get_unaligned_le16(bp->dev->dev_addr + 4);
 	macb_or_gem_writel(bp, SA1T, top);
 
 	if (gem_has_ptp(bp)) {
-- 
2.51.0

