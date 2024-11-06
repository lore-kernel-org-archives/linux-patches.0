Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39841DF73E;
	Wed,  6 Nov 2024 12:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894883; cv=none; b=WmZEnknTbDAPr/62e5lBd2zjNIxB3y4embJMjjEhA1NHLPzxyXuMiyF+GefjvLJDdwtxpzvWc1nV8dpXnBEeqq0G8EcvgDqgZuvc2B0mTLlbaQVDp2C3fQ8gmNi5X9a62yu1yaFeEl8F83ycos2qXEyTSPrq42H8uP1msYe/3Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894883; c=relaxed/simple;
	bh=/MDBpc4tPbgHjatJjsnkOCaGl7Fj7YfZdrXOqVnSI84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ7VSao+jzZeiAtkfsO1FEpKgOx+MD9It7ns8jgLtTY2Vk6VBDnEwyUKWimDsIPPf0gJamBXK68Q22tgEKSFS5Gw7Kqiazdswe4JBK03ri/b/0GU4d0VdCkllOqdt49AwowoYi3T5NQYz99DO1EbxJL7UZktTmsxwAZ0FBEuHbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXldYzrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXldYzrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC23C4CED3;
	Wed,  6 Nov 2024 12:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894882;
	bh=/MDBpc4tPbgHjatJjsnkOCaGl7Fj7YfZdrXOqVnSI84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXldYzrOzNu8PRbamiTQqGFoaJH4EFGhcYnS5s5ldDzoSS5yApZ0lolPDXW5l1eIX
	 EoFS9UYcBgr/Sy4SmPcFlf2BDxKC9+e4u7dtkdXDNqZDlIgBQV22E4128uO7yJr4Ka
	 hX2b0Gfv2dvStqLyLhpPXr8c8+Z6ze900tb8l1UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/350] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Wed,  6 Nov 2024 12:59:19 +0100
Message-ID: <20241106120321.647795211@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e0c47281723f301894c14e6f5cd5884fdfb813f9 ]

Element timeout that is below CONFIG_HZ never expires because the
timeout extension is not allocated given that nf_msecs_to_jiffies64()
returns 0. Set timeout to the minimum value to honor timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a033c9baf58ad..25b2870dda24a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3339,7 +3339,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.43.0



