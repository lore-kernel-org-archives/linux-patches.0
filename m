Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B3D143C6B;
	Thu, 13 Jun 2024 11:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279475; cv=none; b=QaYy/x5eK4v3crQME5IEkGaKt+H2s+H71zUxDj4MjYTgMxXE5g9ExPVWNYB3DiRaLYtTBiaqzmjL6JZeYto3+1keWeXR6PeAbygthUson4ANcEdG9mzR7rZ+UcBTIt/RfK8kGLdAMnFQ6xF+FESzkJvcF7qVshGv/2lSZfMt4qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279475; c=relaxed/simple;
	bh=S58BuUptOqm/ctJ/hzdbIEzOkGclSxjagP+NK6Ig3eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrTXKnPo4v5GMgMwc9mXZq9YJnMa7X9ePqwZgLGnG01ICDGfexZDsCVqnH5yMOm1cqaKCWW80wmC8bpmYs0SRcKhHKz075pVkAuImWubICjl1ib1RYmnSakFWOLrGeuBIDYjZcWAu5nAV1kIucjb8mOSJQyU99TOo8WcQ8pvFu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfSDREmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfSDREmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ECEC2BBFC;
	Thu, 13 Jun 2024 11:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279475;
	bh=S58BuUptOqm/ctJ/hzdbIEzOkGclSxjagP+NK6Ig3eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfSDREmNZmjFPRItl/MuogYkuW4zN08IEKerBGNipXWj6MV4CgTn1TIyTYahZfTia
	 4u6QF296UCu4OSK63fIisd8e26C/cJbK//hP59vRmS+YFtHqPOWQg+nSVfQR3I1GQV
	 0CL37Uklcrvu1jkTOmP47D0TSlJMkMBpz2cbU1j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	xu xin <xu.xin16@zte.com.cn>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Stefan Roesch <shr@devkernel.io>,
	Yang Yang <yang.yang29@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 087/157] mm/ksm: fix ksm_pages_scanned accounting
Date: Thu, 13 Jun 2024 13:33:32 +0200
Message-ID: <20240613113230.792961293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <chengming.zhou@linux.dev>

commit 730cdc2c72c6905a2eda2fccbbf67dcef1206590 upstream.

Patch series "mm/ksm: fix some accounting problems", v3.

We encountered some abnormal ksm_pages_scanned and ksm_zero_pages during
some random tests.

1. ksm_pages_scanned unchanged even ksmd scanning has progress.
2. ksm_zero_pages maybe -1 in some rare cases.


This patch (of 2):

During testing, I found ksm_pages_scanned is unchanged although the
scan_get_next_rmap_item() did return valid rmap_item that is not NULL.

The reason is the scan_get_next_rmap_item() will return NULL after a full
scan, so ksm_do_scan() just return without accounting of the
ksm_pages_scanned.

Fix it by just putting ksm_pages_scanned accounting in that loop, and it
will be accounted more timely if that loop would last for a long time.

Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-0-34bb358fdc13@linux.dev
Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-1-34bb358fdc13@linux.dev
Fixes: b348b5fe2b5f ("mm/ksm: add pages scanned metric")
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/ksm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2747,18 +2747,16 @@ static void ksm_do_scan(unsigned int sca
 {
 	struct ksm_rmap_item *rmap_item;
 	struct page *page;
-	unsigned int npages = scan_npages;
 
-	while (npages-- && likely(!freezing(current))) {
+	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
 			return;
 		cmp_and_merge_page(page, rmap_item);
 		put_page(page);
+		ksm_pages_scanned++;
 	}
-
-	ksm_pages_scanned += scan_npages - npages;
 }
 
 static int ksmd_should_run(void)


