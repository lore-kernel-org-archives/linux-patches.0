Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BFB37E5DD;
	Fri,  7 Aug 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113848; cv=none; b=CEVarj7j7ruTbme1TxLsxkZ2DJKsCovAL3G6zVSMnIHGQj21ZnGJZ8s2MUFRmCiiD1OypX0lw9V2LdoeQMV039I1I59qPC+B1fcrpaHW7s59W0rJO57m59nyUNwAhOFPdBdhYppetzecBAJfMM4fNVyyANWjlPnJBl7A78qZ3bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113848; c=relaxed/simple;
	bh=1tfUMvklKdeofYzyVz+OHYBu4yxw7WGm8UFYylyKOq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsuDlgPAzZEMT2NoDcP1HJHoxjubQS/aHXiFLIrLhQ3H+w54Ub31bkc1KOykDyTyVZznA/6Z62jtjVnE7yfeP7w/qd63K1OWuYuOC2c1tg8BjEfF6rs3l0KfeYF47XvUzO0qLHzc4KXmhjVatrwEL9VLYplyaDOtYMXw6IMdlpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLOCGUHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLOCGUHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCD21F00A3E;
	Fri,  7 Aug 2026 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113831;
	bh=k0BVMmFkkqvOYcIZ854Ci4Wxy5msnIliBR1/c5qGLlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLOCGUHjnAeGsiLPS8bsGI/xLR1AellCyh57ISas589yxsBparIV+eIEK2S3ZMkMK
	 iWNU4lO55ZTfDVBeGpvuhD6BSma9RR0wqZx9omEQqVQaElSYp3of8YXoFw8VYbNDhh
	 C1v7wtlS+jYsbMFQn8wSqSqmbHSf12Ak8cofBPoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/337] netfilter: nft_payload: fix mask build for partial field offload
Date: Fri,  7 Aug 2026 16:34:13 +0200
Message-ID: <20260807143419.601701099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 39e88f28fb32bf02bd4b525c24c842c9cff5663d ]

nft_payload_offload_mask() builds the offload match mask for a payload
expression that covers only part of a header field.  For a partial IPv6
address match (field_len = 16, priv_len = 1) that shift is 1 << 120, which
is undefined on the 32-bit int operand.  It also trims only one word, so
the remaining words stay 0xffffffff (and when priv_len is a multiple of 4
the trim is skipped entirely), leaving the mask covering more bytes than
the rule matches.

  UBSAN: shift-out-of-bounds in net/netfilter/nft_payload.c:278:20
  shift exponent 120 is too large for 32-bit type 'int'
  ...

The match is byte-granular and struct nft_data is zero-initialised, so the
correct mask is simply the first priv_len bytes set to 0xff. Set those
bytes directly and drop the word/shift trimming; this removes the undefined
shift and no longer over-masks the trailing bytes.

Fixes: a5d45bc0dc50 ("netfilter: nftables_offload: build mask based from the matching bytes")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 36c31ad2d64c1..15feb49e0b663 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -253,9 +253,7 @@ static int nft_payload_dump(struct sk_buff *skb,
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 				     u32 priv_len, u32 field_len)
 {
-	unsigned int remainder, delta, k;
 	struct nft_data mask = {};
-	__be32 remainder_mask;
 
 	if (priv_len == field_len) {
 		memset(&reg->mask, 0xff, priv_len);
@@ -264,15 +262,7 @@ static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 		return false;
 	}
 
-	memset(&mask, 0xff, field_len);
-	remainder = priv_len % sizeof(u32);
-	if (remainder) {
-		k = priv_len / sizeof(u32);
-		delta = field_len - priv_len;
-		remainder_mask = htonl(~((1 << (delta * BITS_PER_BYTE)) - 1));
-		mask.data[k] = (__force u32)remainder_mask;
-	}
-
+	memset(&mask, 0xff, priv_len);
 	memcpy(&reg->mask, &mask, field_len);
 
 	return true;
-- 
2.53.0



