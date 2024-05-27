Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E08317727;
	Mon, 27 May 2024 19:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838460; cv=none; b=FDM8cMewQeZXY3zDtB0uu+ImSClg388x0sxdoP8GRYB+Iw4D6GIMDI/Q3B9Bvkk9wUE+90uNbQTyZEQpfEMrVHZ10zxr9l5F9bN4m08CI0hyk+7STWkpP9vIHRymIoPDzTSFXCc0CUCBihdfJxEHP1YgAMMpIVTjN5JSzZiU0b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838460; c=relaxed/simple;
	bh=fIqJnNv/x3V3lpAONTZ7n6SY3LZrT0eFd3+KRCc3M5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq46+yzcKVKFFZhpoc4oCoHrZSxQQvJ9m+A4Kr0FnPHgQJAzHQJ4b8V4fK2Caz664GzFUM8MoBNOf/3rnvS+e+k107UoN169kqvk6LVJ6Tda2LtK+dVzOfeoLCToThGA1nEwW934eyfd18ZJcPpBHDE4bYZY+F7cSlyb6OJ+uHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlwnnEs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlwnnEs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF60DC2BBFC;
	Mon, 27 May 2024 19:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838460;
	bh=fIqJnNv/x3V3lpAONTZ7n6SY3LZrT0eFd3+KRCc3M5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlwnnEs3fhGnXtMzDXs2OXnzXLkhr3zYHvfpOsb0/fxmp/0CeQj3DndvzgPzFwXwL
	 oXm/iK4Wpm7WGZmGPnPj2RGSD/PyJ6+mkYDUn+JFHLD8rNLYtvkigdO3recTeLcJdP
	 5BtfYTFOIuENW5x4lgxVRjhBy07K9MZ/B3u4IM7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 402/493] drm: vc4: Fix possible null pointer dereference
Date: Mon, 27 May 2024 20:56:44 +0200
Message-ID: <20240527185643.434589053@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index f827f26543641..eff47465707be 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2739,6 +2739,8 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		index = 1;
 
 	addr = of_get_address(dev->of_node, index, NULL, NULL);
+	if (!addr)
+		return -EINVAL;
 
 	vc4_hdmi->audio.dma_data.addr = be32_to_cpup(addr) + mai_data->offset;
 	vc4_hdmi->audio.dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.43.0



