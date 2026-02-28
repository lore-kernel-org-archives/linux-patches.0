Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0648C37144E;
	Sat, 28 Feb 2026 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301454; cv=none; b=OfrnQU6Hvqy3Lgo+HSr1hmhgC02zX02pbfZfCy2g2WIasi3AU/OAHpjIyCf2V+HuoIhRGivfWfOfOoCiqXsHoXV40QwpT8ERIPXQPcl6WTG197hkbzTrxn5BC1g5V0KpEu8sw248OeRp/DVnNYE5+/pxi2ETj+4vT+s2MPKFKy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301454; c=relaxed/simple;
	bh=Y5A+qy/cBeezTIQpW8P+otUa1RJTrk/4afSR4NCp82U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxbeSnwqeFWJ4Dzppn6k1qpKLlTHplc0h2SLQDy9SXLEpBMyA0pGHH6Q7cBrF2xIJRZIxhs0WoTNbdMoYhW16aSWMkq4DFTpvitKPLgkHVbyUq6to/kcHC8NcmipbkpXXN4SEIMYyE5A1XXFBiTSMO1JsoOgR8zOipz7hWYxh+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCRXfcn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCRXfcn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A32CC19425;
	Sat, 28 Feb 2026 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301453;
	bh=Y5A+qy/cBeezTIQpW8P+otUa1RJTrk/4afSR4NCp82U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCRXfcn7ehXdgPArYFJnHm6RQb8VcPFm+PU2icdrpjzf3SBKjMHZcjnQ+dJNnZEU6
	 ONWXvmqa/9yM5yIjE50xKCuK8JhbklGYvPkiXeYRkGaAFT8rJiN/7XgTqjI1rA6zsc
	 HT++TaI8cjJfr0zdzPtwKfTOZytuICRRmZfsnmvOdg/zkUYCOursSBR7qrVOfIF7on
	 ErCX97irn1TBlDkQicpvOQGvtLZS4gpceS5q7CAcoqqZKB478VEcOlS7CgKo2iqRiD
	 IeUMD3H5p+swlC7GHLUnrWoOCW3G3lNbrB7FPiNnkJcSf5yLwgnDZhkpjFsAmSlj3v
	 7h3wPvKduOZgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: William Tambe <williamt@cadence.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Chris Zankel <chris@zankel.net>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 640/752] mm/highmem: fix __kmap_to_page() build error
Date: Sat, 28 Feb 2026 12:45:51 -0500
Message-ID: <20260228174750.1542406-640-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: William Tambe <williamt@cadence.com>

[ Upstream commit 94350fe6cad77b46c3dcb8c96543bef7647efbc0 ]

This changes fixes following build error which is a miss from ef6e06b2ef87
("highmem: fix kmap_to_page() for kmap_local_page() addresses").

mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
function); did you mean 'pte_val'?
184 | idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));

In __kmap_to_page(), pteval is used but does not exist in the function.

(akpm: affects xtensa only)

Link: https://lkml.kernel.org/r/SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com
Fixes: ef6e06b2ef87 ("highmem: fix kmap_to_page() for kmap_local_page() addresses")
Signed-off-by: William Tambe <williamt@cadence.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/highmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b5c8e4c2d5d49..a33e411839517 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
 		for (i = 0; i < kctrl->idx; i++) {
 			unsigned long base_addr;
 			int idx;
+			pte_t pteval = kctrl->pteval[i];
 
 			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
 			if (base_addr == base)
-				return pte_page(kctrl->pteval[i]);
+				return pte_page(pteval);
 		}
 	}
 
-- 
2.51.0

