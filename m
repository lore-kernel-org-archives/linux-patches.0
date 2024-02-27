Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4002F2D;
	Tue, 27 Feb 2024 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041410; cv=none; b=YhT2aSZD87/NKVIgkA5/3+Rla2Ysr+rEN8fAsq3DZg+Cjc4Mx0r/JwuJO8fwJcXCNcLgnCm9xFnWj80LjmuBkV5kibZLyfab5l4p3pkUZEjgnMQGNryhlfPxMgYKHokUAo835gyvcmPSzHonqaJruxTaYyWJWTOJ9kCC6grvPJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041410; c=relaxed/simple;
	bh=LeiEFKRior6T7LQf/EO6RKX8j9M6RTC70nxbLC3SJGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XM+e/L9T8WszAM8mjFySTLDdl6TrKaPjOVwfcKVEX9aPqbfSsgFk6+7AmdjZZo2nInkYJN8tIraSNCOiCgs2q3crIuqA5Cl6M23kyF6rrAjnyKgSwIbwwE6ODCYM3nGm6MouhSTjgkHn3Pykn/E9kcBVX884hQrDbO+aR347Hq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFlMM2w3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFlMM2w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C99BC433F1;
	Tue, 27 Feb 2024 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041410;
	bh=LeiEFKRior6T7LQf/EO6RKX8j9M6RTC70nxbLC3SJGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFlMM2w3nEhMvmIP8JwT3Pi+mIYCy5UMStRobEAP3jqxstbQr3flcHRPzEYAmizyu
	 3yi5NS6AaCp1jmtbO8Hm1LRkFWgThhb4btfNojp8VJyT8lf2IKupnNP/xz/Fd6Kv2p
	 CB45QV9opoVrz9A6D2M8jpEudMHesRMbNI9fMbxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Domenico Cerasuolo <cerasuolodomenico@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 330/334] mm: zswap: fix missing folio cleanup in writeback race path
Date: Tue, 27 Feb 2024 14:23:08 +0100
Message-ID: <20240227131641.782155287@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosryahmed@google.com>

commit e3b63e966cac0bf78aaa1efede1827a252815a1d upstream.

In zswap_writeback_entry(), after we get a folio from
__read_swap_cache_async(), we grab the tree lock again to check that the
swap entry was not invalidated and recycled.  If it was, we delete the
folio we just added to the swap cache and exit.

However, __read_swap_cache_async() returns the folio locked when it is
newly allocated, which is always true for this path, and the folio is
ref'd.  Make sure to unlock and put the folio before returning.

This was discovered by code inspection, probably because this path handles
a race condition that should not happen often, and the bug would not crash
the system, it will only strand the folio indefinitely.

Link: https://lkml.kernel.org/r/20240125085127.1327013-1-yosryahmed@google.com
Fixes: 04fc7816089c ("mm: fix zswap writeback race condition")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1105,6 +1105,8 @@ static int zswap_writeback_entry(struct
 	if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
 		spin_unlock(&tree->lock);
 		delete_from_swap_cache(page_folio(page));
+		unlock_page(page);
+		put_page(page);
 		ret = -ENOMEM;
 		goto fail;
 	}


