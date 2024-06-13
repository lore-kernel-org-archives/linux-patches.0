Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7936EB56;
	Thu, 13 Jun 2024 12:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280609; cv=none; b=KqjVW00pV0xcOd2wxS8/dgVNRV84h9zLhqw5zSu/7KTiWrKpjE9KGGlA+VZO0Q95waA0+uc/DIaZPfebA1Ou9HzBW2MPIkvMdetfplKoYaE5RSl+BIz2mrmrEF0b8CXxesrRrZbKDTS/4GD7VmZtvDLXlC0ti0yV1taUrJ/Tl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280609; c=relaxed/simple;
	bh=knO/ttw51sF4Dy+EXmex4qRI2yL53a/Lew2b8espY8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU/1UnHD65RLhd+YJHT/y+lXh8u3SGf4zWfXjn53OecmtnHJ3so4Sg2tSG0PIlIy1VP924yx75V1pqz7YPqxPiN5MXCRaxHx0tUD5byTgihB74PJWa7m25A+jhRwYXXkp2wELp8lCzDQ0yZTHmsF6LFz6PqPQ1PhwbJyJTp3tNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCBgc86T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCBgc86T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F27C2BBFC;
	Thu, 13 Jun 2024 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280609;
	bh=knO/ttw51sF4Dy+EXmex4qRI2yL53a/Lew2b8espY8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCBgc86Tpm8eOtDfkzjqJpfOmdZTVgK4doYofr/o8oEm4qkiF49j5tmWxe/htNl/R
	 HKahmA4vh3/+VDhO6d/+92DxvJhkvxNDD3DAdZNgiym19OvfGJ38S7xE8jGRbp6YFz
	 C8goQoq0K6sLoZ+re67kth+BKIB7RP/kqWO6Fkhc=
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
Subject: [PATCH 6.6 081/137] mm/ksm: fix ksm_pages_scanned accounting
Date: Thu, 13 Jun 2024 13:34:21 +0200
Message-ID: <20240613113226.439810216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2486,18 +2486,16 @@ static void ksm_do_scan(unsigned int sca
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


