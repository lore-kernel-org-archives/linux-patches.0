Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10081D0BB3;
	Wed,  2 Oct 2024 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877364; cv=none; b=CGeTtwWLxr6pgLn+ZBNdEVt/pofQBx6vtGr+68FK6WCSLgQge4E3AnJfoDTt9b6WDku8GFzYkf23KUHscO2ynjvmu6cZUaYmarzoioQUTPfNHy8nCykaS/FhZtyDTIj/gQOj2L7OJ1j0dNZeDw/heFdXGCmWTi0sZLODVvYNiTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877364; c=relaxed/simple;
	bh=Mq7EyTWf8U+ux7Irxw49uZmDYYuXy/MmReKgkhqdcsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhaUg649EugKzrB3eIGo6NYgshWPnhg6UYkfik7Y1qPdmqV2WgUIwDFrh6nFUrTcIpGReXRTJbaD9dtNW9rsAgQpBetGzitpgMgQq7x8LV8JhfWmgOGd2Rzi8vqnSWPOzWmGNgQjgxeDj2q0FZEknkt2ZQ/IVH7vvprc6TLHE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzl3wAQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzl3wAQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1EAC4CECD;
	Wed,  2 Oct 2024 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877364;
	bh=Mq7EyTWf8U+ux7Irxw49uZmDYYuXy/MmReKgkhqdcsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzl3wAQKqw9wuxW0UJ50Q1TA9s0RaVAE7t1AKjSUCH/VcR8iKX6R1s6yK1jyCcdUw
	 CGVYDQ8tpj51exUrcPYoVEYVFWdUGjKIMK2cFuVYkgCQGNQ/JKHtDP16/2y8U7V4OY
	 Z1ZolHJEQU6ejZ99tK5+HD1WqEslXEE7Syl4uPE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 056/634] netfilter: nf_tables: remove annotation to access set timeout while holding lock
Date: Wed,  2 Oct 2024 14:52:36 +0200
Message-ID: <20241002125813.317396008@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index fcb68fe818566..d4b5f23930c9f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6867,7 +6867,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = READ_ONCE(set->timeout);
+		timeout = set->timeout;
 	}
 
 	expiration = 0;
@@ -6974,7 +6974,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
+		if (timeout != set->timeout) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
-- 
2.43.0



