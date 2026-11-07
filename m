Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062899;
	b=rq31O00wIM0OvQr2qEAyq7V2q9v6tEll6zMUC1v4Cf11hcraZPbg+1UwhFxVumxtj43J
	 J0e1NizkU2wKMJG73KJ2jkkduzU6rAUDjES9dCWEszap3kiDXF22S3aGvK1NBWcr/bRjw
	 PCkEWEUYJxPSGDfAdgxFSNv43rIVuoYDEuSByXSlZ3jPZ/HdgL1F48NX2ctrIohwrza7K
	 ZSLav1SJv/f1WRXYLnKcs5mtPsnIecUwQ/iz3XEnVuuR3xBZmuPcn0+Dgw/6D6B0v3FV4
	 HSq/6Bvrr8wFO0sgYYeB8Zd39fxaf739g3kDvPqHlQtDvKP+3AiUngM+UOd6SggN58g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uBBz+TuEMvx1QhR6uS4yQYz61ayXhYtNIvrUtAqnE5w=;
	b=xIbiueVQumi3IJTJjx04061ypp75gl+A4KFIOZbtBDRBY0pxm3NQBOGPGQFJz/XusXM2
	 Mm89u9B6FxH9ruTqcu91gGKkiDgOlxCqesCwVNRD7EA3khrJoqjkQSTtcv6ZzTErMe6HD
	 PeocQvh1vaR/61/eBeeXfoDUJLZG9AEhT96zJDT1TKbX6NIbSqLw3KPlAXAVCdL1efYUM
	 svNT/tqFupn/PY0jSYQDjj3XNwJnTw7s2OPN0vRHxeuiNrtTt4Z7fswj0r09vXBGvHRpr
	 0UM1DBg75xQXek0cBqd+ZZ6m3nnhDvG/g2AM/fOo0BkCeIJEBUyrpjpHhsx1Vcaj05g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3vwKJVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DC9606A326;
	Sat,  7 Nov 2026 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3vwKJVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AA51F008A1;
	Sat,  7 Nov 2026 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062898;
	bh=uBBz+TuEMvx1QhR6uS4yQYz61ayXhYtNIvrUtAqnE5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3vwKJVoTD+f8PbbNsBsfuDJ3qHOGSNV4hDJ0nUAlnPg3XPFd2RFRxODgA4A3eTi5
	 +Kx1NOxUccCqcj5yElNsd5ZKOzkDs6acghnQdQp8Tu3Kjn8ufFZoqD9I1FWSlUH9rs
	 ktU+wnsVVIxUhuo4Yjx0JqkOD4l9NFu7ttQ6PD8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/869] i3c: master: Fix out-of-bounds read in DMA bounce buffer setup
Date: Sat,  7 Nov 2026 08:47:36 -0500
Message-ID: <20261107134858.087859397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 35b028b25451e17d63b2cd36a11a86c5e18df1b9 ]

When a bounce buffer is required for DMA_TO_DEVICE transfers,
i3c_master_dma_map_single() rounds the DMA mapping length up to a
cache-line boundary:

	map_len = ALIGN(len, cache_line_size());

It then allocates the bounce buffer with:

	kmemdup(buf, map_len, GFP_KERNEL);

kmemdup() copies the full allocation size, causing it to read map_len
bytes from buf even though only len bytes are valid.  This results in an
out-of-bounds read of up to cache_line_size() - 1 bytes past the end of
the caller's buffer.

Fix the issue by allocating the bounce buffer with kzalloc() and copying
only len bytes from the original buffer.  The remaining bytes up to
map_len stay zero-filled, avoiding both the out-of-bounds read and
exposure of unrelated memory contents to the DMA engine.

Fixes: f8d9e56aeb87 ("i3c: master: Add helpers for DMA mapping and bounce buffer handling")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 038f7b2ec8c48..0dbcfb1a52049 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1955,12 +1955,11 @@ struct i3c_dma *i3c_master_dma_map_single(struct device *dev, void *buf,
 
 	if (force_bounce) {
 		dma_xfer->map_len = ALIGN(len, cache_line_size());
-		if (dir == DMA_FROM_DEVICE)
-			bounce = kzalloc(dma_xfer->map_len, GFP_KERNEL);
-		else
-			bounce = kmemdup(buf, dma_xfer->map_len, GFP_KERNEL);
+		bounce = kzalloc(dma_xfer->map_len, GFP_KERNEL);
 		if (!bounce)
 			return NULL;
+		if (dir != DMA_FROM_DEVICE)
+			memcpy(bounce, buf, len);
 		dma_buf = bounce;
 	}
 
-- 
2.53.0



