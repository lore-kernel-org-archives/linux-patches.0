Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BB31FA24A;
	Tue, 17 Dec 2024 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456651; cv=none; b=SGD9dTbrramlNhvK/bGoIC+x63bHMHrr8nKyDn7k/kJRSuLhCma0Sx80ttsDYXHc3YUuj295jCgdr7vQHIDTJzs8WP/sIA3W4m2K2C2tM50xLgycBywxeRX8/POeT2VsXtsGBC6vUzdlz3Xck6ydDjGsYqnprEv2jvB46+NuIfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456651; c=relaxed/simple;
	bh=vJQTn2eotknXEYMM/KLywWO90eW2TYtjS3qDr4cEX+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL2F+FnGo/Nm0psXXuGk2/yHZ1s8tn9+sAxzq325j4DTjG3Ym5ATsig6xjYVtJOafEhcdq6u8JNAaM2MelGN+dqqlaAwMuv/VJgSf3+5zKPC2a9nbxWX8sVFKD408ZgdDS5WL7Qro8jXgj0ejgRHIrQCs4zqkV9Hv6PdskciPzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hs6nFBF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hs6nFBF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47044C4CED3;
	Tue, 17 Dec 2024 17:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456651;
	bh=vJQTn2eotknXEYMM/KLywWO90eW2TYtjS3qDr4cEX+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hs6nFBF2r9fruv1ccRw3es5KF5wTojWvBSZisYiE+mNa3dtL98PN7lkuCkKJYoLhI
	 G+hemO7o0Eyh1uDPaNMoLkvfZDd5oYmmSxft0PHhjNHedj1sRGP/yK6d5COdVyITZe
	 1gyTXUeqb4++zNn9G1VF8ZllvM+WHRh6AjJged9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/172] net: renesas: rswitch: fix leaked pointer on error path
Date: Tue, 17 Dec 2024 18:08:01 +0100
Message-ID: <20241217170551.526549059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c251becef6f8..af0bc95ad6ae 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1703,6 +1703,7 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	return ret;
 
 err_unmap:
+	gq->skbs[(gq->cur + nr_desc - 1) % gq->ring_size] = NULL;
 	dma_unmap_single(ndev->dev.parent, dma_addr_orig, skb->len, DMA_TO_DEVICE);
 
 err_kfree:
-- 
2.39.5



