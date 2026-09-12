Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27F935E549;
	Sat, 12 Sep 2026 11:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212348; cv=none; b=b5XJpUGstHbp0A+NNVfFrm6S7XFAU0JtnJp3r7ZbwbeKoUNBgJ4BYD4RIMCPa+p0fT1abeea96tBwcnESKov5p930ZtEejVbgrUVvJg2XrikV15WyDlPsKxjQn0uEn+logTl7BGUbMj1znn9x1qUFZ6F8ut+64xtBxQ7svVT7BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212348; c=relaxed/simple;
	bh=kcTX5xA8D3YnML9RVMmRhJQxYCJJIjXdnj4lT/3i/B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb2zAdd3kY0EuhuWW+kFsJtIQJRhOfWzn0Wp9NS1AqJLPvrD0uGCMTwlky53YLYpkkpNg3/ee05eD9QzrnBFFmBDQOcv39+79Da2tkDD84ZfNcC54r6Zeiv3/VF8azDOdRKzEi89+HDk7Y4Rfo5TRLcKAAixuwtqbJrTvMWLXoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwn4YfAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwn4YfAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031721F000FF;
	Sat, 12 Sep 2026 11:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212346;
	bh=fk3n3bg9r3awiYWW9OzCyRRxUim+5a/tBa87Wwl2skI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gwn4YfAFW6lGHevIqcOJgVKELbYJIx7pkqgs1eCAPpZVB3I7Or6+XruG1xaOITPki
	 elJK3UhIr/4EXWhitfd5E89TCBpJXdliqQniRYaUyNaHhXdZZzRG3cHlWMTcgR32XS
	 4wuJNSvyubcEtIrB5ShUak9Wtr3tuYEIqJcz1Ql8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1416/1518] net: core: check skb_frags_readable before uncloning in skb_copy_ubufs
Date: Sat, 12 Sep 2026 08:59:45 +0200
Message-ID: <20260912065655.582681961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit 00e11ee9831b3439264e0ae6762a0470126515af ]

skb_copy_ubufs drops clones and modifies the SKB via pskb_expand_head()
before checking for !skb_frags_readable(skb). This alters the SKB
geometry prior to throwing an -EFAULT on an invalid SKB. Check
readability first.

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20260823183602.1051453-1-almasrymina@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9c97591068228..03b2e96fe6dc9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1941,12 +1941,12 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	int i, order, psize, new_frags;
 	u32 d_off;
 
-	if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
-		return -EINVAL;
-
 	if (!skb_frags_readable(skb))
 		return -EFAULT;
 
+	if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
+		return -EINVAL;
+
 	if (!num_frags)
 		goto release;
 
-- 
2.53.0



