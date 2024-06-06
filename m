Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF551AED2E;
	Thu,  6 Jun 2024 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683341; cv=none; b=FSK1CXUUSc9MvFFKnmW2Y9K74fcV4DCKFKDuxJLZrJVkCrFSwDCuny5afKLOdcZiughRK0Q6anlQHERNdzETnhJlDl2RTgbG/uDVkdG1DTY8uSVnd9BkysWydXxV59F6gX7SGPm9Ybo3A5W5WsOAjhKCF23y27XnLIi8TxqfkUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683341; c=relaxed/simple;
	bh=HAtaGKFiGfj7JLkFqsuJJOQANH0uK7goAWUkKEqVA8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDoZ2dgAIxpajxI9fMkzbCAV2l87e+I2c7ik+nUSoJXyuSdRC/wT2UTsst4/Yc1w3qJWlVBF6intCC+XzoaB063tcLX1Zq8UJeKByDMyRASnfJrfH0ubDQUKC423GohwoXpUh0P3z5/xrlnqk+KsUVaK+AmiG0qWzuAIP31/7Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEHInXgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEHInXgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6261C2BD10;
	Thu,  6 Jun 2024 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683340;
	bh=HAtaGKFiGfj7JLkFqsuJJOQANH0uK7goAWUkKEqVA8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEHInXgUaSayt394nVNVL22wKAak6TDP3VJX8GYyOixwDPdvLDeSba9AmoPiDqpvt
	 0cah7WNuMokj/fUYWHZK1eyoHog2cSL9Ta/L1mf1v4Vzzv6suF3KQ6zWfIs1I6qk9p
	 qI8PLmsk5WrLS17Zk6Yq5V78SjKQ+in6kPmDKnLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/473] drm: vc4: Fix possible null pointer dereference
Date: Thu,  6 Jun 2024 16:02:31 +0200
Message-ID: <20240606131707.223808004@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit c534b63bede6cb987c2946ed4d0b0013a52c5ba7 ]

In vc4_hdmi_audio_init() of_get_address() may return
NULL which is later dereferenced. Fix this bug by adding NULL check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bb7d78568814 ("drm/vc4: Add HDMI audio support")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240409075622.11783-1-amishin@t-argos.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index f696818913499..072e2487b4655 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2489,6 +2489,8 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		index = 1;
 
 	addr = of_get_address(dev->of_node, index, NULL, NULL);
+	if (!addr)
+		return -EINVAL;
 
 	vc4_hdmi->audio.dma_data.addr = be32_to_cpup(addr) + mai_data->offset;
 	vc4_hdmi->audio.dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.43.0



