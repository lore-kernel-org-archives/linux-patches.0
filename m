Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F112F12B8;
	Fri, 17 Oct 2025 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714667; cv=none; b=Al+tWdtN3aVWRQurwjSYG6eSNU05u4dW/2Td4djv7RjII7eBahycpN5Q/Hgx61BAPzGv6QgRrDU02PmZ7DbuPkLHkqvJEHmg069mcxlR1n3wRqH74PtLOjtp6xgG12LzByjpuVoFKqYGy/aMgE8/us+OVoR/m2yVxzRPmrWQbo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714667; c=relaxed/simple;
	bh=NMEBeymKL/irGjf0DLObdTX4+vmfyndE7yt2kshBPw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG3uR8ecPeKRAocyfIrFYyGAAk9tq0j/v8LnyoJBQEFqfmulOi8MAdQ/5PVft9ZR6Jn7A3Tsj/7McmXEUHEQVHjpfoz3MCbio3hY1PX+8Nzvp34KY2pE92+XAfz0cvi8NKODZYU7uk1ADkLYfXuO9yROtOSp/WbzREzpJZENY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUQdudIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUQdudIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CB5C4CEE7;
	Fri, 17 Oct 2025 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714666;
	bh=NMEBeymKL/irGjf0DLObdTX4+vmfyndE7yt2kshBPw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUQdudICjXT4p7BJFc0F26PM5vqbSc1sMgHxu4tMte4oxq4LXXvUbjFnns3a3WcRR
	 ALMbkiRmTQOBHw4c0DMC+tg3cQPWIwvomySTmcmmlPDf0oqCewfLb/1BEbT3EFru4O
	 NoUy8OhbwPDux2iIV4Yx6a/OnHe0QRau9uN5CvRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dev Jain <dev.jain@arm.com>,
	Jane Chu <jane.chu@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 207/277] mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
Date: Fri, 17 Oct 2025 16:53:34 +0200
Message-ID: <20251017145154.684562505@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

commit b322e88b3d553e85b4e15779491c70022783faa4 upstream.

Optimize hugetlb_pages_alloc_boot() to return immediately when
max_huge_pages is 0, avoiding unnecessary CPU cycles and the below log
message when hugepages aren't configured in the kernel command line.
[    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32

Link: https://lkml.kernel.org/r/20250814102333.4428-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3453,6 +3453,9 @@ static void __init hugetlb_hstate_alloc_
 		initialized = true;
 	}
 
+	if (!h->max_huge_pages)
+		return;
+
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;


