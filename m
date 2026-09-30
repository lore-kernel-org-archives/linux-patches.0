Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3866037DE8D;
	Wed, 30 Sep 2026 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784173; cv=none; b=i7jiF8ef8MgykMIydCoYE2LBZGolQ7wj/M8KsjfPLEBR8GfPNj4+mA8+wwjAF6MKlBfSflldKjPbff8rnw7qQU+BCOWWPgUeTNiATkVoitJ2SR4bv+e5ewiUyawhVYaVSSWAE2oQtjiAqvQWF0u+yL6m/oHq7BfJu3ODXrnUnPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784173; c=relaxed/simple;
	bh=W1fOpayUz3xCAKz7F4vlSpGhfG+5O/dYsMi2tbhd6ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEXqiIadPvsFLq/QqwlvPUmaO/YdzdJZiWRb1Cht/9gR0neIsOj2iBM2n7Ymd2JwAodTncwNgYtw2229dvrC+eO2jQ9Kbs6QLE3HzqtTi/yeEKKWmfm+G1c1LWChSQAJAmM7Zlx3qyzMoQqcWv1Cm3I/HC8hvsaFQ+fNpdcXezQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvuSmAt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvuSmAt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A941F00893;
	Wed, 30 Sep 2026 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784167;
	bh=0f9bJ0L7uF5p5IAbqRrSRscUa/zfv62IoV+ejgqNzQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvuSmAt3XyQVEeO829G8bRBqZud+cMrf+O1Piu7hGaMK/zIAW1XgHljoiENusWNka
	 ZyChyraUWEsIZPO0m6zCEp5M/hLzUizgh0UtqBkbusCaYZ4/xqt4TgwLylpU6Z4wr1
	 f2fvy+XPS6PYwfCW3Zo38PoVHT0C6oSzRN4bV58M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Yu <2426767509@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/982] media: dm1105: fix missing error check for dma_alloc_coherent
Date: Wed, 30 Sep 2026 17:12:39 +0200
Message-ID: <20260930152417.292804641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Yu <2426767509@qq.com>

[ Upstream commit 3eaac9e02d8591d3c790db572ef1c8fa5a841fdb ]

The return value of dm1105_dma_map(), which handles DMA memory allocation,
is ignored in dm1105_hw_init(). If dma_alloc_coherent() fails, the driver
will proceed using a NULL pointer for DMA transfers, leading to a kernel
oops or invalid hardware access.

Fix this by checking the return value and propagating -ENOMEM on failure.

Signed-off-by: Zhaoyang Yu <2426767509@qq.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/dm1105/dm1105.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 57f7e4df41b22..f20bea8623af7 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -767,6 +767,8 @@ static void dm1105_ir_exit(struct dm1105_dev *dm1105)
 
 static int dm1105_hw_init(struct dm1105_dev *dev)
 {
+	int ret;
+
 	dm1105_disable_irqs(dev);
 
 	dm_writeb(DM1105_HOST_CTR, 0);
@@ -777,7 +779,10 @@ static int dm1105_hw_init(struct dm1105_dev *dev)
 	dm_writew(DM1105_TSCTR, 0xc10a);
 
 	/* map DMA and set address */
-	dm1105_dma_map(dev);
+	ret = dm1105_dma_map(dev);
+	if (ret)
+		return -ENOMEM;
+
 	dm1105_set_dma_addr(dev);
 	/* big buffer */
 	dm_writel(DM1105_RLEN, 5 * DM1105_DMA_BYTES);
-- 
2.53.0



