Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D5C2E92B4;
	Wed, 10 Dec 2025 07:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352039; cv=none; b=diaVpwhsJuFPoIkxDDJvMGAv0kCg6Zk3jvBcjlBTkOnbCa0bjG4HhzzDgn/ONAh4UdYa9f1nYeiCyMw4fWACAxcGyjlmSk6h7G1L+bFQS5q60c8gEy6coOW/Usmigsl6gSoIcdkRKDjy+ehi5vvyUBoHraCSsHGct2vSeutq+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352039; c=relaxed/simple;
	bh=jaDxfs2oiewgUEeYN6ok6QRhvutEJpRssJW20AUhvUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXpfRwO558CnTZz9Mty3aotGMVCxOBR6QMEHM0qzsGSmaTPxmVzaQ5nlwVy6G6SpTviXfhW14+BJTrYTYHGm/JICyZlw4YS9Dcs8kaUxS9Kjh7E0i1LkwXiOdxFCW38LVaV9B/WBpmSfpTkR9Og9abyjvtoUga+G8yO3JKGdOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIpvXFWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIpvXFWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D16C4CEF1;
	Wed, 10 Dec 2025 07:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352038;
	bh=jaDxfs2oiewgUEeYN6ok6QRhvutEJpRssJW20AUhvUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIpvXFWBXhctrUe+jIbjsQJl1XKaKYlGJExRp5aqC6uEoTjQUjnoFMx7qMTyBfx3N
	 WotN6dNEVkfWVRpsYqkPys3M8v51oxd2Qw3a9fDg9vMk0fqpXnt8Mu1/WNUomPQi6R
	 JXSWYTDhhP6gul5/Gq4WcBa+/TgVvee9Mo/CHgjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjan H Y <niranjan.hy@ti.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 27/60] ASoC: SDCA: bug fix while parsing mipi-sdca-control-cn-list
Date: Wed, 10 Dec 2025 16:29:57 +0900
Message-ID: <20251210072948.505683412@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

From: Niranjan H Y <niranjan.hy@ti.com>

[ Upstream commit eb2d6774cc0d9d6ab8f924825695a85c14b2e0c2 ]

"struct sdca_control" declares "values" field as integer array.
But the memory allocated to it is of char array. This causes
crash for sdca_parse_function API. This patch addresses the
issue by allocating correct data size.

Signed-off-by: Niranjan H Y <niranjan.hy@ti.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251110152646.192-1-niranjan.hy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 13f68f7b6dd6a..0ccb6775f4de3 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -894,7 +894,8 @@ static int find_sdca_entity_control(struct device *dev, struct sdca_entity *enti
 		return ret;
 	}
 
-	control->values = devm_kzalloc(dev, hweight64(control->cn_list), GFP_KERNEL);
+	control->values = devm_kcalloc(dev, hweight64(control->cn_list),
+				       sizeof(int), GFP_KERNEL);
 	if (!control->values)
 		return -ENOMEM;
 
-- 
2.51.0



