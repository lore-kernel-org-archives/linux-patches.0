Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045990;
	b=QH2hgvck/thSBs+vWqIpqixu5mnDH/59mfC0JGs0mWYyEdpTn+H1F1uyPFtSO/7k0B+U
	 9XrEZMTLtwePvuHsCyVIujB/GMhVPiZs3grTdO1l6G6gLXU7EUx+Ti+tqkQ0ZG17buU7X
	 ftgLBPMJL5EhJz3BsOukNGnq++Z+UT1tAMdMgPOU4yoNKAV2culUp4dl9M5vcWsmOCcyJ
	 M+FHcjQP7mKMFI5Tv8rATmjBB3i2/OJjKSAiShlGbLBvrvPN+U1CRJhibrZtWMuXh7l7q
	 m/timlqNYFHJdRqAYAgxCuylpcpUVAfkY0pnBMrHrbn3HjIWVP13ttnW4ypxce8k5+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VikyNn86Fnu7Z6/66whcu8imVFb76eiQu2c3cgYDNT8=;
	b=Y0T2NhxtNsdNeHOyB5tYnt9b8k9prrbHCygXcB9NlV8OxY3yYgFKMCCc68j2R0Q1byeQ
	 ITbfM4wZgOFbHAu25uc25Pj1+BUXav7NBgzdcZO03vcu7LjnblKqRgyf1Z14P5qPMGDeJ
	 TCjsdzhVt68K9r0ZS85rzbJzqkzhy605jd79nnH5TisK/0mmHwLOISzoDU62QZ4EkRCRY
	 YSWbiDQSckN2uKTd+zHYsG20JscwJiMidMxoOazoNLCOj/vhl0NqQT/5fdpHmkSBIKF/t
	 IUr+FzivRO4+Sd8ZN5Hu25pUxj2rJBu0SmwOASpMlbR3Gi4nFKEVmNMmqVEsILjKMEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dU9O9FEu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A3A606A31C;
	Wed, 18 Nov 2026 23:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dU9O9FEu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5960C1F000C4;
	Wed, 18 Nov 2026 23:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045989;
	bh=VikyNn86Fnu7Z6/66whcu8imVFb76eiQu2c3cgYDNT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dU9O9FEuuDzgScZORf5rU1JPmQLEL1q1l3r2vw2mpf/EQklu/a0HvaZXXlmMPz04r
	 fLwIBWhSBUuAFX0++Z6oDeUUq5Ftj6iqH1APfanYjO+0lvcsFRMVdf0xi17d4Ac0ei
	 X5vgU8ayPZ/Bqlfsd/+CMCA1bRdaS3rzRJbCcylA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1080/2857] ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek
Date: Wed, 18 Nov 2026 15:35:14 +0100
Message-ID: <20261118150240.506382982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 1e860f42f41c6fbf3304f6a52be38245b9394982 ]

ppp_ccp_peek() caches a pointer to skb->data in dp after the first
pskb_may_pull(), then uses dp after a second pskb_may_pull(skb, len + 2)
in the CCP_CONFACK handler. If the second pull triggers
pskb_expand_head() due to a cloned skb or frag linearization,
skb->head is freed and reallocated, leaving dp stale.

The stale dp is subsequently used in CCP_OPT_LENGTH() and passed to
decomp_init()/comp_init() which read from the freed memory.

Re-derive dp from skb->data after the second pskb_may_pull.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 51e5c87255280..464a966a91e66 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -3158,6 +3158,7 @@ ppp_ccp_peek(struct ppp *ppp, struct sk_buff *skb, int inbound)
 		len = CCP_LENGTH(dp);
 		if (!pskb_may_pull(skb, len + 2))
 			return;		/* too short */
+		dp = skb->data + 2;
 		dp += CCP_HDRLEN;
 		len -= CCP_HDRLEN;
 		if (len < CCP_OPT_MINLEN || len < CCP_OPT_LENGTH(dp))
-- 
2.53.0



