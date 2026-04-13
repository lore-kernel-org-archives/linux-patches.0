Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD2326B971;
	Mon, 13 Apr 2026 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098194; cv=none; b=tB7anu4agRYw/jsecuh3xr6Zi17J73fp8mHYNOg9+a8Wi1/RHjHtnEsKlVA3unLIP5cWRrLAufG6CcAd1mUXyOx5GxYFEV49eS27o1fOpm9lgp1jq2ZXOe7cmT/rWbW557g1l6L1jjJcRJjfetOIXJsb8kQi/4tZXSQAbJZI1d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098194; c=relaxed/simple;
	bh=AJRPaMrfr9Goy/4oW+uMfjRx+uNZPBxsJqjWsTaLxCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzPsykezJtwS4JMdzsNDG/o0lIcg2QjkB3fkuFCM9dkIKXTM7unFa1bPjXWpsA6TtGZsavvV//rM67PqZYsLB4Gn8dPkw1NbN9bgp4ANMCcOgokRRexvvBRE6KaV+i+D10eaeQVBjYfMn0rtfDBvEsLV07R/qEIY1S+rHo2NoDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCDoSFKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCDoSFKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6298FC2BCAF;
	Mon, 13 Apr 2026 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098194;
	bh=AJRPaMrfr9Goy/4oW+uMfjRx+uNZPBxsJqjWsTaLxCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCDoSFKFUN32b8uJYY/TocLPHr8DQbhcl0nsPY3+8D8gwNBzuVrGp3Yua7jx7VdqK
	 ThrOjFK80cu/oWMCPU3Rq2BhGEbATEy5BDx0LClElHcnFojFpGTDixH4iSrO0F0uom
	 g2SxI/bZc1STdBDw8q34k/l4MYTxe6N1SRNXll/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/570] net: macb: properly unregister fixed rate clocks
Date: Mon, 13 Apr 2026 17:59:21 +0200
Message-ID: <20260413155846.579422339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit f0f367a4f459cc8118aadc43c6bba53c60d93f8d ]

The additional resources allocated with clk_register_fixed_rate() need
to be released with clk_unregister_fixed_rate(), otherwise they are lost.

Fixes: 83a77e9ec415 ("net: macb: Added PCI wrapper for Platform Driver.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20260330184542.626619-2-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 4dd0cec2e5423..34e249e0e5860 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -97,10 +97,10 @@ static int macb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_plat_dev_register:
-	clk_unregister(plat_data.hclk);
+	clk_unregister_fixed_rate(plat_data.hclk);
 
 err_hclk_register:
-	clk_unregister(plat_data.pclk);
+	clk_unregister_fixed_rate(plat_data.pclk);
 
 err_pclk_register:
 	return err;
@@ -114,8 +114,8 @@ static void macb_remove(struct pci_dev *pdev)
 	struct clk *hclk = plat_data->hclk;
 
 	platform_device_unregister(plat_dev);
-	clk_unregister(pclk);
-	clk_unregister(hclk);
+	clk_unregister_fixed_rate(pclk);
+	clk_unregister_fixed_rate(hclk);
 }
 
 static const struct pci_device_id dev_id_table[] = {
-- 
2.53.0



