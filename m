Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ACF7F47A;
	Mon,  8 Apr 2024 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584993; cv=none; b=KJOfVX6LBuQHdA9NNTRrwv+HlSQoklthLpIl/S9gd8eZ/Z8mBLpozuO2x3cHV2NsBZNSAWgrmQ4wcp8t1Cwo7O2T473Rh1UukMuYT9Ncq43NiqRvbD/1Wmvw37sPolNul0yS4OqmlwzLSrRtf3NqRjmRCU0kUsQ0XPuZEX2Q/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584993; c=relaxed/simple;
	bh=6NrhKXS8tWmwRqz3JgQoiuLA7IbcI5gjBUBHJnEeGC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beokJbr1Og4+7nvi+z8ttDe0TYyLoy4+f7Hp8fVFDJPloM4N9ilxmMBUyxpMRI9KkLPhjPXCOYA0bKxyxSYrPcdBTk5oSBNB09QgkrDByIFeFvvV7W7+ldBsGbLM1IzDhp+lSvlhW3WHgFtmbMJjejiKpg7hDqRFwVlNmYkENwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgp1KYIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgp1KYIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E6CC433C7;
	Mon,  8 Apr 2024 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584993;
	bh=6NrhKXS8tWmwRqz3JgQoiuLA7IbcI5gjBUBHJnEeGC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgp1KYIKUMmgkg0GaBROEIGyQ3xBYT9J9gOJqxN/8k7x3Ae/mzCjEfXQwznU4gRax
	 DC/4nHz7nIDJFc9iJ4mFUhJ3vjCY4VU4XigcBTTGoDEWoZxPrTJTM8UpsIy1Z+6x6I
	 /G+Dw7j6QikYz9Eg4TZT7XACP+4/CvaMQUlRxg1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonidas Spyropoulos <artafinde@archlinux.com>,
	Arthur Borsboom <arthurborsboom@gmail.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 627/690] xen-netfront: Add missing skb_mark_for_recycle
Date: Mon,  8 Apr 2024 14:58:13 +0200
Message-ID: <20240408125422.376640263@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -287,6 +287,7 @@ static struct sk_buff *xennet_alloc_one_
 		return NULL;
 	}
 	skb_add_rx_frag(skb, 0, page, 0, 0, PAGE_SIZE);
+	skb_mark_for_recycle(skb);
 
 	/* Align ip header to a 16 bytes boundary */
 	skb_reserve(skb, NET_IP_ALIGN);


