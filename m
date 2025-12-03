Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D467D30ACEE;
	Wed,  3 Dec 2025 16:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777814; cv=none; b=iwJ3zr8b4wbcXoP2QNvXOQA9Je3t+wjvsKIju5qMA9c51qL0Qiu8tjgZks26hOPiZ8sR+Sd/VL/y93Bo3b2FpWZzeZU5dx/OMw7/X19qWqjgMT0sQmoOIUqgTQtdMjfr3WrIx2t2YhFs4MZnyS3kjSttQcMjJAy0tGtb/H/dfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777814; c=relaxed/simple;
	bh=tgrkkC1v9SKJHbmBQ+rAtEfJbDe021JSPJ2w/NeeB6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He7eZer9Jyv9DzYv7CdxMHvKcodzNwAMjUsJ8EzyvRiYe8hTaORinKokbz0JNrtfqtBya8ZY28Oy/dQZSWz2nZxnUx0Hhzp1B/PRTqo94ZkenDeygsn0rZLmswM7VKYJ112VRPYBpJ44andrm38FGL6BBtS7mYqkvRvRQmpNT0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+nYPk2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+nYPk2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4822EC4CEF5;
	Wed,  3 Dec 2025 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777814;
	bh=tgrkkC1v9SKJHbmBQ+rAtEfJbDe021JSPJ2w/NeeB6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+nYPk2bkOygIm/Pl2ju1JSfzdhGiN3Yhiys4O7HguqbSrBsKK539o7QDaKYJPhPu
	 In0GkP83bLt2baw6e44YYspv6E4/xgg9f+2Vhmlr/gVCe0vMgNxdfOyNMOAgKAqogi
	 nPuLwA0FNSTjF9jU2ULNVbrqFG6LwstJXzhbelt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/392] page_pool: always add GFP_NOWARN for ATOMIC allocations
Date: Wed,  3 Dec 2025 16:25:05 +0100
Message-ID: <20251203152419.785234134@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f3b52167a0cb23b27414452fbc1278da2ee884fc ]

Driver authors often forget to add GFP_NOWARN for page allocation
from the datapath. This is annoying to users as OOMs are a fact
of life, and we pretty much expect network Rx to hit page allocation
failures during OOM. Make page pool add GFP_NOWARN for ATOMIC allocations
by default.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250912161703.361272-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 416be038e1cae..813d15a5593c6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -283,6 +283,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	struct page *page;
 	int i, nr_pages;
 
+	/* Unconditionally set NOWARN if allocating from NAPI.
+	 * Drivers forget to set it, and OOM reports on packet Rx are useless.
+	 */
+	if ((gfp & GFP_ATOMIC) == GFP_ATOMIC)
+		gfp |= __GFP_NOWARN;
+
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
 		return __page_pool_alloc_page_order(pool, gfp);
-- 
2.51.0



