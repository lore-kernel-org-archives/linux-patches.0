Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5FA5101A;
	Mon, 11 Dec 2023 18:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vueaPbwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3042DC433C7;
	Mon, 11 Dec 2023 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319326;
	bh=KUhjLrSTViZLoDqcH33ztT9h8xIRQJxhEICrADM8Pb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vueaPbwoDT7Qk2YHlHhkUjS1T73cL95vsW07O45373PXXWgPhmC0W51hf2JErRZvL
	 eRwshlFD+BvgYksyWI4qHZUMVMICMfKaRo21ZUtqUzEcqf1wllgY9DqBifXDpcJqri
	 BSQzFgf+zx/pNBwFVsThY0MszF++z+30Yss2hFyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/244] netfilter: nf_tables: fix exist matching on bigendian arches
Date: Mon, 11 Dec 2023 19:19:16 +0100
Message-ID: <20231211182048.604547306@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 63331e37fb227e796894b31d713697612c8dee7f ]

Maze reports "tcp option fastopen exists" fails to match on
OpenWrt 22.03.5, r20134-5f15225c1e (5.10.176) router.

"tcp option fastopen exists" translates to:
inet
  [ exthdr load tcpopt 1b @ 34 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]

.. but existing nft userspace generates a 1-byte compare.

On LSB (x86), "*reg32 = 1" is identical to nft_reg_store8(reg32, 1), but
not on MSB, which will place the 1 last. IOW, on bigendian aches the cmp8
is awalys false.

Make sure we store this in a consistent fashion, so existing userspace
will also work on MSB (bigendian).

Regardless of this patch we can also change nft userspace to generate
'reg32 == 0' and 'reg32 != 0' instead of u8 == 0 // u8 == 1 when
adding 'option x missing/exists' expressions as well.

Fixes: 3c1fece8819e ("netfilter: nft_exthdr: Allow checking TCP option presence, too")
Fixes: b9f9a485fb0e ("netfilter: nft_exthdr: add boolean DCCP option matching")
Fixes: 055c4b34b94f ("netfilter: nft_fib: Support existence check")
Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c | 4 ++--
 net/netfilter/nft_fib.c    | 8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 3fbaa7bf41f9c..6eb571d0c3fdf 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -214,7 +214,7 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 
 		offset = i + priv->offset;
 		if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-			*dest = 1;
+			nft_reg_store8(dest, 1);
 		} else {
 			if (priv->len % NFT_REG32_SIZE)
 				dest[priv->len / NFT_REG32_SIZE] = 0;
@@ -461,7 +461,7 @@ static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
 		type = bufp[0];
 
 		if (type == priv->type) {
-			*dest = 1;
+			nft_reg_store8(dest, 1);
 			return;
 		}
 
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 04b51f2853321..ca905aa8227e5 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -145,11 +145,15 @@ void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 		index = dev ? dev->ifindex : 0;
-		*dreg = (priv->flags & NFTA_FIB_F_PRESENT) ? !!index : index;
+		if (priv->flags & NFTA_FIB_F_PRESENT)
+			nft_reg_store8(dreg, !!index);
+		else
+			*dreg = index;
+
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
 		if (priv->flags & NFTA_FIB_F_PRESENT)
-			*dreg = !!dev;
+			nft_reg_store8(dreg, !!dev);
 		else
 			strscpy_pad(reg, dev ? dev->name : "", IFNAMSIZ);
 		break;
-- 
2.42.0



