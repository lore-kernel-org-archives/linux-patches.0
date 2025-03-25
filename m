Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6C1264F99;
	Tue, 25 Mar 2025 12:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905558; cv=none; b=eZFm2Gn+aju5F14IaTWyY4Xiyu8NZ2NIdcd7Xa4m2reFiwua0LQTO8wUBi64NMSj1GAsaf6vy0p3HnyiRgFoLgq4uvP1a/QLo7LelW8jseoYH03qCyKHVELVbTsYrM4ZNeqTXFc2Hh/ltAn8mIFmDohfY2yKmM4R4I7xoVVOO6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905558; c=relaxed/simple;
	bh=iAHAL7blJPW3ycLMnPfpNr/NYMW+04WooDRbFQJFDg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLxincgr00I46Pft9ZXgDkbsUvKC4Ch4JPLjNSn+T7WVdGSpcmOaH+7Kpl4Y4RsAm6SWTCjbYhzRmMzSKnmmHAzOVcAePcd/iHWng9WB33u7MVsg4lNJwr1fyCm1TVQ4t1JSIknQkEDd9PukYBTloUDUCy++LhXPZJuuYLR3gnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULbpMI3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULbpMI3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9148FC4CEEE;
	Tue, 25 Mar 2025 12:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905557;
	bh=iAHAL7blJPW3ycLMnPfpNr/NYMW+04WooDRbFQJFDg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULbpMI3ZlEXC8WidkrWe32dit9b5Bcy6nQ0Vp6mBVeiSaV86Nn+4m1I9C9/+XBQwN
	 +dqcBSJGgmUmISuDVvpHQapTLlSSqqhwLIDWnvqxvFYkj+rAm6H/RXwaVhPWTnguY6
	 OUPC1reXX9Z0J3Zrh/nSi+vXKkcMIudIHrKJMQVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicklas Bo Jensen <njensen@akamai.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/198] netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around
Date: Tue, 25 Mar 2025 08:19:31 -0400
Message-ID: <20250325122156.884986316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicklas Bo Jensen <njensen@akamai.com>

[ Upstream commit df08c94baafb001de6cf44bb7098bb557f36c335 ]

nf_conncount is supposed to skip garbage collection if it has already
run garbage collection in the same jiffy. Unfortunately, this is broken
when jiffies wrap around which this patch fixes.

The problem is that last_gc in the nf_conncount_list struct is an u32,
but jiffies is an unsigned long which is 8 bytes on my systems. When
those two are compared it only works until last_gc wraps around.

See bug report: https://bugzilla.netfilter.org/show_bug.cgi?id=1778
for more details.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Nicklas Bo Jensen <njensen@akamai.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 5885810da412f..71869ad466467 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -132,7 +132,7 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 
-	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
+	if ((u32)jiffies == list->last_gc)
 		goto add_new_node;
 
 	/* check the saved connections */
@@ -234,7 +234,7 @@ bool nf_conncount_gc_list(struct net *net,
 	bool ret = false;
 
 	/* don't bother if we just did GC */
-	if (time_is_after_eq_jiffies((unsigned long)READ_ONCE(list->last_gc)))
+	if ((u32)jiffies == READ_ONCE(list->last_gc))
 		return false;
 
 	/* don't bother if other cpu is already doing GC */
-- 
2.39.5



