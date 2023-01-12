Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EF279C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF172C433D2;
	Thu, 12 Jan 2023 14:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534199;
	bh=0sp56hS7ofKkdLkMFHJu5JCMG3StKp5SSSzJyM8vgTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=br8kxRkVs80Q6+csQNOqv14LjjXoB/RH0SSMr9A/Vx7V2GnwtSvhT3tp8rk4geSud
	 9m7/aNm7KcCVX5gDMn/mWB7Bn7yP6NDY35nRKlvCZtegs+QQ10G6zrsSG68i0YP7NY
	 G8Vy5LlWNJ21xilDXjiarJgSmKAmKlGfD5fAEv4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronak Doshi <doshir@vmware.com>,
	Peng Li <lpeng@vmware.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 727/783] vmxnet3: correctly report csum_level for encapsulated packet
Date: Thu, 12 Jan 2023 14:57:23 +0100
Message-Id: <20230112135558.047283363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ronak Doshi <doshir@vmware.com>

[ Upstream commit 3d8f2c4269d08f8793e946279dbdf5e972cc4911 ]

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the
pathc did not report correctly the csum_level for encapsulated packet.

This patch fixes this issue by reporting correct csum level for the
encapsulated packet.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Peng Li <lpeng@vmware.com>
Link: https://lore.kernel.org/r/20221220202556.24421-1-doshir@vmware.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 43a4bcdd92c1..3b889fed9882 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1236,6 +1236,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		    (le32_to_cpu(gdesc->dword[3]) &
 		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
@@ -1245,6 +1249,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		} else if (gdesc->rcd.v6 && (le32_to_cpu(gdesc->dword[3]) &
 					     (1 << VMXNET3_RCD_TUC_SHIFT))) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
-- 
2.35.1



