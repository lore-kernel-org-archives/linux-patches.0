Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047250;
	b=47sSQgbtoWkJ+gHKbL3eZgVykAA71exbl0zuGkn4MsNfPScjZmRYmoPwWBtAQR6tINYU
	 57Gi7192vrRRNqB24yNS/OM7JQoUovnVnC0YjZ/tLMhZy9JrPo9tc7JiXQ/yzDv05KT6/
	 Q53QwLIX7ZHtt6ikvaYxfmKxszvWeFZmrPHYC4ZL8IVWLqTLqS7jSNtUxisagK8dOBehi
	 2vJEgvEeYbcbmZlamrdTVBt52eMG5B6T+DrShAbaW5iIpHxQMsVHGSL9PfQq3Fl/9FuWo
	 YwLuXSAou/NrMbaphsOeJKjQ8wHZ2j61ww+UAGhwadhDz+6WrjRgnKTHweq03YU3oJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yOzG9ozRG8lqyJ3vL4o40FEWdkUx3d+wO3pceROXMek=;
	b=YMxJyHeAxDuMwhfR8rDXzvR1C/npHXw+TTuXLk2b1aFKOzJFDXLAa3rZr0rmGDwoWGA7
	 U1AxFmvsDRBnlRg8FAxF6M3J4zN/BeOEG8uHO+CiD1Yn/c1Bu0l6ksH5uIWI9KymOI4Gk
	 LNSqbkHCgHbkC8yBr4oPlI/8xJbCVJjGcszWw19Hu65cON5RZvsqxP7WUB86mAKToPXed
	 dXJ3FGF4fCKw0QEPJ2wXDdylOsYRITlYJh2GFfnfjWaFQqOYn34AK8hiEcQDGHD2dsbwE
	 J4vmE0WAF9ZCRAJuUJyFKOYJVjkKThBw3X+2dmsUx78fflO4d+ngbspnM/DwykpDuRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKht+35g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A184B606A32F;
	Thu, 19 Nov 2026 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKht+35g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA031F000C4;
	Thu, 19 Nov 2026 00:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047250;
	bh=yOzG9ozRG8lqyJ3vL4o40FEWdkUx3d+wO3pceROXMek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKht+35gWPqKOgfXRzs8CdLO5LTvMewMkiSMs45uq6wx/tKL/tUdhMMa94Eor6mOc
	 8GFaGsZf0ZNTScVCMf/CDrFupgeaHFnCAL4DEYCOd+hRrmeskL47f+hPlkFy2g+GhF
	 tHrAEOK/VYEFOcDj777qcqaZ8F+ask/KFaOCq3ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samarth Narang <samarth.colleges@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1572/2857] mm/ksm: keep soft-dirty when merging a page
Date: Wed, 18 Nov 2026 15:43:26 +0100
Message-ID: <20261118150257.986579520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samarth Narang <samarth.colleges@gmail.com>

[ Upstream commit 2efc6332f18bfd848f74f3d5ba45b31450601faa ]

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty bit of the PTE it replaces is lost.  A page written since
"clear_refs 4" then no longer shows as soft-dirty once it is merged, and a
soft-dirty based dumper treats it as unchanged.

Copy the soft-dirty bit from the original PTE to the new PTE.

Link: https://lore.kernel.org/20261021182157.1873726-1-samarth.colleges@gmail.com
Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Adjusted context to retain pte_pfn(*ptep) instead of pte_pfn(ptep_get(ptep)). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 99eb19860fd59..c976e41f853b0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1178,6 +1178,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/* Preserve soft-dirty when replacing the page. */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	/*
 	 * No need to notify as we are replacing a read only page with another
-- 
2.53.0



