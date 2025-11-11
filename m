Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F1626E706;
	Tue, 11 Nov 2025 01:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824769; cv=none; b=hFJUBabtRAnyNRLDVndO/klUlaC9QLDkJSbJbSfFOx7k+SRfc0oK9rt/bYgHzjvvPwU02RhVEPWGgFbrp2DCzZKiA3oJFnlgbIdW9XdwnVp/c+UDOwXtTNZcySVYX0WNPq/vmi5b4G5+SJcdL2uyUoTn5uI8JREP6WQ781eJ55w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824769; c=relaxed/simple;
	bh=nRZg1SshgMxz1Wd1l7Mf12w9kisyO3lY5bEOhdELoZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBHODAzvMN5w7OPBuSFAeCh8Fj1J4+U66y5JfD3jM2Sc+bL6zP7r6RGr347KPy9vNvJRu1GlXyY9ogmuQbR7PpRUASSQnen453AUm0tvhnF6wx+0kKCC93OyIPTS4h8GUFT3HJnEIrXXN5EqHJMD8IlTLMns1cfms809DEUKd/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lexDUNJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lexDUNJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B6FC4CEFB;
	Tue, 11 Nov 2025 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824769;
	bh=nRZg1SshgMxz1Wd1l7Mf12w9kisyO3lY5bEOhdELoZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lexDUNJDPVr/DPYRzM9dOY0nweI7eU0mLa5YzjlVp/ByCsMfPfxGSz5doifE0dOBm
	 FCbdSsLuU6Ffnot0uNWljGikDU4Xui540XJ2JVS29rSrWvrHXXUBNd6FDnGQkRY8LS
	 xQwp2BJUPYsLjPTjWAqG2FmK6Pg0xxSCwsIdqkbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yikai <zhuyikai1@h-partners.com>,
	Fan Gong <gongfan1@huawei.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 566/849] hinic3: Fix missing napi->dev in netif_queue_set_napi
Date: Tue, 11 Nov 2025 09:42:16 +0900
Message-ID: <20251111004550.097708349@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Gong <gongfan1@huawei.com>

[ Upstream commit 4404f6af810829588a51968959c6b85574109c13 ]

As netif_queue_set_napi checks napi->dev, if it doesn't have it and
it will warn_on and return. So we should use netif_napi_add before
netif_queue_set_napi because netif_napi_add has "napi->dev = dev".

Co-developed-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Fan Gong <gongfan1@huawei.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/a17a5a087350eaf2e081dcd879779ca2c69b0908.1757653621.git.zhuyikai1@h-partners.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic3/hinic3_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c b/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
index 8b92eed25edfe..aba1a1d579c50 100644
--- a/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
+++ b/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
@@ -42,11 +42,11 @@ void qp_add_napi(struct hinic3_irq_cfg *irq_cfg)
 {
 	struct hinic3_nic_dev *nic_dev = netdev_priv(irq_cfg->netdev);
 
+	netif_napi_add(nic_dev->netdev, &irq_cfg->napi, hinic3_poll);
 	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
 			     NETDEV_QUEUE_TYPE_RX, &irq_cfg->napi);
 	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
 			     NETDEV_QUEUE_TYPE_TX, &irq_cfg->napi);
-	netif_napi_add(nic_dev->netdev, &irq_cfg->napi, hinic3_poll);
 	napi_enable(&irq_cfg->napi);
 }
 
-- 
2.51.0



