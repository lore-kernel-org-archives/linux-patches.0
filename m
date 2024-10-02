Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBCB1D078A;
	Wed,  2 Oct 2024 13:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875596; cv=none; b=VO6kERUsnlpBCBkcSyYrBo3el2HQ54upyVSDen3EGziCjQLDnJxdhKWxj1ZNohyTXbbTlr5GA4QQbBB10ZyFYv5g3zypXfjGnjog9NSZEIveFwN7V387+xRpt5w88n/PCe0FSb9vYJ2iIoTNuAksR6ZYLntfLGrRHRyk/D2EaYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875596; c=relaxed/simple;
	bh=e3iW9uBazJvSaXtsMxeoWM1UR/nyTVJe1BcUaE65+ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVToXrRDcJCGD+kCIJQRhtNodQ0ArQXR3ofvPsxWSUimJ12+bYG6hLq4UcMOFUGFUYQyKpcjChHnfEEdFTCyrxL72LGEqDp+6h4noGPh6A6K+FRpfFFwrv7DGqyoWjO8Lw8OP3n1Lkp+u2KMKoTJ0eiHteRljIMs5Vib00CyHB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWmO/OBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWmO/OBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554F1C4CEC5;
	Wed,  2 Oct 2024 13:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875596;
	bh=e3iW9uBazJvSaXtsMxeoWM1UR/nyTVJe1BcUaE65+ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWmO/OBtIb9FF73wYqjA9DD46JUuooe+NPtBOg12CR+32p6mYqiLpAZLtzJBUkkow
	 1ekY88drdkcW1hKyhWc44mzegMh+Hn5w66aG0wPRQ9TrMvFSlJU8k8m95q5zgHybc5
	 Ngqu1dGPEL8+igZtO1Vnz3kVkmQDhsVja43juSlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wouter Verhelst <w@uter.be>,
	Damien Le Moal <dlemoal@kernel.org>,
	Eric Blake <eblake@redhat.Com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 124/695] nbd: correct the maximum value for discard sectors
Date: Wed,  2 Oct 2024 14:52:02 +0200
Message-ID: <20241002125827.421599369@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wouter Verhelst <w@uter.be>

[ Upstream commit 296dbc72d29085d5fc34430d0760423071e9e81d ]

The version of the NBD protocol implemented by the kernel driver
currently has a 32 bit field for length values. As the NBD protocol uses
bytes as a unit of length, length values larger than 2^32 bytes cannot
be expressed.

Update the max_hw_discard_sectors field to match that.

Signed-off-by: Wouter Verhelst <w@uter.be>
Fixes: 268283244c0f ("nbd: use the atomic queue limits API in nbd_set_size")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Eric Blake <eblake@redhat.Com>
Link: https://lore.kernel.org/r/20240812133032.115134-8-w@uter.be
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 69b9851b67982..8b243144fd64f 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -350,7 +350,7 @@ static int __nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
 
 	lim = queue_limits_start_update(nbd->disk->queue);
 	if (nbd->config->flags & NBD_FLAG_SEND_TRIM)
-		lim.max_hw_discard_sectors = UINT_MAX;
+		lim.max_hw_discard_sectors = UINT_MAX >> SECTOR_SHIFT;
 	else
 		lim.max_hw_discard_sectors = 0;
 	if (!(nbd->config->flags & NBD_FLAG_SEND_FLUSH)) {
-- 
2.43.0



