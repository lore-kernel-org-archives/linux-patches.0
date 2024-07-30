Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C181187FF2;
	Tue, 30 Jul 2024 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355432; cv=none; b=CdwxX0fKvF3bSXOB/UKD2jkiw/a8cIb7yjEX3rFYRpr8yL4v/hp3Qh/hmHW6Ch2IAttEFB/C5DPuhAasX3pRQ5ofDPUPL2B3JBd/P44B2UQr71MsdSnfOOi5ysLIXqyfHHBfWXeyp+jBMD+DtglqswMuEdV8hb0MZr22nc3GShk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355432; c=relaxed/simple;
	bh=Rchq3S7/6eow97VhCB7G1KaEUtqLT+pVNP5S6IbUBFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NySlrL7fpJdBGOl45324rUJC+f1Fl1qI8sQ7R9KD1Cr8zQTbCMI7vuzoWD1ZB2uIC/+ut28rTwpq6OPLkdkVw4dK9kU6qjVZ6wTwqHPnykeEFMId8bvyyMLYI2LGGy03nRVnt8pAT3gAI7GhXvQV0wGWXO0W0E1QgRK2STBEe1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYof5cno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYof5cno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5164C32782;
	Tue, 30 Jul 2024 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355432;
	bh=Rchq3S7/6eow97VhCB7G1KaEUtqLT+pVNP5S6IbUBFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYof5cnolOeYVUEdIJO4rw8ioA8bXWC848G7Cny/K3+ShuU+jI9dVTdy5z9N5QQSu
	 knEXfL716ZE4Rr3ttWGJtD7En11T+S29xKgKaKeJ1W5xEAdw8DCbMnl2TNF7t7lA4U
	 yIgpduhS41aFUwq06eebMK6DUn6jnE1/qo7OvTUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/440] arm64: dts: rockchip: Add missing power-domains for rk356x vop_mmu
Date: Tue, 30 Jul 2024 17:45:07 +0200
Message-ID: <20240730151618.653091824@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9d42c3ee3ce37cdad6f98c9e77bfbd0d791ac7da ]

The iommu@fe043e00 on RK356x SoC shares the VOP power domain, but the
power-domains property was not provided when the node has been added.

The consequence is that an attempt to reload the rockchipdrm module will
freeze the entire system.  That is because on probe time,
pm_runtime_get_suppliers() gets called for vop@fe040000, which blocks
when pm_runtime_get_sync() is being invoked for iommu@fe043e00.

Fix the issue by adding the missing property.

Fixes: 9d6c6d978f97 ("arm64: dts: rockchip: rk356x: Add VOP2 nodes")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240702-rk356x-fix-vop-mmu-v1-1-a66d1a0c45ea@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 99ad6fc51b584..e5c88f0007253 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -737,6 +737,7 @@ vop_mmu: iommu@fe043e00 {
 		clocks = <&cru ACLK_VOP>, <&cru HCLK_VOP>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3568_PD_VO>;
 		status = "disabled";
 	};
 
-- 
2.43.0



