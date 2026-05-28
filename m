Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252611AA1D2;
	Thu, 28 May 2026 20:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998483; cv=none; b=EeATY47wYrkcZvZRTqUFBrleFY/h51eCSbClB7Q+LqRzNTtG7jaCbe1UzGhYcxgb3iCHyATD/y4q+eG59s1AdodDX9MZo+ye+tqyJTF0RYuvXqgKm+nwI/h7byUirAXzTrh0vFYasPYheFdL3zuLSyrxdpkR/cjbqu5WgF+dvMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998483; c=relaxed/simple;
	bh=OKsbjFeUeacH7ZKH8iRwhTNfEGaeVjBEZhOXo9aPYNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoOlB2WAsTbq+MdF4y6nHGxt/JtqKIIIop8tkA4f42X8RcH7Y0ebbh3gUEgwro5jNp+Kv5zOKJ71CtaqCUnUoSPyEpvgq1Y7jri4nZO2jG1DpdfnmyoJUd321rcbz+s1ZOkB7I+nEEMC9kdc7J3ogid9rmPQFMGX2rI0HuZHyNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogwcphOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogwcphOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B021F000E9;
	Thu, 28 May 2026 20:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998482;
	bh=cQ4Ka2ruw+QYn5IJ9AfmNZTv2alxCQob4VvMMjHT/Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogwcphOUk0Ce/LjTqvOKjRbBNjVFF8ontVPGEsM/XcFfQhSNf8h/EXE8u29TLR9Tp
	 wGV9QsugU4nXRfxQShuCRzLNzTv4UCsWuWGQ2xu5shHw6TTMUISbMbaSrOyx6K7tDB
	 LCED+M/AQR/BfPAQ+aPzY9zV16YDZdfLdhfXBOy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 188/461] firmware: arm_ffa: Skip free_pages on RX buffer alloc failure
Date: Thu, 28 May 2026 21:45:17 +0200
Message-ID: <20260528194652.518407555@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 09527e2c534911619d7e098729711100290bc3e1 ]

If the RX buffer allocation fails in ffa_init(), the error path jumps to
free_pages even though no buffer has been allocated yet. Route that case
directly to free_drv_info so the cleanup path is only used after at
least one RX/TX buffer allocation has succeeded.

Fixes: 3bbfe9871005 ("firmware: arm_ffa: Add initial Arm FFA driver support")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-2-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index eb27828482837..e6a051b20cb72 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2067,7 +2067,7 @@ static int __init ffa_init(void)
 	drv_info->rx_buffer = alloc_pages_exact(rxtx_bufsz, GFP_KERNEL);
 	if (!drv_info->rx_buffer) {
 		ret = -ENOMEM;
-		goto free_pages;
+		goto free_drv_info;
 	}
 
 	drv_info->tx_buffer = alloc_pages_exact(rxtx_bufsz, GFP_KERNEL);
-- 
2.53.0



