Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B9022EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi/vI9QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3712C433C7;
	Mon,  6 Nov 2023 13:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277451;
	bh=Kr1mzh1uYI4WNJIcFl8g3q8vXQ7Zu6B82UH/TfWC3o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pi/vI9QTiAgHyVZPmWv7kKEfK5IqOFgHlJEOW1lH/9e/RTYX3DNNl9F2QNwG4L9lC
	 sG9xGmf9z2ZUznmvPROcItc3H62TrU/xrpkDUwloVLBSPFxbjb+FZMmzIk7GwQLmBn
	 BE9LgzsfQq5xQHSPxY5tWUSOQMAGoZwArgCM4gLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 06/95] mm/page_alloc: correct start page when guard page debug is enabled
Date: Mon,  6 Nov 2023 14:03:34 +0100
Message-ID: <20231106130304.911347263@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 61e21cf2d2c3cc5e60e8d0a62a77e250fccda62c upstream.

When guard page debug is enabled and set_page_guard returns success, we
miss to forward page to point to start of next split range and we will do
split unexpectedly in page range without target page.  Move start page
update before set_page_guard to fix this.

As we split to wrong target page, then splited pages are not able to merge
back to original order when target page is put back and splited pages
except target page is not usable.  To be specific:

Consider target page is the third page in buddy page with order 2.
| buddy-2 | Page | Target | Page |

After break down to target page, we will only set first page to Guard
because of bug.
| Guard   | Page | Target | Page |

When we try put_page_back_buddy with target page, the buddy page of target
if neither guard nor buddy, Then it's not able to construct original page
with order 2
| Guard | Page | buddy-0 | Page |

All pages except target page is not in free list and is not usable.

Link: https://lkml.kernel.org/r/20230927094401.68205-1-shikemeng@huaweicloud.com
Fixes: 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8932,6 +8932,7 @@ static void break_down_buddy_pages(struc
 			next_page = page;
 			current_buddy = page + size;
 		}
+		page = next_page;
 
 		if (set_page_guard(zone, current_buddy, high, migratetype))
 			continue;
@@ -8939,7 +8940,6 @@ static void break_down_buddy_pages(struc
 		if (current_buddy != target) {
 			add_to_free_list(current_buddy, zone, high, migratetype);
 			set_buddy_order(current_buddy, high);
-			page = next_page;
 		}
 	}
 }


