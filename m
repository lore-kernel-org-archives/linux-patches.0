Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9681F55F5;
	Tue, 21 Jan 2025 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482280; cv=none; b=EJwcYwF12atyUnRmQ2AjjK/FTsu3F73WSrnqiaCADVJtJdzQ5IrkWeHV4hyYs3pCbIHMViSKxAT4eQ0WALiEVuZpsCNiInmsjvfTbaX6bNCwQ7PxdJw4NL1/+gMlLkq6UtD8czZvRejDFme1k/QUkgjbBqRDPGLjqAbTfPK0VjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482280; c=relaxed/simple;
	bh=LuqyqDfENN7BeK7U3/92AXnvvb23ian64V1/HqiD/Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQHW7mYpf4vdfaG3naS2OLom8rwCh8rnMHevkEVcZoweuKLO4oQ+nINdzPh0ovQgwNnOyviJAPN0hWXxMrMk87B2eKWefkfIsTY+j8EmnZf6TYJhEb7r08EgRNTQ0b1xU2IlQpG1DSBOSP93FBkf9CNiKpiB14z0v/pB1UG83DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KG1rRHJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG1rRHJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD67C4CEDF;
	Tue, 21 Jan 2025 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482280;
	bh=LuqyqDfENN7BeK7U3/92AXnvvb23ian64V1/HqiD/Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KG1rRHJwXK8A8gV43T2RVaBsi7xGlLhdGto2s4mPRdTlReT6Zf9sbjtMnePfC00YP
	 Uprwf1jVvugG0t8ieFFL/JDE0DdaCt4fiL+ckO3xOvrkDi78Ty+r5ruerqUHIE5Bar
	 GcR9/hkV7vrlMj054ZXcPsotV9vwBrsazkaFdfXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/122] net: xilinx: axienet: Fix IRQ coalescing packet count overflow
Date: Tue, 21 Jan 2025 18:51:10 +0100
Message-ID: <20250121174533.852144002@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1fcbcaa85ebdb..de10a2d08c428 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2056,6 +2056,12 @@ axienet_ethtools_set_coalesce(struct net_device *ndev,
 		return -EBUSY;
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



