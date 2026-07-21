Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F839A7FD;
	Tue, 21 Jul 2026 19:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661123; cv=none; b=KJXFGpmNwq2GxTSi+NkjXIsGgZMZP4vAlutqCzfUs7e4oHCEgX4fmEQK0Q1zwjyaMmoHR5tGgkcHUqkedhMjmxxYh/ph4AyfaIX+HTIUXlWnWM+LKS+QT1IvJzCBLt+wm49mWvdZv8R5vJSoACovHXy3vYlFBsW/Uag9ZxVGlfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661123; c=relaxed/simple;
	bh=jnnN14nvhqgMI2c2vVmbg9qvqqbcFcMMF3T8xD05OVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1QFQLh7GkAeVjKVJU550IT0IpKaMf9ujfePDjTv0kPRAgDCQv2l5dx3KGUXfTK4FXJ+z0BGTif40nu7Rx83hbU51ssNvbDgumy79l2LQHJdn4RYeCLQamC0TvPIV9k5hjVZTeLOF+DQp83/w242uN6zVe4uwG7nMW8P251pE8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTcQvh8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTcQvh8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C871F000E9;
	Tue, 21 Jul 2026 19:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661122;
	bh=fDy33dJVm0zZgmfEh2uGS6SAactPmTRnrBxVpil9kb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTcQvh8+iPNSvAIiBmwUUhGwSiNSwRdE4zT4r3nGA/g7AzA6iHKudD5PCylrVEE50
	 v4wLbLuMtCvVcq6zMs/EYLEIfkRvUSIkjS9vDggeGRgTwD4Z2KFRANnZgq/xZElmaM
	 JEi0TcZD+YBjAXj/si1Gg0+MhZ7JdQMXqdsu1YPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1237/2077] netfilter: nf_conntrack_expect: run expectation eviction with no helper
Date: Tue, 21 Jul 2026 17:15:10 +0200
Message-ID: <20260721152621.989337824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit be57dd9c1c1796e368582313af2b3849f78ac224 ]

Run expectation eviction if no helper is specified to deal with the
nft_ct expectation support.

Cap the maximum expectation limit per master conntrack to
NF_CT_EXPECT_MAX_CNT (255).

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_expect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9454913e1b337e..113bb1cb1683fd 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -499,6 +499,13 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 		if (p->max_expected &&
 		    master_help->expecting[expect->class] >= p->max_expected)
 			evict_oldest_expect(master_help, expect, p);
+	} else {
+		const struct nf_conntrack_expect_policy default_exp_policy = {
+			.max_expected = NF_CT_EXPECT_MAX_CNT,
+		};
+
+		if (master_help->expecting[expect->class] >= default_exp_policy.max_expected)
+			evict_oldest_expect(master_help, expect, &default_exp_policy);
 	}
 
 	cnet = nf_ct_pernet(net);
-- 
2.53.0



