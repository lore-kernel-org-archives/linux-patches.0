Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE4E328255;
	Mon, 13 Apr 2026 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099450; cv=none; b=KWlCVqFOcdZGVLn+9YLel9ytNO2+n9iR5M6MZIXexix2YHgRf9v7T5ZAi1Zb+7UqnCKh+Ue9kpJ3CpwSTQsmu/W87pXkAEP2f3p3oh2i/wlA3dM8Jn6xbCWIPprx1ujDWQiiUfJkXjjtyYu4kXVZXbRAPALSHSusNHeTvrF160s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099450; c=relaxed/simple;
	bh=AGP4TF8R+gJdvf82m4S7QxZ5fTDIVQ/vCeLvcDeJGmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUFOXSerHubqgLDERXEKiTK//ta+uGRr6bSjBN4sX2+Nlf+7A9kNZr5KMC/lPUGFdmO5YEU7ZLlmf1xQ5CUqeGAYkAjroQNjUKQL/L2hs/vqBTnnvkVblreXfAHpEymPedmpYQaPzLxvpkWWpav36VWtFzT2o1X8lRWqsTmMQvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUoRsMuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUoRsMuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DD4C2BCAF;
	Mon, 13 Apr 2026 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099450;
	bh=AGP4TF8R+gJdvf82m4S7QxZ5fTDIVQ/vCeLvcDeJGmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUoRsMuCSdBu+scRe6J0rqViXDD3vgKkxQGwyQmG4PdAHLqqCGRvSWMEymxuG1X54
	 cvaM3hcie1koohQ26Cbw8MbBRl8yS35QhvwEnvFgXGUU5mBcdU3N6VGvy+nWteCgqO
	 sAPMCrBOz+3cMIVB+jSPJuorxtOKusse+2iJ3F8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/491] netfilter: nf_tables: reject immediate NF_QUEUE verdict
Date: Mon, 13 Apr 2026 17:59:48 +0200
Message-ID: <20260413155831.880603463@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit da107398cbd4bbdb6bffecb2ce86d5c9384f4cec ]

nft_queue is always used from userspace nftables to deliver the NF_QUEUE
verdict. Immediately emitting an NF_QUEUE verdict is never used by the
userspace nft tools, so reject immediate NF_QUEUE verdicts.

The arp family does not provide queue support, but such an immediate
verdict is still reachable. Globally reject NF_QUEUE immediate verdicts
to address this issue.

Fixes: f342de4e2f33 ("netfilter: nf_tables: reject QUEUE/DROP verdict parameters")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 189997bcaeef5..15486d3051f6b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9362,8 +9362,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	switch (data->verdict.code) {
 	case NF_ACCEPT:
 	case NF_DROP:
-	case NF_QUEUE:
-		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -9398,6 +9396,11 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 		data->verdict.chain = chain;
 		break;
+	case NF_QUEUE:
+		/* The nft_queue expression is used for this purpose, an
+		 * immediate NF_QUEUE verdict should not ever be seen here.
+		 */
+		fallthrough;
 	default:
 		return -EINVAL;
 	}
-- 
2.53.0



