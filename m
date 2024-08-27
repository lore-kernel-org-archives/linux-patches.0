Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC621C579F;
	Tue, 27 Aug 2024 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770329; cv=none; b=jJDEqVuL4U14FqNaStVoGxVKDVd8IR1lmI6MTM56CZH3l6xR2RodjcVlGHchDu1sZU8o02sorMBdnrvxKa416MmXyhsxXGsmbvn6e8oX9pSOyrGNEfnkC7kkAtMJH68kSQ2p2lAf0axA2YrklSC67mFpWchxmL/4SSulnRePVtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770329; c=relaxed/simple;
	bh=OmCzQdm+zD3BD10QJtBwy50tpKwoROmeLXBzHWCwDzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttow10jbHPW3ZTE1WMo150Gp6xH8HBttnKB2MRVF0VAqESvsywzzIXQ6VlatuFNyTvWwZ9wwGDXTSplHdZrK/9tLZ2OiSx6pumPf7+slc3SuG0J16bAOH6tdHHRyXEP18vBcSLBSBXqrJwjPmgkd7QYrh6vNy0EVSVpJvSENyKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhJ8UrMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhJ8UrMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C10C4DE03;
	Tue, 27 Aug 2024 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770329;
	bh=OmCzQdm+zD3BD10QJtBwy50tpKwoROmeLXBzHWCwDzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhJ8UrMcouSzfdw+pu7TtwfVjcQDeTHbi96VMS+bknPf7s6TONhyFItcurM/+Xtn2
	 gjC8Qu8d8xthgt0m3GRD3VTJfko/7+sztQ95Njcj8bbR8FoR/GrHta0iJWBoSWZmuP
	 2+uwqdPl571H25rkaBOyFddLOX4g+M2nIPxJQsbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/341] Bluetooth: bnep: Fix out-of-bound access
Date: Tue, 27 Aug 2024 16:37:08 +0200
Message-ID: <20240827143850.907946262@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0f0639b4d6f649338ce29c62da3ec0787fa08cd1 ]

This fixes attempting to access past ethhdr.h_source, although it seems
intentional to copy also the contents of h_proto this triggers
out-of-bound access problems with the likes of static analyzer, so this
instead just copy ETH_ALEN and then proceed to use put_unaligned to copy
h_proto separetely.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 5a6a49885ab66..a660c428e2207 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -385,7 +385,8 @@ static int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 
 	case BNEP_COMPRESSED_DST_ONLY:
 		__skb_put_data(nskb, skb_mac_header(skb), ETH_ALEN);
-		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN + 2);
+		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN);
+		put_unaligned(s->eh.h_proto, (__be16 *)__skb_put(nskb, 2));
 		break;
 
 	case BNEP_GENERAL:
-- 
2.43.0



