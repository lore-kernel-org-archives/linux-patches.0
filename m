Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058750;
	b=1cfFWqka5TeSGBshjqfFv95wcHRpiCoClh5qrbzrzHNDv7h4Yy9XItNWIeOa3VGW3v3u
	 pbd5143/RMnJ9k0ygoMsEqIIZCNor5DviJbBtNMaHnWjDwPUOc6zZWTgvunsy3rkUf3Re
	 XnOidmKNqnFEFM1A0Go/Uvc6sT1jpsQrL6xEI26hPuikTCgdOYK4sVzmgaKFDHAsuxN+s
	 PEglgkY0K1YJQJYvYXEZ8xLyBxlydCHFDP/7jfaanS/5Cefh3BSU5HYWtdvtSA7+MiqJx
	 AEvJaWUJrWikpGPqDCwKzs4lDb/8DxqAmmCllj1qY79vGIDf3evj4GZUhorHeURQNFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ikKecLRV7TVHZV4JD9QJUagxGKkIsXrsutwk7D939lc=;
	b=nP6jX4VVzaF4/qUFnU1Y7UQbHGcpBrfzMKHrkxwQHHFOqdaaGTHH2v3EV3bMAIuY+L7g
	 Q+5irTR2wnO8cVRjZJcJdrzRk53ItX/jmstj0HnI7qAOj82vZjb6fn3MxShRtN8MLTND1
	 nvS2XaA70O/Fnm0RtRzy0PAk5Ab4OkabBo7HgFU1Ppz5Mwikukbm5Dldlqy+y3fdmQlrc
	 JBVb3yUojEP8LRWbqoXGAHPThqUuoVyx4cVCc/4VohvlDNRrKPa+enVDZeu+b2XD2Oj34
	 rLSpBCxerV0u303fGFWMbm08RO+anjWBjCuFVXW65FtUyZJoxhP+uvEQ8XSylvawD9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4opvxOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEFE606A325;
	Thu, 19 Nov 2026 03:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4opvxOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0D31F000C4;
	Thu, 19 Nov 2026 03:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058750;
	bh=ikKecLRV7TVHZV4JD9QJUagxGKkIsXrsutwk7D939lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4opvxOSIcQ1XFVRjchUGsqJvy7Bu+eA93QB4mq7pdrVCV9qaeP5gZYzAEojTfdOD
	 XeDFS6a0lmaOOVj7RKVmKntLTZpRsv75Hsw4qJI5iuHnibWiBEE4ja8f+aa0omowzP
	 3JqmqHOPU+3U4cyKXc9irWWdAC10XThSGDFvs6c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0597/1848] ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek
Date: Wed, 18 Nov 2026 15:43:55 +0100
Message-ID: <20261118145940.359564369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7f1a76059f085..e8b75b1dcc760 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2980,6 +2980,7 @@ ppp_ccp_peek(struct ppp *ppp, struct sk_buff *skb, int inbound)
 		len = CCP_LENGTH(dp);
 		if (!pskb_may_pull(skb, len + 2))
 			return;		/* too short */
+		dp = skb->data + 2;
 		dp += CCP_HDRLEN;
 		len -= CCP_HDRLEN;
 		if (len < CCP_OPT_MINLEN || len < CCP_OPT_LENGTH(dp))
-- 
2.53.0



