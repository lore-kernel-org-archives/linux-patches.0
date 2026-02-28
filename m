Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3063B5315
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301099; cv=none; b=cq0i2lRhszjATkJOnWGlWaTMq6YTjZ5lFbWrDJEW6eRnbHrK5dlEjMFHB4J22hB3fp1pQuemKVW/zZLGkBKyPe1+u1Lzr3S3qhdzneEmoI8yRE/335ViQXAZtVS7jin5naUT6nKXhsfSftjElCgQjN/7GV3S5MNGq7C4g7tww+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301099; c=relaxed/simple;
	bh=on/aqGeJbNw8FM9p0WkiZd/V+zdZqbfsc57tB34OKOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvoGvOh3SrkzOFeki1WofpCiP0IpI3QNrWaK5hXvOY1C/GgBnswGPKdM1fIy7GSmSwnXDFJKnfkxgg+ufW7xsK/86NKlTsIe/t0A/sDEvPio+M6dVsbV4gxhGjpbZ3A3UVseL58fKtW2SMwCk8jxMetHIn9g/D9VaEZjEe1iggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOpGbWgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOpGbWgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD86C116D0;
	Sat, 28 Feb 2026 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301099;
	bh=on/aqGeJbNw8FM9p0WkiZd/V+zdZqbfsc57tB34OKOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOpGbWgxmEPn4KspUwWpJtYs0vEP0Y4YxSNnxcheNt7a9tQIeQ8bBlWk67jpBNFaC
	 mkMRxlu3MlcKFKQ1M5WxVpIIgQi7FHSCedBXQt3TMiyu5Eo5cvcJ5e9/LdxV8SKRGx
	 Rq7bCaD6qyxqGq6gz1R5W1t2EGU771ovHWw9VheICKpp2iZk4ftqOL0zw8SL4r/8iF
	 QX08OKgLdjFIX0tbEsfEBeFY+u757p8SqYSQlfvuE5CNH56mfT43w1SX/RGailg0AL
	 JrPhdEOJzc9sfEOYRbsnIY8heHJsnRB58Be0RQXf8lESK83U3/e3/w31oWQBSvPzTg
	 FSY2laf6N+9rQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 251/752] netfilter: nf_conntrack: Add allow_clash to generic protocol handler
Date: Sat, 28 Feb 2026 12:39:22 -0500
Message-ID: <20260228174750.1542406-251-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>

[ Upstream commit 8a49fc8d8a3e83dc51ec05bcd4007bdea3c56eec ]

The upstream commit, 71d8c47fc653711c41bc3282e5b0e605b3727956
 ("netfilter: conntrack: introduce clash resolution on insertion race"),
sets allow_clash=true in the UDP/UDPLITE protocol handler
but does not set it in the generic protocol handler.

As a result, packets composed of connectionless protocols at each layer,
such as UDP over IP-in-IP, still drop packets due to conflicts during conntrack insertion.

To resolve this, this patch sets allow_clash in the nf_conntrack_l4proto_generic.

Signed-off-by: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index e831637bc8ca8..cb260eb3d012c 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -67,6 +67,7 @@ void nf_conntrack_generic_init_net(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l4proto		= 255,
+	.allow_clash            = true,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
-- 
2.51.0

