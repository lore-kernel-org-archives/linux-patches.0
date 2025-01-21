Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABAF1F3FFD;
	Tue, 21 Jan 2025 17:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482028; cv=none; b=Nkf/0TeR03PPTOBwY4VnnBYT6VA3f5jDaVXUuRhLbrpR5aZzP15D0GK23Ixe5u5CGSeGailG11U9MXgPwkAtFkrOiYXEuN760bBhYeUmx8B958y1eEfNIPh2+JrTXw6UiOMIBOHpOyBFRBqsxE+wh2OMF3SUAIrCahckKBvC4Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482028; c=relaxed/simple;
	bh=nghB27j/AEmiS+uR//a4U6bxXmuvPXm2u4iJ0+u1oXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXFlulAGPai6aBb3KIpHmkY/Z8U2WTFXewRFzy+8Ps1Vk33fjqpq8SeB/ir90l4C9sl2Z0TgumK5vPQ4qEfNHTsxm2gqF9Q+SLtVez5/xRjUCeRtyH5dZKt80nXJUKphxvQDq/rm6c/4Mpl31ZS4adSGT+TXUpPxQeJuCxFERhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Omt6hxkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Omt6hxkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A95CC4CEDF;
	Tue, 21 Jan 2025 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482028;
	bh=nghB27j/AEmiS+uR//a4U6bxXmuvPXm2u4iJ0+u1oXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Omt6hxkjKEXueh27GUNZSMwsNnaIOLALquftcvxylaE9/vNuD3QXlns0SrPMpmKq3
	 boI6+VqQyGQbLWfsPWAj+oVKqmdveyUVjZBT20cigIK2QaQ8uWsC12hriT10ACsIzF
	 rjTCBVtopO61wqMERlB3lg2Tw20fPI7HuN42uCvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/72] net: xilinx: axienet: Fix IRQ coalescing packet count overflow
Date: Tue, 21 Jan 2025 18:51:36 +0100
Message-ID: <20250121174523.826548067@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit c17ff476f53afb30f90bb3c2af77de069c81a622 ]

If coalesce_count is greater than 255 it will not fit in the register and
will overflow. This can be reproduced by running

    # ethtool -C ethX rx-frames 256

which will result in a timeout of 0us instead. Fix this by checking for
invalid values and reporting an error.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20250113163001.2335235-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9f779653ed622..02e11827440b5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1571,6 +1571,12 @@ axienet_ethtools_set_coalesce(struct net_device *ndev,
 		return -EFAULT;
 	}
 
+	if (ecoalesce->rx_max_coalesced_frames > 255 ||
+	    ecoalesce->tx_max_coalesced_frames > 255) {
+		NL_SET_ERR_MSG(extack, "frames must be less than 256");
+		return -EINVAL;
+	}
+
 	if (ecoalesce->rx_max_coalesced_frames)
 		lp->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
 	if (ecoalesce->rx_coalesce_usecs)
-- 
2.39.5



