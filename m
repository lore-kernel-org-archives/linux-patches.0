Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C483E5ECF;
	Wed, 20 May 2026 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300574; cv=none; b=iDHNiOeidkHZe/FzvKtAiBTEihD9oOJ7kCOogRqQwfTNCDg87JeyGg6nvtRdaMeT3/dESyfmcoy3rq/0k0KtuCZUmTXqFyzRECSzPpKnvrh8cChFnY+X0PVhs0px1+hdstgXFM6VVyaIHy3BYa5eS/LIKYAfotXXCPwERQjAkxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300574; c=relaxed/simple;
	bh=/ig2/o8vT14V2F4Hd0maL7mFCzaGRdC2Odv7ilYRjWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuW9Ulm/9r54Ik6anqRPt7P82+UxZcNcGooNdD3x2me/tXm8WA++hUVRAdjHUHknTwmqdyct2zp1KtsPvL3aMN2aw5/eV5Cc586r0yCz1U73dmirSUMwxL8luGdA6hVsudkCvnup+4pKSo0kgZtzmQu60c/ZFXavr2nWatO0+LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4ghXHnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4ghXHnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E1F1F000E9;
	Wed, 20 May 2026 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300572;
	bh=mvX0938GO02oDPHXQFl/N8sJq+KnV0YU/Gxv3joojog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4ghXHnjjPdzD+PoFEr5OKTVmKEqmNRLNyiCN2zHcHKaJZAAar1oBMui34x5WK2vs
	 L0HilGmrxZiV+QJofjWcQ9wwr1UeZhg8FhSpRQBJ0s2nFiGmfhE0dv2b9mQd8QooCT
	 vwb99pyekevU6fqmjUSUGujdeUjupgFyt4bjM09s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Chu <jane.chu@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Hillf Danton <hillf.zj@alibaba-inc.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/666] Documentation: fix a hugetlbfs reservation statement
Date: Wed, 20 May 2026 18:17:18 +0200
Message-ID: <20260520162116.133501282@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jane Chu <jane.chu@oracle.com>

[ Upstream commit 7a197d346a44384a1a858a98ef03766840e561d4 ]

Documentation/mm/hugetlbfs_reserv.rst has
	if (resv_needed <= (resv_huge_pages - free_huge_pages))
		resv_huge_pages += resv_needed;
which describes this code in gather_surplus_pages()
	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
	if (needed <= 0) {
		h->resv_huge_pages += delta;
		return 0;
	}
which means if there are enough free hugepages to account for the new
reservation, simply update the global reservation count without
further action.

But the description is backwards, it should be
	if (resv_needed <= (free_huge_pages - resv_huge_pages))
instead.

Link: https://lkml.kernel.org/r/20260302201015.1824798-1-jane.chu@oracle.com
Fixes: 70bc0dc578b3 ("Documentation: vm, add hugetlbfs reservation overview")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/mm/hugetlbfs_reserv.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index 4914fbf07966c..a49115db18c76 100644
--- a/Documentation/mm/hugetlbfs_reserv.rst
+++ b/Documentation/mm/hugetlbfs_reserv.rst
@@ -155,7 +155,7 @@ are enough free huge pages to accommodate the reservation.  If there are,
 the global reservation count resv_huge_pages is adjusted something like the
 following::
 
-	if (resv_needed <= (resv_huge_pages - free_huge_pages))
+	if (resv_needed <= (free_huge_pages - resv_huge_pages)
 		resv_huge_pages += resv_needed;
 
 Note that the global lock hugetlb_lock is held when checking and adjusting
-- 
2.53.0



