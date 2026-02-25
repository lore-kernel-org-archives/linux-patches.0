Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9292D6E58;
	Wed, 25 Feb 2026 06:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002667; cv=none; b=FzfZs+NLlc4aSRVSSeWg7gYiGBjyxiBLknOQRcpsG8T+KGmOWKPzmnRArwS8L46NwY3veXsK1lQNj/3YvBmhMmJJxKvx7vVj+N8VpMovMzBDMQQUpRiR9RUeM5j1gwW8Clod+PlnSsWePsGTxiO8O4kXGFb0/4HAzYEVhwoKXx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002667; c=relaxed/simple;
	bh=GdnYzrRD2U5zdS+aE4bQ8fsnu9ctjkpLcRO3gm/m5MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciJo1HIuSfYocLc3BzdK3GoH0K9GVjluWcJDAssEBWyfxBGYH8KS73OfQe7x/TApGUNUR5jDmRbTA0ynnJQPItoTaMnv/BYU7Z1bP/BCJzyArOlNqYzPMsKWNxyoSEtUQpk32Hlxk+3RXbGP6qXAz1DPpYyq94+Gbg9YfNnaNcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOWf7yIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOWf7yIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D39C116D0;
	Wed, 25 Feb 2026 06:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002666;
	bh=GdnYzrRD2U5zdS+aE4bQ8fsnu9ctjkpLcRO3gm/m5MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOWf7yIzl40s9a3S3z2IittGsyf06SCaDO6jkJZsvbrd+TImMDVQoxipnnO6SKCdK
	 +siyipd8JhN2fWzwfCYs7gueF1i1e09dAi3yxWgCr6OngBNCR5Dx9IXweJOLsvf9tO
	 Sgq6qYOr/imAYlSNRz/ZVlRoIMHMN8HI4sHD4l0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 421/641] clk: rockchip: Fix error pointer check after rockchip_clk_register_gate_link()
Date: Tue, 24 Feb 2026 17:22:27 -0800
Message-ID: <20260225012358.753574503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit a8d722f03923b1c6166d39482c6df8f017e185d9 ]

Replace NULL check with IS_ERR_OR_NULL() check after calling
rockchip_clk_register_gate_link() since this function
returns error pointers (ERR_PTR).

Fixes: c62fa612cfa6 ("clk: rockchip: implement linked gate clock support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://patch.msgid.link/20250805030358.3665878-1-linmq006@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index 19caf26c991bd..2d30b1e24f013 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -693,7 +693,7 @@ void rockchip_clk_register_late_branches(struct device *dev,
 			break;
 		}
 
-		if (!pdev)
+		if (IS_ERR_OR_NULL(pdev))
 			dev_err(dev, "failed to register device for clock %s\n", list->name);
 	}
 }
-- 
2.51.0



