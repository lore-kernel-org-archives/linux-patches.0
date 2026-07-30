Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74024402444;
	Thu, 30 Jul 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421896; cv=none; b=bGist4vgQWz5mvkBj+KqZKDKdAo09ZSah5KURcVRhGZql+M5uBe08KpgWye7BuK3qIC9VefbGwVKkWNeJ68UliytOn477Sq8BQzMkGWv9SM+YA457/5hlLKoc6kbTnTuyoeZWiWp1PpPfkcBVoOfqvzyXGGngVpBbGH7/xuxyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421896; c=relaxed/simple;
	bh=YQ7jSgGY3c2QACoYb0SLbnywh/ng93vcHdvXma3NMpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIqp4RyvPGIChzhf8nhXxgJgRNfWRZQcy36jhlCFOZCwpNifPCVKcQbc7ycTErVwZ+uUV/bU47lORa/GU96f/urVAKe7LbqNVbiM580yuFHAzIFLIQ1KCITOD2wg4cZLNZHCcC3AqViVjMccCwATJfrsI1ogYzkbD/xrEKA+mM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAkBiRr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAkBiRr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5AF1F000E9;
	Thu, 30 Jul 2026 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421895;
	bh=YYDBhw9fsyFNC1W4v2OArJPfTRlFlg81wvC7tl9pQi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAkBiRr6X6w+ZfH8mmezUfu9h9mMM8wlcDxuBjN9x0nDbZuYaOJTYaDY9UyUvFrBI
	 M45Tbz0gdpFntb46xapTU35YNIgsXx7FYfxBx5R9n64ZDD6gkRqTDn3xNhrk6nReUt
	 3XsQWwbrTVE6B3cxALvsi4jz93w+aQPyUdGEzUaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 255/744] arm64/mm: Check the requested PFN range during memory removal
Date: Thu, 30 Jul 2026 16:08:48 +0200
Message-ID: <20260730141449.713830976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 285f90a4d1141c7594f2368e19cbb307388eff30 ]

prevent_memory_remove_notifier() advances pfn while scanning the requested
range for early memory. When the loop completes, pfn is at or beyond
end_pfn. Passing it to can_unmap_without_split() therefore checks a range
after the one being offlined.

Consequently, a valid request can be rejected based on the following
range, while a request that would split a leaf mapping can be accepted if
the shifted range can be unmapped without a split. This was observed with
CXL DAX memory, where the final memory block was incorrectly allowed to
be offlined.

Pass arg->start_pfn into can_unmap_without_split() so it checks the
requested range.

Fixes: 95a58852b0e5 ("arm64/mm: Reject memory removal that splits a kernel leaf mapping")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index fd756390fe925c..fbbd31cd4cbd84 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2201,7 +2201,7 @@ static int prevent_memory_remove_notifier(struct notifier_block *nb,
 		}
 	}
 
-	if (!can_unmap_without_split(pfn, arg->nr_pages))
+	if (!can_unmap_without_split(arg->start_pfn, arg->nr_pages))
 		return NOTIFY_BAD;
 
 	return NOTIFY_OK;
-- 
2.53.0



