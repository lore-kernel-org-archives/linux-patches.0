Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ADD25A651;
	Tue, 25 Mar 2025 12:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905907; cv=none; b=iCort+sqWjc//H1aVYFvqbmq028J/MEi2wx05NAxr/njvMjAXssxluX9Zxhhlejurucuw9kaJBuVZA2PSoIwXxI/LUVKBuW0CfwGVHgw/fLc380vuPlXtDA1gjEiahEC+YC6svTH3md8/ZgtYJgZJY4BLDxEkj5YOfwO797XWrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905907; c=relaxed/simple;
	bh=vFeHJAuTvHZDQEtkrqLJVHXOKyfUyuNpdSwnTEaUe90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EckO5Ylo3uPturFGgdKz2C+3qbdo11NIOIAoOXgBAQvv6yOzS6Xwzn+ouJq0d7ioo05276dDSP08x4obwaYGIY7DNjjNHqFL36vF1ALczf5noy01xsLB54MOdaedOq1VMGyEfmL9iiDk/iVfCW+wu7wwxSZle/rAuizmEp+mrbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjunqzdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjunqzdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7AFC4CEE4;
	Tue, 25 Mar 2025 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905907;
	bh=vFeHJAuTvHZDQEtkrqLJVHXOKyfUyuNpdSwnTEaUe90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjunqzdWjsB+4sf/T+gpxBQ0vQdmsAN7QdIoFWWzCfoHUReNjlR0GNrrBrJZISs9C
	 OKS9FBXPZS5jKuRkQx4HlH00O8Q1TYO3JOgYpoi/W/vHRV1dtlqWveFGfoggFp4Dg7
	 cMQS4l2ouGVh+bfYfq+Wtzvj/wCCZYyVbR7ldFL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 030/119] Bluetooth: Fix error code in chan_alloc_skb_cb()
Date: Tue, 25 Mar 2025 08:21:28 -0400
Message-ID: <20250325122149.834616958@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72d061ee630d0dbb45c2920d8d19b3861c413e54 ]

The chan_alloc_skb_cb() function is supposed to return error pointers on
error.  Returning NULL will lead to a NULL dereference.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 50cfec8ccac4f..3c29778171c58 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -825,11 +825,16 @@ static struct sk_buff *chan_alloc_skb_cb(struct l2cap_chan *chan,
 					 unsigned long hdr_len,
 					 unsigned long len, int nb)
 {
+	struct sk_buff *skb;
+
 	/* Note that we must allocate using GFP_ATOMIC here as
 	 * this function is called originally from netdev hard xmit
 	 * function in atomic context.
 	 */
-	return bt_skb_alloc(hdr_len + len, GFP_ATOMIC);
+	skb = bt_skb_alloc(hdr_len + len, GFP_ATOMIC);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+	return skb;
 }
 
 static void chan_suspend_cb(struct l2cap_chan *chan)
-- 
2.39.5



