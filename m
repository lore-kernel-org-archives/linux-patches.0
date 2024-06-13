Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524B143892;
	Thu, 13 Jun 2024 12:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281084; cv=none; b=sW8ajufUBO/hucevZWNSMQ8FFee29IvKl9grjbxTBpNn9jHLWT9Azzwdz0HTNCNW4PShsnYPaT5ADbLG23iz2BL7ivF3Y+uL/R8uFEnBWUOpYVe5F0HJ4Hh91IQGsYmJ7bxq8AYc8nwtdg5T5ObQ+jPCU3ulr4RUw1c8gBQS1qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281084; c=relaxed/simple;
	bh=Hm5cAan/ZwFVkraHjyZUOucfLj/jXpexidZ4NZ5V3gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CidY1y4CwyJpAyTOv5qWhX2hxYbt6gbjQATawMZ4AMvsG6254fyQSFvm+hdqg3MtHjGbB6+YplpHux2pCXTGqidg1bTExaJrMF+jJ0TIElI06xTnd/urlTU00DfYOeAKGe3cLuRvIsBgt3CZkb9BKxfuX78449ojysALw582m5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i845J7ZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i845J7ZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69729C32786;
	Thu, 13 Jun 2024 12:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281083;
	bh=Hm5cAan/ZwFVkraHjyZUOucfLj/jXpexidZ4NZ5V3gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i845J7ZY67MwfOqkt4gy59HjwrRB9xONIVg6vVK6Kb2DRdKNJ6o3sU5q7hkdvK9py
	 iIfPp0M3bd9lObrrs8hM+SiYPpN+/WtyoE3eiMgNwIAj/45daDGu23IFaj6YWgU4KW
	 qEIsP7HlBhlboWMrniGLFI0R82cPECwNt4JEZ1m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/317] drm: vc4: Fix possible null pointer dereference
Date: Thu, 13 Jun 2024 13:32:03 +0200
Message-ID: <20240613113251.613669663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d01258349faa..0bd49538cb6db 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1253,6 +1253,8 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		index = 1;
 
 	addr = of_get_address(dev->of_node, index, NULL, NULL);
+	if (!addr)
+		return -EINVAL;
 
 	vc4_hdmi->audio.dma_data.addr = be32_to_cpup(addr) + mai_data->offset;
 	vc4_hdmi->audio.dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.43.0



