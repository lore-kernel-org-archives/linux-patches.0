Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BBE2F28;
	Mon, 10 Mar 2025 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630690; cv=none; b=XcZrRC/t+mjQsf3OiVinykTB/evm7mUPj4MBnf9BjCi3O43iQjoNhaTxaTtuA0yajrCCzV0stONl2/Y7URdGEmbw3BVasUfkOOxMibT1wGEsSMzG+WKwmGX+KZCc2L4KYS9WUR/GikFUsCm12OGoBaq4o1laCgOy8rFrHOibi9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630690; c=relaxed/simple;
	bh=Crs7ZcqhSsPKeczGLIwCeZy7lECXL+4u+lzzp4YivOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvUrNWoJ0vq1QT+Xw3aSzKrxib7KPN+cmmj6RykCyd/v6s5n1aIi9YY5rvhr5wuEfYplJr6cHCEhvLctFQdGCiVoijVRBO/qDbaCY+UDUHpgirexrCt9WymRLbDaYFhpvLfv80v8hbistt/d0w8VT3jTUVqOeyk4ja8tDtKLulI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJC+7c1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJC+7c1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A9CC4CEE5;
	Mon, 10 Mar 2025 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630690;
	bh=Crs7ZcqhSsPKeczGLIwCeZy7lECXL+4u+lzzp4YivOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJC+7c1Ariogo9QgAV7m4ovi9ICnXucK6+lkoAypXnNrJvxyT83xRDC+0UtlCe6dx
	 GLxit4pFYXPG2U/8ELwiO1awg1Ea6OCFgkT6zTAKNtkjDs7gUnI+T4zTmHdpUkolzb
	 caVGKh8z5aPOH02Fs+E7dEsAsLQDNC5DyKc/N7Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Julian Anastasov <ja@ssi.bg>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/620] ipvs: Always clear ipvs_property flag in skb_scrub_packet()
Date: Mon, 10 Mar 2025 18:05:48 +0100
Message-ID: <20250310170605.381071413@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 17073429cc365..d4c821d97b545 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5558,11 +5558,11 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
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



