Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D089E46A612;
	Tue, 21 Jul 2026 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648829; cv=none; b=IQhp41pNB5rC0X2h0TU8QEVAMG06VbJCifMVjYXzHFJsnM9SAQkMLKWeNAcb2CGmz7wHoJw+gxmeEakefGY1qNA79J9KaeqgnJc2Lt6cPOGqiTsvnGHYWDKHY03rsMWiM27xTNKtRwx2y2RZyER40O3WMkT6PzJ4Tn8W4OW+2L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648829; c=relaxed/simple;
	bh=2A2vwXUm2qZYi/rLaN+TOfOqLvhnha8jVXg1UL1H23I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elLdCeL3IQkEhHF+nMVutvq5nErJV0up/qRVouHrrVQb7c7uYaEujmiCBOQqmMVGPs+ICR5tEI9S9K2QU9DVWwmSESCOfbjcee8v2KqlhZXqUu+km3p17eBz5kdzlx2RipPW8ZSz1EG/ybFbAQpt0oqKR2RIICsrW1Ijdh3cFIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=truQwIeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="truQwIeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428B01F000E9;
	Tue, 21 Jul 2026 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648828;
	bh=slE2uMvz6UjKuWYQ/6e9uMKHlGvsxcavpeifPoRvZLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=truQwIeKrDKhirMML74EgoIaT8/MaiRFkhJWq9/an7DwIAyOX2OdG6i8SC2vKasaG
	 YgA2Lo23OOC1CxkWR3rBMGGqQPz8is4gLoKY/dowYUp/tYyChwqA89EgONYIoZls7e
	 ZP06o/lNeBqlIbtjDjrFiaza0XY4yHBvfrIZCgqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0346/2077] gpu: host1x: mipi: Fix device_node reference leak in tegra_mipi_request()
Date: Tue, 21 Jul 2026 17:00:19 +0200
Message-ID: <20260721152600.851387358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit b217fb77ca4fd0cc267329500b291c0ad8f8b211 ]

In tegra_mipi_request(), when provider.np is not equal with args.np, it
returns without calling of_node_put(args.np), causing a reference leak.

Convert to use the existing goto out pattern to ensure proper cleanup.

Fixes: 767598d447aa ("gpu: host1x: mipi: Update tegra_mipi_request() to be node based")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260416-mipi-v1-1-9c027175abdf@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/mipi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/mipi.c b/drivers/gpu/host1x/mipi.c
index 01513b775d8996..98868142398172 100644
--- a/drivers/gpu/host1x/mipi.c
+++ b/drivers/gpu/host1x/mipi.c
@@ -114,8 +114,10 @@ struct tegra_mipi_device *tegra_mipi_request(struct device *device,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (provider.np != args.np)
-		return ERR_PTR(-ENODEV);
+	if (provider.np != args.np) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	mipidev = kzalloc_obj(*mipidev);
 	if (!mipidev) {
-- 
2.53.0



