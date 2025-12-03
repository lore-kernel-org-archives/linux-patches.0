Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563D43370F3;
	Wed,  3 Dec 2025 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779339; cv=none; b=gFBe7/3RdrSoy9F59W645e5xzDa5MVwoGn0wWDfVXCBaLLTIPYkc1BoQTGEQy7JNOKKdzL1hs0uO9WOqU5wXqtQKoqUuUaZUVBZn1PId6BUup0K5/5yU1A84AJPv5I2AKMTYop1dOWxRFy6dRUaB9wu29L6o3WaWPyiimHraAvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779339; c=relaxed/simple;
	bh=BfpibcB37mEbMXSacQBZG7evvtlDqKJwhMXliGYKXzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW/4/u7mRG0zenkDtjY6lcJBnr/A/ftO56NHZCTzhnSZoguLyxXl3POqA/Ip8/FiiNjj8H/RpqAXEIMIkibeaFdYAne+gatF62R5Fja5rHqtl8xYyJNBVIGux+8tyIg2Ts01rpQAhycsVi6Ly9sJ2Byu8JFKpbLy+yske5+vu6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Eus57tN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Eus57tN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9522C4CEF5;
	Wed,  3 Dec 2025 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779339;
	bh=BfpibcB37mEbMXSacQBZG7evvtlDqKJwhMXliGYKXzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Eus57tNxQB7AWhVNy5TzFt2OfQ99EVSOXKIkC4Mw9cKDNTdoL2zckMwLaAxs/hyG
	 yHhorn0vmCZxNybOF9GOMPE/t0cb6zQ1N7/XVLMlk+Mgbsa632Z+A5kB2Ijz58jABB
	 C6s6UwycKLO3LMw4kjmMk73Ei/aYoI4BAO7vjHUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 228/568] page_pool: always add GFP_NOWARN for ATOMIC allocations
Date: Wed,  3 Dec 2025 16:23:50 +0100
Message-ID: <20251203152449.072240797@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index acc1d0d055cdd..8ce34d1c2e076 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -405,6 +405,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
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



