Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2320763BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB37C433D2;
	Mon, 20 Feb 2023 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901653;
	bh=21HRu+7XSFH0QXb/bkneFwIm9oHY6sIs9A8CL5MDaGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfcW/dN6mSi85lrlRP0Ap++SK5QPy3BEXoca0p1lfVCEFQaYcH++TOxaIDxblbtlH
	 BXQ7X2uKYn3BUYrtqej8VRlKVEcC1hnVfmxNWcTFFW4Hj3ZMALv3CEC9AUtR2+6oIh
	 FIeCAfOpMDVrzE+feboj/CDX3zvdYL6Dx81S8w3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zach OKeefe <zokeefe@google.com>,
	Hugh Dickins <hughd@google.com>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 069/118] mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount
Date: Mon, 20 Feb 2023 14:36:25 +0100
Message-Id: <20230220133603.191900533@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zach O'Keefe <zokeefe@google.com>

commit ae63c898f4004bbc7d212f4adcb3bb14852c30d6 upstream.

During collapse, in a few places we check to see if a given small page has
any unaccounted references.  If the refcount on the page doesn't match our
expectations, it must be there is an unknown user concurrently interested
in the page, and so it's not safe to move the contents elsewhere.
However, the unaccounted pins are likely an ephemeral state.

In this situation, MADV_COLLAPSE returns -EINVAL when it should return
-EAGAIN.  This could cause userspace to conclude that the syscall
failed, when it in fact could succeed by retrying.

Link: https://lkml.kernel.org/r/20230125015738.912924-1-zokeefe@google.com
Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2608,6 +2608,7 @@ static int madvise_collapse_errno(enum s
 	case SCAN_CGROUP_CHARGE_FAIL:
 		return -EBUSY;
 	/* Resource temporary unavailable - trying again might succeed */
+	case SCAN_PAGE_COUNT:
 	case SCAN_PAGE_LOCK:
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:


