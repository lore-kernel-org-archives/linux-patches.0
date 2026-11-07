Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063158;
	b=sPkCrIKazGGncngcI5GdbSYMMhf6hRksMuEFC/F6n8SWCg+//x31CAhoPI7TL6Uqdi0L
	 8T8RH31hv494oxwyjfR4Mlnq2zhK5QwBUynhZirLsGMR47YUFTtPQpZ9fbxx3lgzrcWz6
	 CAHpC1VgzY2Oj2y1y67pk5od3QYnIHdtwwSkUgAuYu4L9XqUPOUFX8/THOxaUPskdThDs
	 ZUgT4/9PdVMYRHCGVaUZC9QaHDuLzX2o5VLEURJq5sROjwbFlba3875+Zu2GpppJdVF9q
	 9oSxOfXNGtb0kUmbx9oiPWSp87scBh8kCF7Utic6ExthgIE0v0LsH158SyGCLKCeG/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KXRINpjOP/2Y83Y/4Q3H6obQI4igV74sFXMXQHgPiHE=;
	b=Uh0rRufvo1QOdN9C7rajTA4W3ldR2+VI+IlRiYTuKUAblbWxuDe5EJCDByxR4NPyz6zX
	 siZs7D3DMuIYl8fozhHIBJ0ocaYvMxD+lrtO94vdtZhUJr+7g7ByNTlHOlP8hFE7CwBu3
	 d5HUp89Itqh5E39kH7ZWmK4DDZjflArccI3zE76Jv9Ke1ZGCEp6j+lm+cooUXPtudZ08Q
	 zIMX+67jEeUEuH3YYWYL8vpOV7kChXgySd2ahBg8bPZaSstG8B3OcGb6Hh4/36EEezvfN
	 ylu3kKbmxtieZyWqKSWo2UzSZ1tKJiFzuW1+ua3zFXrFVu8GeyarZDllrqFEwZRxaqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxCp62PM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159B606A331;
	Sat,  7 Nov 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxCp62PM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0E51F0089F;
	Sat,  7 Nov 2026 14:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063158;
	bh=KXRINpjOP/2Y83Y/4Q3H6obQI4igV74sFXMXQHgPiHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxCp62PMc+25oXikBj8GmaRngidS+LmJdwEwkW6GE5Rjwj/GZ9z6N9G73VMNDnh/O
	 gXZvQUnLZgsLbTU+INx/Ij8SSvgmbZi2e1vnPMMADvVt6XEJy6tgBJB+ymwlxGXNY3
	 QxboDrZXlKIzeZLLIC8V+efUDbGgIJg+zQI9LJes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/869] mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Sat,  7 Nov 2026 08:51:03 -0500
Message-ID: <20261107134906.063755913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit ac733f921d4fc02da70a98b175a6055a206b2a36 ]

The function for applying DAMOS_STAT in DAMON physical address space
operation set (paddr), namely damon_pa_stat(), applies DAMOS filters to
folios of the given region.  For that, it gets folios of addresses in the
region.  It starts from the region start address and advances the address
by the size of the folio of the address until it goes out of the region.
If the start address is in the middle of a large folio, and if the next
folios are small, some of the next folios could be skipped.  Fix the issue
by advancing the address to exactly the start address of the next folio.

The user impact is that the DAMOS_STAT-based page level monitoring results
become inaccurate.  Since the page level monitoring is supposed to provide
relatively high precision, this is definitely a problem.  It is arguably
not critical since it is only monitoring quality degradation.

Link: https://lore.kernel.org/20260901131850.98037-3-sj@kernel.org
Fixes: bdbe1d7bc325 ("mm/damon/paddr: increment pa_stat damon address range by folio size")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 1854b4bb6bd29..5720e73930f84 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -300,7 +300,7 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 
 		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio) / addr_unit;
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-- 
2.53.0



