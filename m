Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6A538654F;
	Sat, 17 Oct 2026 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254124; cv=none; b=dIU2I1B+iKvq+1kodqEfw9/WSg9a2i4rs0YtiiyAPAFDUF7kXLpPpwihWYHDM3JvvBVXNZxYzil5D0tHB2sUXqLbnVVjCPHgFmxGItKxnu7dr7tjxcLcXe8nAJcSbC8L95M/WMpXEumLiBtVJOllC1r8v7GkhSedhiNUCFnEWgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254124; c=relaxed/simple;
	bh=RAO+qnA0K32LWmXguWd49CR7Xhpi/T9iWopG9POqIfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYyd+TGkmU7fl3XeIcKXbLYw36gqRH+H/dHmCeei/pPWpy5nxJRA3HJ3Wrbc6qHeIiBd9+TdSJ98MC+N8oIdOjCXfqcRNwWOEMWSJHHptK/XBSh5IU7HB9ighCcBnlFZ6FPIUK52u+ucz63TKYsXErNFWWRKUKCvllLl1yh7lig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIAn3Vmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIAn3Vmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2F51F000C4;
	Sat, 17 Oct 2026 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254122;
	bh=nLuOCLK5ueik4fzKQTIpZmd5B7jN2Z9BoDa8eT60FSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIAn3VmpNFSml+N9/CeDTIx56aNiIIffdLSh8rFSFAjf0ivz0w/Q7u9QbSULuOx6g
	 u8S66aNM8IMYXcXZqhEGQjFOwflYULS0TV+ogTB0KS+hq9AzsYeneIB9/ceakYulPa
	 zcsW1A5zNg73t7TiOjINveegDAYe3G5z0D/wjgzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/869] net: airoha: Do not read uninitialized fragment address in airoha_dev_xmit()
Date: Sat, 17 Oct 2026 17:53:05 +0200
Message-ID: <20261017160045.915447844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bde34e84edc8b5571fbde7e941e175a4293ee1eb ]

The transmit loop in airoha_dev_xmit() reads fragment address and length
during its final iteration, when the loop index equals
skb_shinfo(skb)->nr_frags, at which point the fragment data is
uninitialized. While these values are never consumed, the read itself is
unsafe and may trigger a page fault. Fix this by avoiding the fragment
read on the last iteration.
Additionally, move the skb pointer from the first to the last used packet
descriptor, so that airoha_qdma_tx_napi_poll() defers freeing the skb
until the final descriptor is processed.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260424-airoha-xmit-fix-read-frag-v1-1-fdc0a83c79e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 41695f353cdc6..1488eb17514eb 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2592,10 +2592,13 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 		WRITE_ONCE(desc->msg1, cpu_to_le32(msg1));
 		WRITE_ONCE(desc->msg2, cpu_to_le32(0xffff));
 
-		e->skb = i ? NULL : skb;
+		e->skb = i == nr_frags - 1 ? skb : NULL;
 		e->dma_addr = addr;
 		e->dma_len = len;
 
+		if (i == nr_frags - 1)
+			continue;
+
 		data = skb_frag_address(frag);
 		len = skb_frag_size(frag);
 	}
-- 
2.53.0



