Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DB52DF73;
	Mon,  8 Apr 2024 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581574; cv=none; b=cs1gitv3JtzaBitT7AyDEMvHJpoFyonaxe/mLr3Upac2YXNLuGtkojX9j4haxikNjhyOCi0TAH/HL6siXpHX/Sv9c3ahIVqQFu8bXlbuKmafHWrqXN8sWID2ZpUo4fe/Iba7dOhF70iW3BAeWVsskkYFk75TMaPwAz8e5rGqDAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581574; c=relaxed/simple;
	bh=/GLMz7jwqjZJC6HlweZdMKG7pmuHkh7aQ5W5bhAeQi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUdUscdNgTiHhvRRkh9TmUSP133Gm2IxNd2YM5q1mjDrHg4ZcQa7sTBuoP8jKDOvDq/b15mZ+01y3uPj6Ce0KGbXvbcXGk9RzOgasyZoUmtqn95Xu6HUHGTiUz8x8OnEClr0Cva+IOs+FfiIS9Rn8L1AxmJwIVG1QhJbWh7Gp7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sc5WkP8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sc5WkP8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FB0C433F1;
	Mon,  8 Apr 2024 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581574;
	bh=/GLMz7jwqjZJC6HlweZdMKG7pmuHkh7aQ5W5bhAeQi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sc5WkP8ia/og0DJW5Yrbe32T0/OUZbLBoA4ujt3pgxMUInnC51iVo7Ed8J1A+0fVZ
	 F8NDh8h8EUith42E/zhK45JwWuvwt5Qb2yHaqtEXJfv3cIydh0AtXWSlUxzwGKO/m+
	 wAYf+zi+dJV5oNhgXkSzOI/+eL88Owq41khEmXqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonidas Spyropoulos <artafinde@archlinux.com>,
	Arthur Borsboom <arthurborsboom@gmail.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 035/138] xen-netfront: Add missing skb_mark_for_recycle
Date: Mon,  8 Apr 2024 14:57:29 +0200
Message-ID: <20240408125257.315942174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <hawk@kernel.org>

commit 037965402a010898d34f4e35327d22c0a95cd51f upstream.

Notice that skb_mark_for_recycle() is introduced later than fixes tag in
commit 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling").

It is believed that fixes tag were missing a call to page_pool_release_page()
between v5.9 to v5.14, after which is should have used skb_mark_for_recycle().
Since v6.6 the call page_pool_release_page() were removed (in
commit 535b9c61bdef ("net: page_pool: hide page_pool_release_page()")
and remaining callers converted (in commit 6bfef2ec0172 ("Merge branch
'net-page_pool-remove-page_pool_release_page'")).

This leak became visible in v6.8 via commit dba1b8a7ab68 ("mm/page_pool: catch
page_pool memory leaks").

Cc: stable@vger.kernel.org
Fixes: 6c5aa6fc4def ("xen networking: add basic XDP support for xen-netfront")
Reported-by: Leonidas Spyropoulos <artafinde@archlinux.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218654
Reported-by: Arthur Borsboom <arthurborsboom@gmail.com>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://lore.kernel.org/r/171154167446.2671062.9127105384591237363.stgit@firesoul
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -285,6 +285,7 @@ static struct sk_buff *xennet_alloc_one_
 		return NULL;
 	}
 	skb_add_rx_frag(skb, 0, page, 0, 0, PAGE_SIZE);
+	skb_mark_for_recycle(skb);
 
 	/* Align ip header to a 16 bytes boundary */
 	skb_reserve(skb, NET_IP_ALIGN);


