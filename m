Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8915E3AFB1C;
	Fri,  4 Sep 2026 05:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500488; cv=none; b=jl4mwx8P/TjNBHeC++ZAbbKboA8zrrRptI8DdvHkBjPyCCK5jxupWdiVo4J0Y0qpUu5uhabQ35xvhwekam5ESPyZ6FWaec1zF/GGV22+J+9Zf7qshR081q/gZBAlEG8C4UfRo7PcO3to5Zge663LzC+3rx8QhKPZzPZYeY9HaTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500488; c=relaxed/simple;
	bh=UbFsZN6q1PQvbd5EMKnmduoGu8bWxYUWC+eap6vbY+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGqwTns7CWza1U1w5TQUG83UjjH4FGBkIsoXmlT3U544CFIwuNIcSjmDVrgHti16IGWH22BmM8ZzIRc9JQ2V9NGzwpm93JJ5a4MzKhLr4JmAv/cpxOoFVj/YKaESuvcoiOvBsqX17UkWUp8lpWiPfKqsbRA8nhETNUSJVEyq3bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPd+4K5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPd+4K5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F331F00A3D;
	Fri,  4 Sep 2026 05:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500487;
	bh=INIJ/bDLOsdwpNDYFi4tCPYjBreb5y+4gd/SlhkRFDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPd+4K5ztaz+6I2oIw97duntzo2tT26Dcm6RjWpjkz/sKf+bvJWwJ/494kyO1yoTY
	 NzBV2E5Ono4H9m2WOb3u2viUxIZ/farv5XuhtGeyYusWSae9cRyZ6hVw7TOXZLw7i1
	 7JMMbP12F73SKGPydcvUtkkc9rjT6wcjV1Gz2I7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Barry Song <baohua@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 031/552] mm, swap: ratelimit bad swap entry reports
Date: Fri,  4 Sep 2026 06:53:08 +0200
Message-ID: <20260904045748.534901476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit f9dc428249ed962a70acf301f01eae8578449161 upstream.

A corrupt page table hands the same bogus entry to get_swap_device() on
every access to the mapping, and every rejection is logged.  One machine
logged 6185620 copies of the same line in a few hours.

swap_dup_entry_direct() prints the same message from the fork path, once
per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
does not.

Rate limit all three prints.

Link: https://lore.kernel.org/20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org
Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1613,11 +1613,11 @@ struct swap_info_struct *get_swap_device
 
 	return si;
 bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
 }
@@ -3753,7 +3753,7 @@ static int __swap_duplicate(swp_entry_t
 
 	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
+		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
 	}
 


