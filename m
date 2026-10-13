Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C414EE858;
	Tue, 13 Oct 2026 12:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893913; cv=none; b=QgoorPnG8dm0qZmn1gEbPSkU6PlPaDDuJQJBfXaXkaS2FqZeJEl4JU7IGr0NbyO98Yjl9h/e0zOIr1WPAcuP8FqI8z+cpfXBcifcRu0L9Gz72/9h2XxGusQ0ywW56Z1BH/s5gAJIXr4vAt7Ay6pW+gah8aej9EPruKGiAnN44M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893913; c=relaxed/simple;
	bh=NFv+eNN8IKm/W8jq+eg0hc+ZU7/HlPu2sXehDJgwKAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRKbYeJYKtgSkJz6f5n2RX2SA6cAVfnCpaOJu/MIypMW6/8ruqoIKQIrmyFWA8iDbJoVgTvMolLDoapNLMkcBQ0qRZHMgdH8PPjH6PGEXFVqKXi/K8ZTaxh9HrnOi1Zq9EfOY4nYxnJzg3Eut9V0NRia72l17TNAHVmp5ptoL3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNWHcj/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNWHcj/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578A71F000FF;
	Tue, 13 Oct 2026 12:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893911;
	bh=3FJ5NN+xwZ/pNsfXxIOg1mM01Yuc8qBgqFZTYEHeZOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNWHcj/Wp18CHIx+3ygoi/iWrsSiyEs7xbAVLraDfJG4VCYL8FiW4nKkJoNXfFCcx
	 CDRrN73QsQdp5RC2sq81jNHjzpqYVgchL/iPZdEyWsrvHyC3bujDrY7QjbRs+3HKeS
	 yoB5kmb1vLB2xz31W7kvUza/oRvFCb+B84IcmU0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 382/621] kho: fix size calculation in kho_preserved_memory_reserve()
Date: Tue, 13 Oct 2026 13:36:17 +0200
Message-ID: <20261013112929.909165669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Pratyush Yadav (Google) <pratyush@kernel.org>

[ Upstream commit 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded ]

kho_preserved_memory_reserve() calculates the size of a preservation by
doing 1 << (order + PAGE_SHIFT). Since the '1' is a 32-bit integer, it
can only be shifted by 31. That is, it will only work for preservations
up to 2 GiB. Larger preservations will trigger undefined behaviour.

While preservations larger than 2 GiB can't be obtained via folios
currently, they can be obtained via kho_preserve_pages().

For example, memblock reserve_mem uses kho_preserve_pages().
Reservations larger than 2 GiB are valid and will trigger this bug if
properly aligned.

Fix it by using 1UL for shifting.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20260727150240.889555-1-pratyush@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e1a06b4fc17fc..ac9fa7727b5ff 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -425,7 +425,7 @@ static void __init deserialize_bitmap(unsigned int order,
 	unsigned long bit;
 
 	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
-		int sz = 1 << (order + PAGE_SHIFT);
+		u64 sz = 1UL << (order + PAGE_SHIFT);
 		phys_addr_t phys =
 			elm->phys_start + (bit << (order + PAGE_SHIFT));
 		struct page *page = phys_to_page(phys);
-- 
2.53.0



