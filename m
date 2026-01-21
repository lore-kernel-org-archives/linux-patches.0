Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055DE339848;
	Wed, 21 Jan 2026 18:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019796; cv=none; b=riqcUJJp3V+Nqwvx4mDfxjwvt6swdhi1IMAR4ZK11C2TZP8DUwmqYeWCJz09mXUOpZEvrmBm040+1zMve/qKVPjuAEJzmqVEcDpiuplDI0aFqfpV0A5eMDMR8BAz4uM2xogfYnaJdn0f+iGXEEIm5NW5wpb/L0VG3wl+V8Bywms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019796; c=relaxed/simple;
	bh=4hg7gJ/ay8mROo6Smcx5qel0hQffhxeviLAHs8wqh8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJwSm+9vn8gD0V1b1CXTJNd2fC74fIklaeaFVL35P5PtIAaqfwvK6zjULd0VnpF59RoGJvP9w3FVCdnlMnrZzwUm/2P+xUKi2Tse+x5FXTPyDlgw9BlaaGvLzBmjFoOHZMG8zNmV9NMFz2ExuV5fTo0zNMBfrzoikXY9KL4BWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbHIgZs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbHIgZs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5036FC4CEF1;
	Wed, 21 Jan 2026 18:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019795;
	bh=4hg7gJ/ay8mROo6Smcx5qel0hQffhxeviLAHs8wqh8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbHIgZs3Xztnw1FsF1kkSme8QBQDUpY3gVLhMbxz665PqFZkZRzCFI5mIjuteIuSn
	 qloBMRnBDuSCbs9OqrBXEaef9zfWOH//JcIz/l1UZE1TZ1Hmg7hEYaOU+vwqeHIMGg
	 GMVMeI42EJrRCRya5DEyl6ukInCRtYgPbXpgvPFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 111/139] dmaengine: dw: dmamux: fix OF node leak on route allocation failure
Date: Wed, 21 Jan 2026 19:15:59 +0100
Message-ID: <20260121181415.443015565@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit ec25e60f9f95464aa11411db31d0906b3fb7b9f2 upstream.

Make sure to drop the reference taken to the DMA master OF node also on
late route allocation failures.

Fixes: 134d9c52fca2 ("dmaengine: dw: dmamux: Introduce RZN1 DMA router support")
Cc: stable@vger.kernel.org	# 5.19
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20251117161258.10679-6-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw/rzn1-dmamux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/dw/rzn1-dmamux.c
+++ b/drivers/dma/dw/rzn1-dmamux.c
@@ -90,7 +90,7 @@ static void *rzn1_dmamux_route_allocate(
 
 	if (test_and_set_bit(map->req_idx, dmamux->used_chans)) {
 		ret = -EBUSY;
-		goto free_map;
+		goto put_dma_spec_np;
 	}
 
 	mask = BIT(map->req_idx);
@@ -103,6 +103,8 @@ static void *rzn1_dmamux_route_allocate(
 
 clear_bitmap:
 	clear_bit(map->req_idx, dmamux->used_chans);
+put_dma_spec_np:
+	of_node_put(dma_spec->np);
 free_map:
 	kfree(map);
 put_device:


