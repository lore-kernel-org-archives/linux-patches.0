Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED613BCD04;
	Tue, 21 Jul 2026 21:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669497; cv=none; b=Wf3blsO7o7sn66Z+41d1CYSksT0dZekwLdLsGtAv+qYiFQZHz9WGcRFnaon0N3Qz3wAZ2X/o47qCLDdpBniJkNdw5aUpMnn1Qqhfyomr9g7gQ1OulfRrNKbOWEei4P9bI8LXQ5SI2IlQpy2g4ISt9L+npYYeAi89VkPAfnAgIhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669497; c=relaxed/simple;
	bh=s3tgcqsBv6Zaiov0ZDU91fWNAGlPKNke7+JkK5dWLIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgTNr6BTaRK6vx2DYUhyrBDOak6ZuLaA0iebjcpqn8IzjGe/Hh6Kv2LHdfNwNycTWvH4WztEWHGslu9VeDdce14U0gk00l+YD/RuRpNEq4pD5remCo+yZwWXeN30a5cYH87k7zEkTIcU77o3WxTJVVwXaN9cF94QPcFBCqkzTlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3DBeoOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3DBeoOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417711F000E9;
	Tue, 21 Jul 2026 21:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669496;
	bh=h+RDTcq2Kh3hZykO8L52zZh1zVSRX/lO5UJ+cd+TZVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3DBeoOCRpqlFDe9v78F7R1DCjavj5PM2dqkL62daFb1x506xB8MQ9QLpUMiHveQx
	 +5g57wt2HtKwfVkwgmi6NkzuU6jnJ/acLxZSpmpdqD63a88/7IPfPIxs8A5T7Rmpn1
	 zcEGzsEBoxSYs/WaZytMQ7tdgrlER/F2NAkuGcV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0578/1067] net: psample: fix info leak in PSAMPLE_ATTR_DATA
Date: Tue, 21 Jul 2026 17:19:39 +0200
Message-ID: <20260721152437.536414354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit aedd02af1f8b0bceb7f42f5a21c41634ca9ed390 ]

psample open codes nla_put() presumably to avoid wiping
the data with 0s just to override it with packet data.
This open coding is missing clearing the pad, however,
each netlink attr is padded to 4B and data_len may
not be divisible by 4B.

Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260616003046.1099490-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psample/psample.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/psample/psample.c b/net/psample/psample.c
index ddd211a151d0d9..a4d09437795580 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -465,15 +465,17 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 		goto error;
 
 	if (data_len) {
-		int nla_len = nla_total_size(data_len);
+		int nla_len = nla_attr_size(data_len);
 		struct nlattr *nla;
 
 		nla = skb_put(nl_skb, nla_len);
 		nla->nla_type = PSAMPLE_ATTR_DATA;
-		nla->nla_len = nla_attr_size(data_len);
+		nla->nla_len = nla_len;
 
 		if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
 			goto error;
+
+		skb_put_zero(nl_skb, nla_padlen(data_len));
 	}
 
 #ifdef CONFIG_INET
-- 
2.53.0



