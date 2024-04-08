Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD137FBBC;
	Mon,  8 Apr 2024 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582340; cv=none; b=uNg3z+60MD/1GatA42m6/v1btEbvEiok1XB5V1gggoliZTT/VSjBqYa+ZSVsek6UgsgEXJzP9Ey71ZcheWxfoJCZEf0NwJBV98H0SQrZ/3OdeJTr9YAKKUM/COMxboeY8woAE1CU07qcbOucCV3Ik/uo+CszG0eT9kc4Ts+0YiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582340; c=relaxed/simple;
	bh=p9BHwuc7X6ky+qDzGEjoVzWBW7/nNwtpbQFpt/DpULw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIoaVj120GqFMaKSPQImgnZZAKA9bqUqjBbLSt6pPZNu56YMuOuV9ffoyCOERSL3Q5ZqIEbl8RcSsp9O1cL1hKs+6e44Upqz4MWLLiMbzloH3tQk6G4BGdzC9lYEjNT45nO1j84sGYvj2hieq73LBhQZLroUhDKHM+iElSUU+5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XC65ypN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XC65ypN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03363C433F1;
	Mon,  8 Apr 2024 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582340;
	bh=p9BHwuc7X6ky+qDzGEjoVzWBW7/nNwtpbQFpt/DpULw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XC65ypN7ZolFLu0wDiVhWHnVEsMSCaBKoqC9BuhM4mRVc/GS61sPhfBu82odxqFcZ
	 sf79oKNqBpdvhx6ZXJ2t2bg+OveyKRGJre2RYRR21SJHH4bXX+KA1FtwCcHJKixiC7
	 Tm9gKzWlbv45Ik+RgLkR0KeyqSGhuF5XJs5XI+Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonidas Spyropoulos <artafinde@archlinux.com>,
	Arthur Borsboom <arthurborsboom@gmail.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 085/252] xen-netfront: Add missing skb_mark_for_recycle
Date: Mon,  8 Apr 2024 14:56:24 +0200
Message-ID: <20240408125309.283301521@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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


