Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4871F755D;
	Tue, 21 Jan 2025 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483014; cv=none; b=oO3KH/OAUvlpWmD+KSmeiTF/A13UF+EQ9x+mgVY2m8uXdt992wp4/og3+c00fY//BPXjpWDkvCAlikMz5nCL2Gyelp1iQfPXgnfDIitancXiQxfZhzXMZ15NOcGi0oiK2DnGSMPkaXtdS7MkbV84g6oSlDZPnNgXYCcYea/13xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483014; c=relaxed/simple;
	bh=4A6Oy770ZL4OvFZIl4q/dlOI6eh9dsjpkRl0sqDASJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flsSb2h/OVLDTAKf4Ng5lpwoF5EAED3+GJ+m4vLGRiUnrPZPKrrhJYD/wHZNKDJxcM90ZJ68wIIYtwXf2abnR6QsL+xS2bBXXj3mWQrymMkIlhZdlaTj7a1Cff2wF8gIiXax1IMbVSawuZM0NVP+2A9R8rC7iC76dZ4MyAvyvOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEtqCPGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEtqCPGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7C6C4CEE1;
	Tue, 21 Jan 2025 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483014;
	bh=4A6Oy770ZL4OvFZIl4q/dlOI6eh9dsjpkRl0sqDASJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEtqCPGjE6fBVbiGwVNekEiu/iDQR3wlFed6K56yEieRpEFUMUr9m6SuWThRpUvyf
	 ijPETXJYndGJclclU89KzWMr2Tt3M+hnhP1EVjWaz4A9cO9RPPA+Zm0BTonnG9QIuW
	 9gpWOh2G3XzcTPTUXOHDFsnNU/xpwfaKjZqv0KGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/127] net: xilinx: axienet: Fix IRQ coalescing packet count overflow
Date: Tue, 21 Jan 2025 18:52:39 +0100
Message-ID: <20250121174533.007492050@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 56a970357f450..f63d2224ba91a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1584,6 +1584,12 @@ axienet_ethtools_set_coalesce(struct net_device *ndev,
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



