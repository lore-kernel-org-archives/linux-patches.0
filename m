Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF6A3D9054;
	Wed,  8 Apr 2026 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672564; cv=none; b=JvWfAlD13RN8zN1Z9PtNqC3R0mDt3kZXWqXmrZTGzX12tHXCq+pmnsojexOjEbBmDYHXzb/iR5N6OadkLqg59NLlWIP6LwXZzXIjxA4R7VGBkhwIVywzBYtdhLc6YJ0pij6+kwmd8yRxqxcl5txVaLQZbuqN+YWfSbmkGkTfbm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672564; c=relaxed/simple;
	bh=lKw/7rbUWOC7klhqfyxHJeoc7QZ2Hmd/Q2zFl+IcouM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQBwih8zlHyXodrozZNbBcdl+Rt9dghpiwPeq1K+HdYY1z03PpPxVxsDV86wCZUX4YUjp9Oed4mkMmtEgFoJUBfptBAsL2n6YO4RrODVwsdUSvK03PvVye60oWwTXUr+h99GxRhquH8h7jB9baSizzJB+TC+I5d7PdomiRw6ahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTrFe5nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTrFe5nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82358C19421;
	Wed,  8 Apr 2026 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672563;
	bh=lKw/7rbUWOC7klhqfyxHJeoc7QZ2Hmd/Q2zFl+IcouM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTrFe5nrarRSw5jIYQOcu4jlKqlYb/UAd0WUw1/eTqgOpAnctQQqGee804oI+gluD
	 AnR59zN9DhtK20tl2du7/DqEUlgHiVRRQeePejE1Un8KmEfzYtkxWDxUYvLY1q8kam
	 QQ6mtAUUhUpZRg+VRx3gYZKpllKTIN39YjZHkd0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/160] net: macb: properly unregister fixed rate clocks
Date: Wed,  8 Apr 2026 20:02:22 +0200
Message-ID: <20260408175915.259961724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



