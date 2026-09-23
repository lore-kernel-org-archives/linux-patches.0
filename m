Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071F247F2E0;
	Wed, 23 Sep 2026 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172939; cv=none; b=EHhdSGBzXvYge4AR1Uff+n1KyUV1yUZSSCwlDozUVXoXwobr+ZlZ05bHoSuDUeQLb5L8cj+9FXHjVxVXy4VRSUCl0M8JwOOJ2T0Oyd1+RmKUMn3BMX97Xz4kn7NIKVX1j8E86/fqxqDsktbj1xbEGWsMZnEIdlMW/c4mCZTLlR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172939; c=relaxed/simple;
	bh=koi2knfh81rByhQVMmV92w5ItVx/u2VCw0r0k02MO+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7doXILMzlT423NVpg6FvdBZ16DwUmuo6C8l++1v6fqsgSCDMmPuLwazPwpkNIMFO+U6Ocr5U24X18fUYVAw6x0+9AT4IOmA352AFykx9x0YIyG/2cy/jlmi6hCzfRozOueoKAiJDVkqwcTBT+rDUSBXoo59BVydn/WzBVQ/ca0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOlBl736; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOlBl736"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FF21F000FF;
	Wed, 23 Sep 2026 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172937;
	bh=k3UH/X95OJcvKWQF/WZDmBqTT6J2Oy0A0u18UFRFccc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOlBl736h/i0oJ5JNLJs0B1uNRvogvo/cxJUH7/3tuHPdk93ZwQQq5f9iCMiBUsHb
	 aE98hCXAQoqLsalJVXWSfiqp6tyPt1uyY9b6/Ytl21tZFWQCYPT78NUUgtw/QFftJE
	 HIYE6VedwXyNVmHrTEljwEcp94Xwm+xIEtUXBg9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 105/438] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Wed, 23 Sep 2026 16:02:06 +0200
Message-ID: <20260923140647.503443722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

[ Upstream commit d313499df66159b4b7971d760d16729598ab7e5a ]

nft_nat_setup_netmap() builds the mapped address in an on-stack
union nf_inet_addr. For an IPv4 mapping it writes only the 4-byte .ip
member and the loop runs a single 32-bit iteration, but it then copies
the whole 16-byte union into range->min_addr and range->max_addr, so the
upper 12 bytes reach nf_nat_setup_info() uninitialised.

KMSAN reports an uninit-value in nf_nat_setup_info() reached from
nft_nat_eval(). The IPv6 path fills all 16 bytes and is not affected.

Zero-initialise new_addr.

Fixes: 3ff7ddb1353d ("netfilter: nft_nat: add netmap support")
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e32cd9fbc7c2e..cdbd800cac969 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -64,8 +64,8 @@ static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
 				 const struct nft_pktinfo *pkt,
 				 const struct nft_nat *priv)
 {
+	union nf_inet_addr new_addr = {};
 	struct sk_buff *skb = pkt->skb;
-	union nf_inet_addr new_addr;
 	__be32 netmask;
 	int i, len = 0;
 
-- 
2.53.0



