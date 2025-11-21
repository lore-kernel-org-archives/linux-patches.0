Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0204E2FF173;
	Fri, 21 Nov 2025 13:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732774; cv=none; b=oRG4CY8GvVDmRbPlO66uZpZZDNjclG5YNYsWjx2RWo07zeGEWuo69QtuzMnn/uingN0Agsg2H6CCL+MMfEKmbLmMIS9W7HLc8wMLFVaS1f4s+2DqMH0f7mtzW9Nfz0/St0a/EM/c+3X6ZPrG1yG2KUQRK2wokRecFBvTqvM+iCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732774; c=relaxed/simple;
	bh=H/XP9pYj58CpnbgUMPj1e9VFKjyNIB5Do5vaOX9EAoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gX6wmuXIBD+Onsveu6IPpvlFlIbVuwbhKszURQAvSI0jjmT3uXSf6kCZS9yJnJvmnTJg409NVwv9uYkmpZ277aaVIz5KUDSiEl70PIo5WNXSdlYsFov3WuLYRA8tWnW20+797DFb6P7nv587PZw2P3eOwOg3TQQRUvUMNWJ1ugI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvxFQew1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvxFQew1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AF8C4CEF1;
	Fri, 21 Nov 2025 13:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732773;
	bh=H/XP9pYj58CpnbgUMPj1e9VFKjyNIB5Do5vaOX9EAoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvxFQew1HUGgfMDYZ2qUmZ9ZZnW/wUF/vyZM3CR6/dQM9zZc11Y69GPQ9RuXThK6K
	 tnW5Emj6EO3Qhii18/2k6wL7r/b/J5yIpwZcjbe65terJjr92Lktxg3xTc370wypvb
	 To4QTEyBjZZ12IU7rtD0OMS3d5UD6KH6nrDtQNkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/529] page_pool: always add GFP_NOWARN for ATOMIC allocations
Date: Fri, 21 Nov 2025 14:08:56 +0100
Message-ID: <20251121130239.452092381@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2f2f63c8cf4b0..b78c742052947 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -422,6 +422,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
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



