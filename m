Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18C03A9870;
	Thu,  2 Jul 2026 16:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009978; cv=none; b=BfLFF3JJ8I06kKam01HIgJPbG8Ete0lK6Oy0YUb55DCrvFM+0rrc9s0cP6m7lNmry9cfJsugIZFKCbhGjWou4kUViMeWI+ysI93gfl4s+HmSVsbsTX+6Rx3Hr0QVzDxG3bYXIbIxJ91U2VJL+zaq0KpIzeyFQdMw2CqqM4qKttU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009978; c=relaxed/simple;
	bh=lU7+Xnfv+/WzEZXMQFGE6FhxJshwZh5bHNhM4zUZ/yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se4WhNxR9eupz5MYhfCfJCXUMGvAToSvNY9BFh9qUGFBsss323keh/r97WzraJVQXe/3o8BAZOhk6VvWPPlW1F4N2EFRFp/IEDbYRzMOnPhHoyIYHqI+Z5CPwXTqMX/TgZuiuE5X5A4wKZ0yJzB8vSemok6MLRsoq/9f5NMH9Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4lAWlni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4lAWlni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14801F000E9;
	Thu,  2 Jul 2026 16:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009977;
	bh=CjuWsy5z7xGv0KoSX5akNNrvFZQrXtURDYs/rmPyWFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4lAWlni03YRFDf0i5u7MBWJmV3lrTnuxsP7xl9vyJlCfK3hsWiCH7Q8cN534CfJw
	 eRmhvPymFrW4m4nuSShs/C/MUxnv8jdCZcm6GJVQ+QascdJ7+n4u9tjPRFFD+3xPp/
	 RMKj0lSD6oEuRTFwDZveZVoTQX9blx7tK7+iSmSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/129] netfilter: nf_tables: always increment set element count
Date: Thu,  2 Jul 2026 18:18:49 +0200
Message-ID: <20260702155112.376041111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d4b7f29eb85c93893bc27388b37709efbc3c9a0e ]

At this time, set->nelems counter only increments when the set has
a maximum size.

All set elements decrement the counter unconditionally, this is
confusing.

Increment the counter unconditionally to make this symmetrical.
This would also allow changing the set maximum size after set creation
in a later patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
[ Shivani: Modified to apply on 6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 201e2cc0453992..b6b7b0b3539dc9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6699,10 +6699,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+
+		if (!atomic_add_unless(&set->nelems, 1, max)) {
+			err = -ENFILE;
+			goto err_set_full;
+		}
 	}
 
 	nft_trans_elem(trans) = elem;
-- 
2.53.0



