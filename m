Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261262BEFF5;
	Sun, 20 Sep 2026 00:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789865239; cv=none; b=Qi+Zv0DS8anM7bMYHuynSDOJnT2SncnzKVKod7v4zvczC3GHhKeF7WhdoAfmDiWNVAklcQ+iAsbFygVZBHdb93vpXDWhMy/1i4FHx9JUXPvssoSXK6MJEtxWe8E+EOoI+mqBzZdwAs1DiXnTc0txhNrDwhl/2d0iH6zVJkrJNus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789865239; c=relaxed/simple;
	bh=vlQzPUqzTh6633wyF0xfxamftMvimSbs61K2GFgAUHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZnXRZyM2WwwUg6neWbmbt9Mgd5kY4m77GKQHitO49Osi59Gt+2h18LyA8SdUe05sqg9EAZvfWTTRoCcBb6Ya1fQGjagtOFfyjAhAi8fdfINb6BlyDcAL+qt8es20GATxoz8QQCEIZMYhSFhJ2QWbEV/C4slFKG6K3WPAP586PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2JqifWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2JqifWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E361F00893;
	Sun, 20 Sep 2026 00:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789865237;
	bh=fRAlVhqYeTNDBx+btosYwp5D9p9nx12hOSmBmGbHePU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2JqifWlbanyxzL/PFJWLMx2WsZR7s1riE11RrhpqxYVH1QOB4vpzMM87N2CXqmfP
	 vF5F+1G5yY7KlroeqjOi+nW99S4LrGEktUNkCKrCLSFGbwh2Bqbie6GynKtmrQeWMa
	 dyOF30DJIHEdd0uYFOCSbhkRyDLkoWahtNqzbPPRHgBGzj/xokJnU0oqw5wkV2xtMr
	 NquMhbuTgz4HfWTnoWnMBT//vad2mMuOB4tmlXPFZ6Q//rKKZoL54prgy+u+i+ikGy
	 APKqkJKI/qbQw+GOrEWXlGJcqQSmbShvbmP1fvBjwNVYMeO81RxhQwwg+aCmCWazk1
	 tg0DoHXPzJw1A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0472/1102] mm/huge_memory: use folios memcg inside __folio_split()
Date: Sat, 19 Sep 2026 20:47:07 -0400
Message-ID: <20260920000825.3-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <70fbd5c6-2903-47e5-9627-4e028be7a858@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org> <20260917151551.542102472@linuxfoundation.org> <70fbd5c6-2903-47e5-9627-4e028be7a858@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 19, 2026 at 08:23:49PM +0530, Harshit Mogalapalli wrote:
> The backport instead passes the raw result of folio_memcg() and never
> drops a reference.  That raw pointer provides neither the css reference
> required by set_active_memcg() nor the helper's root-memcg fallback.
[...]
> Maybe lets drop this and get it backported correctly next cycle ?

Dropped from the 6.12 and 6.6 queues (the same substitution is present on
both, not just 6.12).

-- 
Thanks,
Sasha
