Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064046;
	b=KENDExpIw4thLyDVmdsXacIe65ZpwDS87jwooDX1uzgpXUzaaay6QgdShkKVOvZzzozI
	 ngm5ZKLdXazpuNqnVeM125aysvlBVXQNAIuXF5mnglGcUWqmjr5izgYSQRy1+IXtk7ZZz
	 PcTJRjo0+ArIYHkjXZe8Z6BZJSOFWnZ1EDjHMfYZ5bteLBn5S59oHXE7FwvWGGoL6qMNo
	 +4/sYtooF+vBHYPwO06MSu6Kz9SsRl5Vm193PsPQIu2HW1W1BWoWTj0bVfQK0TJ+rfTLQ
	 uYmgq17uWewlx6/M1M3QQgq5mBx28EAuqSphE0DWZNQMEaXDlmD5dSYkTmGTH1L3OMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UlivVkrf8PQgnqpYym9zv9P2ZVTrSkZO5IvlLNN+iq4=;
	b=CnGpxOswJdvp28E7rHFfyUe4jvkCcUQZ1+f4nKLLH5Zll7/Uy7gbdCIxQIYHwRZ4wMIJ
	 e7XbNAaDPF1QxrfbRYWUofAcNi9SewNL3N1LCgRE9y3PsB/L987WCEwBJvYbijKnbU2Ds
	 YMmxqwJ28jxRmslUosTij2N+sg3vIOA/HpPzGd2qBt+5/lt5h5hPp9qD1G+PBTxnb3mdZ
	 pN+rF70Ay6k8yJ3KaARewd9G08q94b1+mab3jjVYUDPJUtmYSCJtZ0Y8JdkhoNPJd0qNs
	 L5q1J6Z6BTbMi1xIMLwwLl9yub3asm1uylCnp5iGlYheJGeZ1x4QTtMbmXRStXK+dvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsgLEyTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B976760A5BDD;
	Sat,  7 Nov 2026 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsgLEyTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692671F008A1;
	Sat,  7 Nov 2026 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064045;
	bh=UlivVkrf8PQgnqpYym9zv9P2ZVTrSkZO5IvlLNN+iq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsgLEyTry4RoaCgwqk88PB8Sb5hT33QatAq7Z/tvao4AbY9T39Yg7btn4J2ghYC5A
	 qhpEOk/+7qC+uL0xtBs/YUQPPwL7Nesq4usyOnj7OMeeH7EoQ8DsBJs/RAm+geIZEb
	 IK/Dvr+ELRWzStwf1xywRRXOctPmKI58/Fl7VKxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0219/1257] i3c: master: Fix out-of-bounds read in DMA bounce buffer setup
Date: Sat,  7 Nov 2026 08:41:55 -0500
Message-ID: <20261107134945.586159284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index afcd7a21a3e66..f9a6c8560fabf 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2216,12 +2216,11 @@ struct i3c_dma *i3c_master_dma_map_single(struct device *dev, void *buf,
 
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



