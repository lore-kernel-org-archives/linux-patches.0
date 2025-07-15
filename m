Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554402E7BB2;
	Tue, 15 Jul 2025 13:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587140; cv=none; b=qVr1ZgSV4Soa0ZqqBAm6BrBmGCwWe6G/DGYhuRLC8sZUm5M1wsTFSqlva80b7EUgI3NSG4EWo+LZ0LTRQZibSyDbml9YItHWmxtXKSkNhJcCaNK/s02IG+YJoHtx1Si0TNSbGGPPQTjGpk4JdvKvIUnlSHKBYgD4jATIiDmo/f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587140; c=relaxed/simple;
	bh=g/HG8CeffXOaGh7YrlXDLD1JyFJbG97E1ycy8FuRk4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/6n8ocXeYSywKPzVEsR5c7Fedh1Fdk+l013ZmgQMdNQp1hB4k3UC09JsS3zESIxExODGScEC6tp4fhtG/Siu6FyEPPXml9va74uSBM+8BJrGaSBITMO+P1LXimiUYHsXeuHGQVkmjiX90iai6OWYheYvWuPAgd7LVJDuqRkst0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hB2o7+iI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hB2o7+iI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7302BC4CEE3;
	Tue, 15 Jul 2025 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587139;
	bh=g/HG8CeffXOaGh7YrlXDLD1JyFJbG97E1ycy8FuRk4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hB2o7+iI6OWMJbOHR6OjwE9+Y6HaQyNFvpvTcqUqFKRkkRJEgrorkjraHrN55cwaW
	 qvSwmVYI+qSdODbtvNgp/NIFbePrfEAHJXDKv629CA8nsRvJXal8xXsiYoMffz2fx6
	 URmV6+f/D5BPhv9MMlMqPBweJWiDObCj4YXv5rGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 181/192] net: mana: Record doorbell physical address in PF mode
Date: Tue, 15 Jul 2025 15:14:36 +0200
Message-ID: <20250715130822.181084033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit e0fca6f2cebff539e9317a15a37dcf432e3b851a ]

MANA supports RDMA in PF mode. The driver should record the doorbell
physical address when in PF mode.

The doorbell physical address is used by the RDMA driver to map
doorbell pages of the device to user-mode applications through RDMA
verbs interface. In the past, they have been mapped to user-mode while
the device is in VF mode. With the support for PF mode implemented,
also expose those pages in PF mode.

Support for PF mode is implemented in
290e5d3c49f6 ("net: mana: Add support for Multi Vports on Bare metal")

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1750210606-12167-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 4ffaf75888852..3dc94349820d2 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -31,6 +31,9 @@ static void mana_gd_init_pf_regs(struct pci_dev *pdev)
 	gc->db_page_base = gc->bar0_va +
 				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
 
+	gc->phys_db_page_base = gc->bar0_pa +
+				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
+
 	sriov_base_off = mana_gd_r64(gc, GDMA_SRIOV_REG_CFG_BASE_OFF);
 
 	sriov_base_va = gc->bar0_va + sriov_base_off;
-- 
2.39.5



