Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749D1C304A;
	Mon, 14 Oct 2024 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917419; cv=none; b=jitKwBgpAGCGD28MUo/LRnIbmr4LG0s6CrJe82lJ/ZhzSQK2WFOEOEbIqm0u9cfYdhpe3B85vssuA80vKbwY2OjaKYwJcl0Eh1yKOpRwwZKiHd1+Bo4eoGtZnXlxweKOZ57apdi7sLN+LkPFKuw66+YeG4J8tlh1eyf9HqzgQj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917419; c=relaxed/simple;
	bh=S/UOO++GpNqK6DgqFxRyn5HDb7E0bFVEUNywgEqzUcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMvq4mvAaMY58ekd6ciuQ3aiT5JxIueh9WTFetDPh6w7zrIiIuYq1x2hypDewh+lBH1yW1LK4A0sJfadlfnWEeHHr20p8tWC/75asbrkCsQY8bzisSVYARODKx5mhmPxCNCMkbQ0fKIlnQX9xTOlRjmEcvwOtfoHcqQCLjYGTLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QL5dVVJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QL5dVVJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FA6C4CEC3;
	Mon, 14 Oct 2024 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917419;
	bh=S/UOO++GpNqK6DgqFxRyn5HDb7E0bFVEUNywgEqzUcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL5dVVJi5CUnjELFVr/aJZbgicqH35aAS1sTnM7uinPEhfIUH55OKF8JKzh6lM/mX
	 uutDx1NzOlYKA1L2jp+rEsYaROw8wBlj1c81AQb+JVTNpYul/LTajdNobOUb553IsY
	 2MjLdcTP0Xrvct348aBKTNvnHqaJblEMvxmSCFA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/798] netfilter: nf_tables: remove annotation to access set timeout while holding lock
Date: Mon, 14 Oct 2024 16:09:44 +0200
Message-ID: <20241014141219.130922875@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 15d8605c0cf4fc9cf4386cae658c68a0fd4bdb92 ]

Mutex is held when adding an element, no need for READ_ONCE, remove it.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f57418150717c..a68b2193393c8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6404,7 +6404,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = READ_ONCE(set->timeout);
+		timeout = set->timeout;
 	}
 
 	expiration = 0;
@@ -6511,7 +6511,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
+		if (timeout != set->timeout) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
-- 
2.43.0



