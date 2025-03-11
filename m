Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6750C1925AF;
	Tue, 11 Mar 2025 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706582; cv=none; b=drt0xSABN4pSmRUAhbDBavl/8VH4zv/YoUHokUDFW3eVHhUOVBqcFUHSanROgnFOHJiVKOu0I+Z74WctC0ypaITCBimPVEurwQDnp5QuXSbGFd3E2+i4PTnnZ5prq1eebXMEq+YyhAK5NLpFfmb1yRr6C3VJTIX/wk5XkISOwrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706582; c=relaxed/simple;
	bh=e4RRsmXWLjy3bRKAA4SH6vvqrgIxl0LFMiYmZDD4YiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z60jQ5MvQKGq8smtoggvyuyP4Of3x/70fkf9wkyqWG7HMRffncV1eL7/ofiKrkM8hFuxbFXqPC0JFV5cNBBq+3q6WM1bVc3xgxdNWerUuAK0b44G4Qm7DsBIRBNKrdJNBE42hdyE/IllZZ7L5+fgHDDDZABCcjSj1vt3njTy/W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGEZOPr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGEZOPr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA078C4CEE9;
	Tue, 11 Mar 2025 15:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706582;
	bh=e4RRsmXWLjy3bRKAA4SH6vvqrgIxl0LFMiYmZDD4YiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGEZOPr3/d1oZgZxaTfYKz3Noy8OVn4t45yD3G5VzzJA11gV1q/nllxYJcs9q+vZ4
	 DIj+iDRqxNliDRwv6Hn2L4y3jqAWxNd9ORscwjJvCLKG7F2KgpVGTj7OyWHn6o32+b
	 iZf7FldTMiJR/lT8mj4povvEtSyZ+zgqnFHMrwLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/462] dmaengine: ti: edma: fix OF node reference leaks in edma_driver
Date: Tue, 11 Mar 2025 15:56:03 +0100
Message-ID: <20250311145802.191400875@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit e883c64778e5a9905fce955681f8ee38c7197e0f ]

The .probe() of edma_driver calls of_parse_phandle_with_fixed_args() but
does not release the obtained OF nodes. Thus add a of_node_put() call.

This bug was found by an experimental verification tool that I am
developing.

Fixes: 1be5336bc7ba ("dmaengine: edma: New device tree binding")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241219020507.1983124-3-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 69292d4a0c441..560fe658b8942 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -217,7 +217,6 @@ struct edma_desc {
 struct edma_cc;
 
 struct edma_tc {
-	struct device_node		*node;
 	u16				id;
 };
 
@@ -2524,13 +2523,13 @@ static int edma_probe(struct platform_device *pdev)
 			if (ret || i == ecc->num_tc)
 				break;
 
-			ecc->tc_list[i].node = tc_args.np;
 			ecc->tc_list[i].id = i;
 			queue_priority_mapping[i][1] = tc_args.args[0];
 			if (queue_priority_mapping[i][1] > lowest_priority) {
 				lowest_priority = queue_priority_mapping[i][1];
 				info->default_queue = i;
 			}
+			of_node_put(tc_args.np);
 		}
 
 		/* See if we have optional dma-channel-mask array */
-- 
2.39.5



