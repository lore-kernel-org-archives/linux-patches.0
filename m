Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF3C3043C4;
	Tue, 30 Sep 2025 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244183; cv=none; b=SMdr6vLjbSxepA5mKUFTyFpKGDKZV8ipV+KscC1SMgF+rM7J7PwxNyYsfnQXhr6+yW8avmnT3N1mT4z+6uxh6RDFfrDmXCq7xBCZzp9NkCbTJBXxrcCX0TzXc2O6RC3UCHz5UYtkdz9oABfMpyJf0/lz96B9uWsZPoH7sfn6dhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244183; c=relaxed/simple;
	bh=4KThQDOKk+OtsNiz/EZexfiAKyyZmsDfzooZliTeqTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8j9XGBx2DHyJQejyofcXPPeASos+gznoCDCzgMVV79/T4IUfj13yUxo6Sui4+dhGhU1OYby+LilobcUiBug7RASlkSrCp9l+eqlCS8usLMsA/QQp/hRzV68K+uhwH6Znk0KRXqCV9zoHqb3qzDnwZKXJb6OwqRnBUbfwI66fzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glzq+TQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glzq+TQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D486C113D0;
	Tue, 30 Sep 2025 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244183;
	bh=4KThQDOKk+OtsNiz/EZexfiAKyyZmsDfzooZliTeqTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glzq+TQ6ZTr0DVwzgyl6FgUBRseli484YdAg8ZZAf2nF3wQI6U++Y7IERfp3y7sJE
	 qd+DkIjg9qP+S6S23UNqYtlMYO5YryYXU3rSWFCIfTgjjAkkvv0st/X8jnTrnVxDwd
	 OKJupg/tT7UpUKUHPTlfQBXILGSjSg1RDUvIaJkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 021/122] mm/khugepaged: fix the address passed to notifier on testing young
Date: Tue, 30 Sep 2025 16:45:52 +0200
Message-ID: <20250930143823.862145945@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit 394bfac1c7f7b701c2c93834c5761b9c9ceeebcf upstream.

Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
mmu_notifier_test_young(), but we are passing the wrong address.
In xxx_scan_pmd(), the actual iteration address is "_address" not
"address".  We seem to misuse the variable on the very beginning.

Change it to the right one.

[akpm@linux-foundation.org fix whitespace, per everyone]
Link: https://lkml.kernel.org/r/20250822063318.11644-1-richard.weiyang@gmail.com
Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1363,7 +1363,7 @@ static int khugepaged_scan_pmd(struct mm
 		}
 		if (pte_young(pteval) ||
 		    page_is_young(page) || PageReferenced(page) ||
-		    mmu_notifier_test_young(vma->vm_mm, address))
+		    mmu_notifier_test_young(vma->vm_mm, _address))
 			referenced++;
 	}
 	if (!writable) {


