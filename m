Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CB93C9ED9;
	Tue, 21 Jul 2026 18:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659949; cv=none; b=AlZ/cT+FFdJk9hIqzSuH+WfbmQJhHDlKgtddAbLcP+2RdlMbRgmHbIgS4VBrFfBZnZvCkJzItRApX12tPR6AoohO1S+vQSaA8dbzWB0xWPVQxY3vqLjAE5hHRWyO3C51ksYyrvORqUJOLi/Zdp5ZKQe8lvOAZl8OtnHrh/RI88o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659949; c=relaxed/simple;
	bh=SGNpEjipRkxMb1UhCEgq1i9i+MvAgdB6vFypSp4GE/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM/Yy95PTc4Gs9uTPfbDnoUmStRRtIBpEGUlDV2TE2wTkiWFlo47mk1UOUjKox12Zoda4jlBY368YsI9N8hN75Egv4PuLYfR5SNTX99Edv5I9TDH65yugb9L0oXAzET28VkC3nfXBL0s3hTxk2o58SKM4m2qSh/L8FN6midsKk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubeYU2k/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubeYU2k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB481F000E9;
	Tue, 21 Jul 2026 18:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659948;
	bh=c9fYuPskXGtPQxvCC9gDPkd/+/NmqKwFaMLfRFgqY2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubeYU2k/W7KSdJmVuucrm/YsA+X5op/dx9NOsvt8qf5A1yOk7fVQkAyH8A0C/Ak33
	 c6xhoXIOR64xFVvqMKd9+D9aXMxSSciviTGvL7JsuXsgY4yzPs77IdFSxZ9n+gDy/W
	 rGIadQ16KHgPp4b0QjxceSW8vHg2yaak4gYKCqIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0795/2077] net: airoha: Fix always-true condition in PPE1 queue reservation loop
Date: Tue, 21 Jul 2026 17:07:48 +0200
Message-ID: <20260721152611.544892172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen.Yan <win847@gmail.com>

[ Upstream commit c66f8511a8109fa50767941b26d3623e316fde02 ]

In airoha_fe_pse_ports_init(), the inner condition for PPE1 queue
reservation is identical to the for-loop bound, making it always true
and the else branch dead code:

  for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE1]; q++) {
      if (q < pse_port_num_queues[FE_PSE_PORT_PPE1])  /* always true */
          set RSV_PAGES;
      else
          set 0;  /* unreachable */
  }

The intended behavior is to reserve pages only for the first half of
the queues, matching the PPE2 implementation on line 334 which
correctly uses the /2 divisor. Fix the PPE1 condition accordingly.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Wayen.Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/6a2ca3de.ad59c0a6.147df9.2ac1@mx.google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 329988a8400c13..7b8d0c5e262ab6 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -311,7 +311,7 @@ static void airoha_fe_pse_ports_init(struct airoha_eth *eth)
 					 PSE_QUEUE_RSV_PAGES);
 	/* PPE1 */
 	for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE1]; q++) {
-		if (q < pse_port_num_queues[FE_PSE_PORT_PPE1])
+		if (q < pse_port_num_queues[FE_PSE_PORT_PPE1] / 2)
 			airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_PPE1, q,
 						 PSE_QUEUE_RSV_PAGES);
 		else
-- 
2.53.0



