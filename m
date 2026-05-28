Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54F93630A7;
	Thu, 28 May 2026 20:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999854; cv=none; b=XFUvQcoNobO54zCHxQZg7kH72iwCyZ3Fe9/KeeZi+AhM0eMOkd48MYvnhUefpBq/KBW0xaF654+Fqcnjz3TlcqKy15Mrz6dz0vIXmCEeQTCPXPzNAbaAjrAvJipgBVmilFvZoZbHNFCsvk2EUdDfya9CI2HlWTj6RniG3gB80JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999854; c=relaxed/simple;
	bh=xnYLR5k4VqqJWa1+RAvcTKgd/PYIiV3C+lsFiupR4gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RW9k/Aoq1HYSXj8orWrmJMPJMVkf/RRviV9JvA+Yo1cFP6bq/hKdw2pO8qBHuatBby5uOVps2N/ikFEXb0OjVydboRDFPGrGJuvPwhZjY3d6gg0SHRdsFj4L6S+UQKOgBpuN/MiSC6m8YGYXzs+oknOVLyc7lbkSszpzru/hY/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUEtZ4NS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUEtZ4NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6C91F000E9;
	Thu, 28 May 2026 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999852;
	bh=QpnNSRUWWdFnIFoOPrzdJVTXl4j0gAe7ahVmU0UBZQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUEtZ4NSPkD3mH31qdTltZV1qQ9mxkKUyntzoKj1A8qI0MeNd+cofBec9V9ZU4ovH
	 zLUBdu3fkW1Z+KSjDJGHr85Ji184leGXgvKwkgVC5b1IWLNuiZExQme7Bquyl6JFP6
	 VdSFnTSdN8gm6TTt9P1bAiCoDmPhbEEjYVFXg/IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/377] net: ti: icssm-prueth: fix eth_ports_node leak in probe
Date: Thu, 28 May 2026 21:47:32 +0200
Message-ID: <20260528194644.595202697@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>

[ Upstream commit 6635fa84403c3a59455b66007c019a7cc632db30 ]

The error path on of_property_read_u32() failure inside
icssm_prueth_probe() returns without putting eth_ports_node,
which was acquired before the for_each_child_of_node() loop.

Drop it before returning.

Fixes: 511f6c1ae093 ("net: ti: icssm-prueth: Adds ICSSM Ethernet driver")
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Link: https://patch.msgid.link/20260506195813.641610-1-shitalkumar.gandhi@cambiumnetworks.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssm/icssm_prueth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/icssm/icssm_prueth.c b/drivers/net/ethernet/ti/icssm/icssm_prueth.c
index 293b7af04263f..cc92f20685843 100644
--- a/drivers/net/ethernet/ti/icssm/icssm_prueth.c
+++ b/drivers/net/ethernet/ti/icssm/icssm_prueth.c
@@ -1347,6 +1347,7 @@ static int icssm_prueth_probe(struct platform_device *pdev)
 			dev_err(dev, "%pOF error reading port_id %d\n",
 				eth_node, ret);
 			of_node_put(eth_node);
+			of_node_put(eth_ports_node);
 			return ret;
 		}
 
-- 
2.53.0



