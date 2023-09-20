Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3830FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80872C433C8;
	Wed, 20 Sep 2023 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212858;
	bh=jnaG5MFh7LrLFm9FN+C78CwmJWN2d71iol7P+7g1agk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fl7y7AdAMNA1lgzgAloXTi2nxuExmm9RVf5NgtIDPrAPWaknOY8t5i7ZRySuH2xOl
	 pdrasXfaVIT21JEbHkJqM/Gaup0xoxCEywTdUtXF6fvwe11lO5n1B4Up28xUxASG5v
	 nwpx0FUkG/jO1OrjLnXOFf02FD2520iAB/nf9Icg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Mastykin <dmastykin@astralinux.ru>,
	Paul Moore <paul@paul-moore.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/367] netlabel: fix shift wrapping bug in netlbl_catmap_setlong()
Date: Wed, 20 Sep 2023 13:26:53 +0200
Message-ID: <20230920112859.443205060@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Mastykin <dmastykin@astralinux.ru>

[ Upstream commit b403643d154d15176b060b82f7fc605210033edd ]

There is a shift wrapping bug in this code on 32-bit architectures.
NETLBL_CATMAP_MAPTYPE is u64, bitmap is unsigned long.
Every second 32-bit word of catmap becomes corrupted.

Signed-off-by: Dmitry Mastykin <dmastykin@astralinux.ru>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_kapi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 91b35b7c80d82..96059c99b915e 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -857,7 +857,8 @@ int netlbl_catmap_setlong(struct netlbl_lsm_catmap **catmap,
 
 	offset -= iter->startbit;
 	idx = offset / NETLBL_CATMAP_MAPSIZE;
-	iter->bitmap[idx] |= bitmap << (offset % NETLBL_CATMAP_MAPSIZE);
+	iter->bitmap[idx] |= (NETLBL_CATMAP_MAPTYPE)bitmap
+			     << (offset % NETLBL_CATMAP_MAPSIZE);
 
 	return 0;
 }
-- 
2.40.1



