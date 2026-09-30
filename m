Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F615172E7;
	Wed, 30 Sep 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787668; cv=none; b=MGxksj0tjM0zbF3dtaT1D2pTek39pfCPivcVkDRfMmmRMkTNtXjqdqy/KGx/DpVze7KtsT/SsQdVsr0IO8nyCQITqGbwKRYUoouRa2BCSRbzbMximz/BDjfHWnCLQG2a+pnCa12x5Zhy0FFTFaZQhrBq7fn2RjtHfHxwAUwcuEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787668; c=relaxed/simple;
	bh=Lw3yTRzC7oPwDrRe+uTsIb9VvBbXuwioZzl5Jqu8k50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Riu2DfBYUzqH8SLmaqKNZ9etEPzyxHeBKb5dmPO9sKdeHA1zjff1ZokmMPGOZtsVt9k709NiWtcTfLowWNisNcj+hVs8jCCUY8x2NiC3ZP8IwJGzUWIwd5ItwzugzDRtC4VJTdX6JPLwAqzo18oqvze1bEjHgCIOmSzJ/U+RQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mttKjZAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mttKjZAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EBF1F000FF;
	Wed, 30 Sep 2026 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787667;
	bh=/EHowp+7D/8skemuZRlERGOll+49JtqEfFvN9K9QC1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mttKjZAzbMI8w/SY7E4QlSrN9yvfm0fZDobuSC0+jdJa64HPX0O8y1yQ0v9VY3Scu
	 RI4OjCsWkcIMjfBNFcbNoUGHFx73cd3e1VBVPwq1ybpcBuvNUP4paoG/2dWrafoQQM
	 UskJ46c8dibxMbHfCF4/P6zCw0vRPJngy55R84GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 7.2 312/457] mm/hugetlb: do not dissolve gigantic pages without runtime support
Date: Wed, 30 Sep 2026 17:26:57 +0200
Message-ID: <20260930152352.759209999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longlong Xia <xialonglong@kylinos.cn>

commit a363c62a653cc8b3e21da9545fa4e028ef50f9c3 upstream.

dissolve_free_hugetlb_folio() doesn't check
hstate_is_gigantic_no_runtime(h) though remove_hugetlb_folio()/
update_and_free_hugetlb_folio() silently bail for such folios, so it frees
a still-listed folio and, on vmemmap restore failure, the
add_hugetlb_folio() rollback corrupts the free list.

Link: https://lore.kernel.org/20260823044118.1097121-2-xialonglong2025@163.com
Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Codex:gpt-5.6-sol
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1977,6 +1977,15 @@ retry:
 		struct hstate *h = folio_hstate(folio);
 		bool adjust_surplus = false;
 
+		/*
+		 * remove_hugetlb_folio()/update_and_free_hugetlb_folio() bail
+		 * for gigantic hstates without runtime support, so dissolving one
+		 * here would leave it on the free list and, on vmemmap restore
+		 * failure, the add_hugetlb_folio() rollback corrupts that list.
+		 */
+		if (hstate_is_gigantic_no_runtime(h))
+			goto out;
+
 		if (!available_huge_pages(h))
 			goto out;
 


