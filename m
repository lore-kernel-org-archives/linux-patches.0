Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D68332610;
	Sat, 12 Sep 2026 09:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205133; cv=none; b=l8QyXOE6bCwt5Mp73ilvFnbXX2MjtkEzOzSFvF5/YD04mp8bu/jZrETnn5urVLTzNuSBv8vYgOnFo+Y3foUUCsDiTt+T8w5Q/LdebrZVQx1x5AFrBwhcd0x5TFzGCutGX8fNFTgfCMkfVrHAMT4OQ6cBB1rSqNUQ3yXD9wmyR2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205133; c=relaxed/simple;
	bh=YFjc7tDnKwqJ2yhXIvJlW5Co6pSODlvyV4PDio80ahI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUzShKXj1imqDoaBRK+gjDPeh/rGbTPs85/+tliOXMPJ9999zpfTcfbPP/nUMxRAXR+xjCRRCedOYlnDw46H3t0VRMHeFy+QBW8WFqgoBRhPlrVe5AtCzDWf/63zaiGB5Ro14R0v8OevR0BJiib3336mLtV94gptfox2xPWCPaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdMOh9Bb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdMOh9Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6141F000FF;
	Sat, 12 Sep 2026 09:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205132;
	bh=07aH74AbxMJOoRFL3SdZr/q0Abd1yNqEHN20UyaAtIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdMOh9BbQfLcAS1qJ7uf9z2/0nCqCsaKqF+cyeT01unnEH/OWyKzKIaEGDDwfnmDO
	 Z7m6WhXqiEPMuVcgSdzPGzN3tlUWkThKJRaeRM3K5RD54VGHUL+XBy/iPU+jbtddq/
	 blknAjsZm83iJhmXziPwXi5sWsLJELdhp4sktVbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1756/1815] net: core: check skb_frags_readable before uncloning in skb_copy_ubufs
Date: Sat, 12 Sep 2026 08:58:26 +0200
Message-ID: <20260912065730.212505779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 04776a1123342..b3edb90a21d62 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2004,12 +2004,12 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
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



