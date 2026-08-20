Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E7137A498;
	Thu, 20 Aug 2026 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238675; cv=none; b=cLQVhEs0W81idUkUUqa4LFcyeeMmsjollLHhi8KwJjZI8LwPbOAzgVIzUP0xAJ+m9dnrIMo2j1HIkiatsTVbrpXyIhjLk1cqD16yyXmH3pRALPuBWxFV1ZgvPnP1xvPoxEvCgF36Pk4yeuTTL5PvcfoX7RnduDb3MCf5UpQPTeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238675; c=relaxed/simple;
	bh=4ELMtVUpiIPga9EeSxe4uk1NDx/u5JqDq00vRa20BIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPdVD/jZXXe6zfnGvb/4MuE1mQtW4F5S3U/NxCLKFBFLFsd1m3K7GUoS+G9CtEWGv3T+/ZQ2bkFxbF29pH2+/lzRNS688OqPuYlGV92rCER/x0HCNJpvlW2qn//UEAwEXRoH/vVMdkDKL3S1tDBWmKU6ZpOUb4eEhy8C1qEZ1CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Da6ueD3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Da6ueD3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51FC1F000E9;
	Thu, 20 Aug 2026 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238674;
	bh=jRTcKMGT1AJL+V2brY5PP4hPj6dONHdhtAgcofj9E6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Da6ueD3Kk9H5Czyb22z2HsjNrEG33bCpEbg7ZqJ6xMh4FLzAj9PL9Lcz5OBci37WQ
	 w5aSh0Nal66KJ661cYDTVE95vfZqGuMhN1L7voPbBdLGktBOjsZyM+1eTjePVUrZzx
	 7XJZ8dAPFtp1tsqjpiF1tTaNZWEPTrxSWu+HZeLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 191/228] netfilter: ipset: fix list type element drift bug
Date: Thu, 20 Aug 2026 16:55:33 +0200
Message-ID: <20260820145250.519843043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4cbd69766b35a089664cadb1f613bb85f7ef77a9 ]

If list_set_uadd() calls list_set_replace() to swap an expired entry,
the element count remains the same, therefore the increment must be elided.

Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index ca3ef9479e838..0bc2370773af3 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -301,9 +301,12 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	e->set = set;
 	INIT_LIST_HEAD(&e->list);
 	list_set_init_extensions(set, ext, e);
-	if (n)
+	if (n) {
 		list_set_replace(set, e, n);
-	else if (next)
+		return 0;
+	}
+
+	if (next)
 		list_add_tail_rcu(&e->list, &next->list);
 	else if (prev)
 		list_add_rcu(&e->list, &prev->list);
-- 
2.53.0



