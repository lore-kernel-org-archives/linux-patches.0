Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F76B8615A;
	Tue, 17 Dec 2024 17:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456142; cv=none; b=Cq4mJxn9Q7zRTojYvk7ZRlEWLG6S6eSMLzseYQJCU+0xkAmJw5Xb+VPPjoGgqSEJ4uP0Me/EWFIVfO7N3Jw8WjmrUR5+0kTJGA+pdGjzDuwSKBBhCIWry6G6Jr4ND/dpyJcUzhHlchGWOwFftb6AMe84X6X+QrfGbJO9lGCIJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456142; c=relaxed/simple;
	bh=O2olsEdDpWj/40ywc6hk6Ggizhh0OqOyK6Z6Xxfec2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSSZUESVZ2RIJgdOC5Ycw6Dkw2L0i5Ti2fztv3s8F7dwjG4WMnNizWN9tIU41SBp6oCrHeDbNCEYJbnTzu2XyqeYYZxCTWSej7qEH26Osjj4n9LUOZAHDdFgN7mL0+5FGAGXusEKYZDhWnyPe4X9Ts0+KYQ4ziRcD5hLQ50wD2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1I4XgXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1I4XgXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26224C4CED3;
	Tue, 17 Dec 2024 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456142;
	bh=O2olsEdDpWj/40ywc6hk6Ggizhh0OqOyK6Z6Xxfec2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1I4XgXvfiiCvasgEVXTRaL/qdcLF20JvowRpD30pUrkL2bQXYOq/Agj/0U4LklzK
	 PPtX1iI4jKRyLAQE572LQU4nL4LuLK807Ab0LiU7qZg/gQ5Q5odj7c5gOvlJt37ekw
	 8BOIZfpbkrFMM+GYZe9jt8q8oHjDVjxDQE44MbVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/109] net: renesas: rswitch: fix leaked pointer on error path
Date: Tue, 17 Dec 2024 18:07:59 +0100
Message-ID: <20241217170536.514943937@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit bb617328bafa1023d8e9c25a25345a564c66c14f ]

If error path is taken while filling descriptor for a frame, skb
pointer is left in the entry. Later, on the ring entry reuse, the
same entry could be used as a part of a multi-descriptor frame,
and skb for that new frame could be stored in a different entry.

Then, the stale pointer will reach the completion routine, and passed
to the release operation.

Fix that by clearing the saved skb pointer at the error path.

Fixes: d2c96b9d5f83 ("net: rswitch: Add jumbo frames handling for TX")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://patch.msgid.link/20241208095004.69468-4-nikita.yoush@cogentembedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 13577fe2c7ec..b1432ca79f1e 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1631,6 +1631,7 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	return ret;
 
 err_unmap:
+	gq->skbs[(gq->cur + nr_desc - 1) % gq->ring_size] = NULL;
 	dma_unmap_single(ndev->dev.parent, dma_addr_orig, skb->len, DMA_TO_DEVICE);
 
 err_kfree:
-- 
2.39.5



