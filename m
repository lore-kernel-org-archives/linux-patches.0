Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FEA25C715;
	Tue, 11 Mar 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706099; cv=none; b=Vxu4o4U36VEqqK9Gruh1kgpwOo/KsLujqd8LV09hYnAisgW3L/6xJHgLPMsqs45sooDCvtMalxgo7lcevUHR95zRukrTF4+YetWk188Te5KkE3c8kZ1jqCl2Zdo8fNNKi+M40k+NxyaPDyrUMgcvd5HdyqFIah+NoP6Q92UZfSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706099; c=relaxed/simple;
	bh=wSj7FCvgPuuomcrA9OnDJRCrq3mZDwLJtM9HXUzWosw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlfArWDx1VxOFS/zatdQ/xVnAiHObkpF+4k74ToeVGINqs5hUjesrd0R037y3tQILhlUbM6YqqtyB+JNOUPDXGpHJCUL7bMrYjWV4nqpnIJMy0DkOMoyDmz1GwM1RV6lv09D9v4R6p94s2fbTyzUVXKWWm27wzqwSl6DMZBFJbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QslC690b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QslC690b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DFAC4CEE9;
	Tue, 11 Mar 2025 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706099;
	bh=wSj7FCvgPuuomcrA9OnDJRCrq3mZDwLJtM9HXUzWosw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QslC690bz/ETyGuDUwpR+z2itZ9Z0vKuCjOFmW75trjkb+wWVAcor50bn8th2g9XQ
	 k+JAnjUfCNkkKEjG3E+HaFreiD1DFTG2sG7AVNQGoGFwDC5GTn1z0C3i3habba0xgG
	 eihJmpNS2/DJNKVFM5EsA67d78hROYnZnIqsT7Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Julian Anastasov <ja@ssi.bg>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 262/328] ipvs: Always clear ipvs_property flag in skb_scrub_packet()
Date: Tue, 11 Mar 2025 16:00:32 +0100
Message-ID: <20250311145725.320580714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit de2c211868b9424f9aa9b3432c4430825bafb41b ]

We found an issue when using bpf_redirect with ipvs NAT mode after
commit ff70202b2d1a ("dev_forward_skb: do not scrub skb mark within
the same name space"). Particularly, we use bpf_redirect to return
the skb directly back to the netif it comes from, i.e., xnet is
false in skb_scrub_packet(), and then ipvs_property is preserved
and SNAT is skipped in the rx path.

ipvs_property has been already cleared when netns is changed in
commit 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when
SKB net namespace changed"). This patch just clears it in spite of
netns.

Fixes: 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when SKB net namespace changed")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Link: https://patch.msgid.link/20250222033518.126087-1-lulie@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index da2be54f5e62a..c82aaf656cda2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5226,11 +5226,11 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->offload_fwd_mark = 0;
 	skb->offload_l3_fwd_mark = 0;
 #endif
+	ipvs_reset(skb);
 
 	if (!xnet)
 		return;
 
-	ipvs_reset(skb);
 	skb->mark = 0;
 	skb->tstamp = 0;
 }
-- 
2.39.5



