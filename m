Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3E11D07B5;
	Wed,  2 Oct 2024 13:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877524; cv=none; b=KCw+/9sphkTKhM7+oJ4jiSomWecH0XFtgCHfTaLUGa7u8zdJQ82F74mxFss1AgH/bswdbGo7hlXig9hR9/TRk9luAAXWBkGCNPBWlLu81L2hi+yQu86n1y9BxfsfI3hACmSV++agzk0bAlKhLNzC49nAZ9eVkhXJzutZUesmWmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877524; c=relaxed/simple;
	bh=8IRFKWqw8FyWnjEz73TgolDyIfQU3ikeJM7dGiY/tIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVnieI+StJIMaZKTS5JPCZV9vGeILPI+DU2GQJMx5KxWkSIL4faxEeVP8SZaagMG5D++kYlwKH885Lj2cxXsDy0y5RH0FfcQ7r5MnOQjeLrgovP7sWyry+6K7hPgzWb/HgXdCTsMSHRfHPeY1vZnxKtXmx0bYoa0lzAGIHbbjNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywu6pT8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywu6pT8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1A1C4CEC2;
	Wed,  2 Oct 2024 13:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877524;
	bh=8IRFKWqw8FyWnjEz73TgolDyIfQU3ikeJM7dGiY/tIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywu6pT8G4J/Sg25/ByAWb+g7dCbGSCzaRsjN1YJCREnoSEMNVeKyTgrbOxqciOGlr
	 9rNarpNj5TI42IJFrwaHzlVtUNg08Gx8Li8naExi4JGPQvAbuCPeNksNDK88s01QAD
	 V18m3+UCp/aqTxkbEeq+dtNFFyrRqujd878VQuNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wouter Verhelst <w@uter.be>,
	Damien Le Moal <dlemoal@kernel.org>,
	Eric Blake <eblake@redhat.Com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 108/634] nbd: correct the maximum value for discard sectors
Date: Wed,  2 Oct 2024 14:53:28 +0200
Message-ID: <20241002125815.377897909@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0e8ddf30563d0..d4e260d321806 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -350,7 +350,7 @@ static int __nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
 
 	lim = queue_limits_start_update(nbd->disk->queue);
 	if (nbd->config->flags & NBD_FLAG_SEND_TRIM)
-		lim.max_hw_discard_sectors = UINT_MAX;
+		lim.max_hw_discard_sectors = UINT_MAX >> SECTOR_SHIFT;
 	else
 		lim.max_hw_discard_sectors = 0;
 	lim.logical_block_size = blksize;
-- 
2.43.0



