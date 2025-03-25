Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1432E25A323;
	Tue, 25 Mar 2025 12:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905784; cv=none; b=BvIF3OU+w+ubA78SGFJ8EJ1UOML1XapR7k8/1WTxISL7FfWxmYz1mfZOdjq/IBIQENZGIeSTDtrEZp08oEHZuZbcSMpPvnhQhy45n5e5ky6SvVa1Of2o12ZzG2VtIhesUp8wGO9bt66VKzn48AMIuf+JPsC8+xB6SRVRgS2Y1ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905784; c=relaxed/simple;
	bh=0wXUQbi8WmcrOyYi5g2tk42joW9gS3LNs2aD0zbkMkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQid0qInJZrpzB5oX28cZ9vOhA1y4JdEP5sKyhHsd4Ihzzx/IgfEC8GXdd2idK76YZp1Ap7QY/rTFbXvMRqXKV/2d6o7ybUk6rcCYfkFXnaXL08vPNjuVdY5m42CfSG2mU4ui9baMMv8rUtDCPDdNy8p5mxSIARSO0n/zSJBaRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZdMT+3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZdMT+3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78D0C4CEE4;
	Tue, 25 Mar 2025 12:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905783;
	bh=0wXUQbi8WmcrOyYi5g2tk42joW9gS3LNs2aD0zbkMkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZdMT+3B7eM2VxrNi9F7eT0GQA6Iy1deJarKv0wKIgatYRW9ZA5ISEfu+VdpXZX4o
	 Kl8aNTRfHPRefOam69x8m4dQh8UU+/uRVFhGZT1rWQuPphoId5ET5f4JOER4nsTB1o
	 VabnEzF2SaiXJ59RqjXhvl58/Lxhll9bKqph+hxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/198] Bluetooth: Fix error code in chan_alloc_skb_cb()
Date: Tue, 25 Mar 2025 08:22:03 -0400
Message-ID: <20250325122200.878422396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4eb1b3ced0d27..db119071a0ea0 100644
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



