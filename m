Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DFF161;
	Thu, 13 Jun 2024 12:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282042; cv=none; b=UH+MEUs9+5mzDA3trRHsyHtykvecSdPkxDLhOhA1VM9r5fkuwXkskFuO4kUebhJmHTFJ4p3uKD/BPY9zBq9SX1BnGWNd7EbuHbIr6bmFz3bld6sMMG/rglLZbhLelk04OkLm/1U085ISgv4BsJ1NrCT45NGm+3Bw6t5k+LNntHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282042; c=relaxed/simple;
	bh=jzwqNh9c+7zyl/wIuTHFujMoJNoszjfKeRv2c1yPAR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gh1x/9XniQ3MtqGMQfmnurAFMQuVDb5TkCyyaNNrtm7a7ksmbOv2oEx6OIZt7lUC2GxEpf7saedBJ+tYx7Hh/dHb2a3No/xQTaY7hXGbpcKU0Xo4PCjeoOn5uDi1vMSsjkh20S+0ZXqzjnPlWUptV+Zv979pCHblxvrEhV10VzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LfDO+Xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LfDO+Xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4208EC4AF1A;
	Thu, 13 Jun 2024 12:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282041;
	bh=jzwqNh9c+7zyl/wIuTHFujMoJNoszjfKeRv2c1yPAR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LfDO+XeIt0WhVeFAWN9kEs4Peg+dp9zcpWVn6MDDLLsCbixe7qO8x+vQ9BojkKYy
	 5DgkZk6oLx6u+0ue/uvU9Yw1AOULUFRzL5/R4HUs6ZJYDJc5RydJQjIW1ftvrRGE0R
	 5Uln78jB+5Nq9pHqOO2W5whShLEibLHeaVoZFxFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/402] drm: vc4: Fix possible null pointer dereference
Date: Thu, 13 Jun 2024 13:31:39 +0200
Message-ID: <20240613113307.674730090@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 88aa00a1891b3..86d77794d8392 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1506,6 +1506,8 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		index = 1;
 
 	addr = of_get_address(dev->of_node, index, NULL, NULL);
+	if (!addr)
+		return -EINVAL;
 
 	vc4_hdmi->audio.dma_data.addr = be32_to_cpup(addr) + mai_data->offset;
 	vc4_hdmi->audio.dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.43.0



