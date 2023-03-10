Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9A6848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A7CC433EF;
	Fri, 10 Mar 2023 14:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458495;
	bh=vQx0DcgNVq3yP6igtFOF3HSDy8VXdxYpLfBEVjf80QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esdfpgfX7ZZykgkeKyrMdugM1rQwQ6DEary0q9X70ikrNuIocQSpWg6M4Bk6OzI82
	 WiXRIzQe5LC7i4jKwQTyI4W3JPpfkO+qUJqGubVAK8jv3tojaHzI2SpDMWkfG8kpZ2
	 p8N99NtTaVUOEVT5VijNI3fcPIqs8KGihmnNbPi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/357] wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
Date: Fri, 10 Mar 2023 14:35:34 +0100
Message-Id: <20230310133735.970360229@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit b9f420032f2ba1e634b22ca7b433e5c40ea663af ]

After the DMA buffer is mapped to a physical address, address is stored
in pktids in brcmf_msgbuf_alloc_pktid(). Then, pktids is parsed in
brcmf_msgbuf_get_pktid()/brcmf_msgbuf_release_array() to obtain physaddr
and later unmap the DMA buffer. But when count is always equal to
pktids->array_size, physaddr isn't stored in pktids and the DMA buffer
will not be unmapped anyway.

Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207013114.1748936-1-shaozhengchao@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index c2705d7a4247e..fd54acb859246 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -345,8 +345,11 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
 		count++;
 	} while (count < pktids->array_size);
 
-	if (count == pktids->array_size)
+	if (count == pktids->array_size) {
+		dma_unmap_single(dev, *physaddr, skb->len - data_offset,
+				 pktids->direction);
 		return -ENOMEM;
+	}
 
 	array[*idx].data_offset = data_offset;
 	array[*idx].physaddr = *physaddr;
-- 
2.39.2



