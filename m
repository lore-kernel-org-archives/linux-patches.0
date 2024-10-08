Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D501DED6A;
	Tue,  8 Oct 2024 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390164; cv=none; b=qh7JKw5hdmJivBE4J55bAk6Nywxnlx3HFbQK+HLG4yjSrVOT5Z54D9tUdA+UCPl/hWhTgVR55tgORE+WNUC4xR4BmQlqJtBL0SQsCeuq7tUu/2zCmHK/4+XM7cwvV7Z/ROQXr7m7uZ8qdbVFTW9lImIgAf1wAwgsA0iFDvNKT6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390164; c=relaxed/simple;
	bh=XbBO7kp2S/1do7MH3tU/4fXCIoEGAq4XfZV7n4daWFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsC++3+s/uAFNZZEqpQAySMzDkiEhOmTgKc9bnEtMR8RtEWYnslxmOgYqxKHF50emn/kGcbItyE9iOdBKW99HykHchJqmSnvl625+4u+JZTU+yDk5q06gbOis2Xf3t54UGiIefWt90oayafxFudZ/dAQTNTh6d6eXsQdUro51K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZyoLxMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZyoLxMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87CEC4CEC7;
	Tue,  8 Oct 2024 12:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390164;
	bh=XbBO7kp2S/1do7MH3tU/4fXCIoEGAq4XfZV7n4daWFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZyoLxMzqMB81nbKZznoi82spxc7d+PDVCjd1tJSeUKaVJbJWq+hQ9BsB7r4o8wiJ
	 DB1yuw2cDrO6SE5Qme620VArX685knMOeF2wEs4TP5nyapZWZdJNfucG2Hu+NCPu5c
	 d1xuycYBOVKdtmQjcpdlyF2uF7d/66nje0G5iJ50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yannick Fertre <yannick.fertre@foss.st.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 209/482] drm/stm: ltdc: reset plane transparency after plane disable
Date: Tue,  8 Oct 2024 14:04:32 +0200
Message-ID: <20241008115656.534524370@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yannick Fertre <yannick.fertre@foss.st.com>

[ Upstream commit 02fa62d41c8abff945bae5bfc3ddcf4721496aca ]

The plane's opacity should be reseted while the plane
is disabled. It prevents from seeing a possible global
or layer background color set earlier.

Signed-off-by: Yannick Fertre <yannick.fertre@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240712131344.98113-1-yannick.fertre@foss.st.com
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 056642d12265c..0832b749b66e7 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -1513,6 +1513,9 @@ static void ltdc_plane_atomic_disable(struct drm_plane *plane,
 	/* Disable layer */
 	regmap_write_bits(ldev->regmap, LTDC_L1CR + lofs, LXCR_LEN | LXCR_CLUTEN |  LXCR_HMEN, 0);
 
+	/* Reset the layer transparency to hide any related background color */
+	regmap_write_bits(ldev->regmap, LTDC_L1CACR + lofs, LXCACR_CONSTA, 0x00);
+
 	/* Commit shadow registers = update plane at next vblank */
 	if (ldev->caps.plane_reg_shadow)
 		regmap_write_bits(ldev->regmap, LTDC_L1RCR + lofs,
-- 
2.43.0



