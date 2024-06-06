Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D391B1424;
	Thu,  6 Jun 2024 14:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683375; cv=none; b=OmqC51S3/OwE1VFxbIi+3/mfVOzQQZYFw/kpeigoEWlQhpdwkammOwJUqU3fJxElVv3s99ctmbzxRW1X6e4oW2f05kQ4dqy5ry3NjzkGlRerLsohrTYmRUnWnOhy/zrmCNG8HNkMtahYFChkMZekLDnjhST5s0cG7xQX3bfPCX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683375; c=relaxed/simple;
	bh=dgAkcLoUdeIt93pButdZC5GXFVhIC4PnyqbOp06AQPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9JLSelerNSFR+eXfRtIfglrU7/h0rYq2sQcfxtoMORs8x8foldCGBfk37UXdsiP+9WqPh8eaLAlULAsrjOVvngagy/Lp9RCBm3R51cmrwz4GD9RrL4HA/fleryzgFKiKyrP5zQ2fm8bPCD2whr/boBS0XwO1hjmRGxbqIbMDdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZPUalOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZPUalOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B504C32781;
	Thu,  6 Jun 2024 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683375;
	bh=dgAkcLoUdeIt93pButdZC5GXFVhIC4PnyqbOp06AQPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZPUalOQ6UIj4w4uYMXAQTFKGUwez3iuUr4qQSrcASAT89UoNmaXC/XZDe3/c+Vb2
	 8bEeF0rc5XHvhbsVU5TdDd0d1s79/vafbkoP2R3btfvFpFxNfuSy2EgEqCMiNeRTiX
	 S3AJoSFsSDuhUOr7TBzrfPA7oucXlZx4ZYZZYdB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/744] drm: vc4: Fix possible null pointer dereference
Date: Thu,  6 Jun 2024 15:59:49 +0200
Message-ID: <20240606131742.594212042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4626fe9aac563..643754fa6a8ad 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2729,6 +2729,8 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		index = 1;
 
 	addr = of_get_address(dev->of_node, index, NULL, NULL);
+	if (!addr)
+		return -EINVAL;
 
 	vc4_hdmi->audio.dma_data.addr = be32_to_cpup(addr) + mai_data->offset;
 	vc4_hdmi->audio.dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.43.0



