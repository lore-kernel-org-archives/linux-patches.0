Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C0418DB17;
	Wed, 23 Apr 2025 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420065; cv=none; b=u+IIKcrXYqCydjymk9BM8oEfDdNmEY8iGtFVLunnQB4JYHgBa0ktnda9jW7KQpCoHet0xaSXS6NPo8lhw/URfvu6+m0DswLwrZs5lZ7P5egj5DaG6oVE3DIhrI5vm93ZB0RPuIZrXDYVFbIOtJlNuJTYjFTF8WjIXqyQEp5fmdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420065; c=relaxed/simple;
	bh=Sff0duBx82M+qCZHPvFycu5ZmEdO85uOL6C3h2iUzR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTvrKYLM/4S5HLjMtMcOYqokaDpK8NDE+5GMDfIvKj8G6zugpstZXaGnrrRTldB1rRZDgDBjU5aWfDcMtZJA9RkMhsw+WcO2O3zW7lMTZUx3GW2ahifl4hJeCNRE2NHN0xg3viaxQsdBTIZLVKR60zvuTDhDxT+LQYqClfa+r4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=om1/JVE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om1/JVE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA7EC4CEE2;
	Wed, 23 Apr 2025 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420065;
	bh=Sff0duBx82M+qCZHPvFycu5ZmEdO85uOL6C3h2iUzR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=om1/JVE/JPeKevztIAAVBgBS9o9hiRZk+5L2Us4MGxMY47eMtME87Kv4N1Wxd9m5W
	 vx2ehxJzxJ5NvwYsCC219XNmZMp/CXALF8RfSBKiHFXIECiCbonaKafx99On9Lfl1i
	 ppiNpbxgo6VoHDEI6Y3Qr5TAUYSqEvgAspfkOAwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sontu mazumdar <sontu21@gmail.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/393] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
Date: Wed, 23 Apr 2025 16:38:51 +0200
Message-ID: <20250423142644.738076598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e042ed950d4e176379ba4c0722146cd96fb38aa2 ]

Given a set element like:

	icmpv6 . dead:beef:00ff::1

The value of 'ff' is irrelevant, any address will be matched
as long as the other octets are the same.

This is because of too-early register clobbering:
ymm7 is reloaded with new packet data (pkt[9])  but it still holds data
of an earlier load that wasn't processed yet.

The existing tests in nft_concat_range.sh selftests do exercise this code
path, but do not trigger incorrect matching due to the network prefix
limitation.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Reported-by: sontu mazumdar <sontu21@gmail.com>
Closes: https://lore.kernel.org/netfilter/CANgxkqwnMH7fXra+VUfODT-8+qFLgskq3set1cAzqqJaV4iEZg@mail.gmail.com/T/#t
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index b8d3c3213efee..c15db28c5ebc4 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -994,8 +994,9 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(5, lt,  8,  pkt[8], bsize);
 
 		NFT_PIPAPO_AVX2_AND(6, 2, 3);
+		NFT_PIPAPO_AVX2_AND(3, 4, 7);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(7, lt,  9,  pkt[9], bsize);
-		NFT_PIPAPO_AVX2_AND(0, 4, 5);
+		NFT_PIPAPO_AVX2_AND(0, 3, 5);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt, 10, pkt[10], bsize);
 		NFT_PIPAPO_AVX2_AND(2, 6, 7);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(3, lt, 11, pkt[11], bsize);
-- 
2.39.5



