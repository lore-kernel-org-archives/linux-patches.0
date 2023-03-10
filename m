Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9F5881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943EEC4339B;
	Fri, 10 Mar 2023 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459613;
	bh=pwznk9DKR30fbg46c7FPCaPKrTbXZEOcPEqs9gftHpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvdRS/qJAu4vJRrj4H1XrHGHL/Ygodfe4NQ9nglCRnAgM2XrizogYKa9iTzN+76U8
	 P+PHeby4A1GlXX3DQJCBG112ULn45XeNY8y1xh29XwwKFJfflN35SG9uTMDB7+yh7i
	 Kp+BJX07zLqNVkVaRsJpWVbK+cYweArKcgAi+xZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/529] wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
Date: Fri, 10 Mar 2023 14:33:26 +0100
Message-Id: <20230310133807.909949463@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 7c8e08ee8f0ff..bd3b234b78038 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -346,8 +346,11 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
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



