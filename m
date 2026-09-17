Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394363D9523;
	Thu, 17 Sep 2026 18:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671469; cv=none; b=Hu5yeQm4eSjIAdjrQ1mP4hPc3T2Lkhg2O3pDrpEA0FnRKv/wcgdZ7Gqx7U9xyutnZO7k1kr5y8dboO6g/bS8jjW/7/noEVE7POPG7ifnhEvM6o89buNQJ9jp4Uaxselj76zjyILADhMB0wE45XU3hRe+lYL+9QTSnPtvZP3A0kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671469; c=relaxed/simple;
	bh=7GssmdokJDW/uVU0+diikYvJmgTBK0vRxd7uorHsqC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHdLlT7AfonGtlG/Kfmz9x2Oo+jKRsukC0MeH2gtIytJQFb7WYHiu6x6hbarCKwCM5CQ9jGWpa/P1VaaoMd2kgI4bIGcRnRxwVRKvWJry+ro/qNJt4xn7eEc4YnbP9l1NxQhfB+PbjG4AE6c65YnW86yVdLs0jz7I2glfcvCMt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oj/f8ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oj/f8ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7431F000FF;
	Thu, 17 Sep 2026 18:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671467;
	bh=ateR8ZB7yNhL6mPbK/ETz9qXSs7txfcpGIc7zdXyC9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oj/f8aioP5NArv2zndGloeZHKp3wImqygASSBJSSqtboBQVr52fpgg5X5J8nhJFg
	 GUGlnypluaUSrPUw9jAEJ1j3RzOyNTkVyVgkbWKjexGVTFw607SyarHmW0QzzshO7H
	 o1EFJIa4Fj9e8/eTk+dPN1kPKF6nrSb05zdMk7rM=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0986/1102] mm, swap: ratelimit bad swap entry reports
Date: Thu, 17 Sep 2026 16:15:29 +0100
Message-ID: <20260917151605.461622195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f9dc428249ed962a70acf301f01eae8578449161 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1498,11 +1498,11 @@ struct swap_info_struct *get_swap_device
 
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
@@ -3666,7 +3666,7 @@ static int __swap_duplicate(swp_entry_t
 
 	si = swp_swap_info(entry);
 	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
+		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
 	}
 


