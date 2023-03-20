Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F841C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A79C433D2;
	Mon, 20 Mar 2023 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324406;
	bh=S6tEHWndNmSMMQ5WutitFRxVDIVV+AOXs7zwPkBG9T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJRGuAtcbXEAIV1+HE6thqtZqUJJ6B/50vfFG6Gb8lZeufG2PqUQXJHxGw29qxAq2
	 2yXGwxfV1iz6d2PmYHjf3Z6A4IwK7eT39Oz2srGTgQW1xvx1XkYFq7vl51Z1C2bXOt
	 rbZGr65JyMlPGxRax5pNt+HnOZvlzIODNBAJ3dw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Christian Hewitt <christianshewitt@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/60] drm/meson: fix 1px pink line on GXM when scaling video overlay
Date: Mon, 20 Mar 2023 15:54:14 +0100
Message-Id: <20230320145431.093521396@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 5c8cf1664f288098a971a1d1e65716a2b6a279e1 ]

Playing media with a resolution smaller than the crtc size requires the
video overlay to be scaled for output and GXM boards display a 1px pink
line on the bottom of the scaled overlay. Comparing with the downstream
vendor driver revealed VPP_DUMMY_DATA not being set [0].

Setting VPP_DUMMY_DATA prevents the 1px pink line from being seen.

[0] https://github.com/endlessm/linux-s905x/blob/master/drivers/amlogic/amports/video.c#L7869

Fixes: bbbe775ec5b5 ("drm: Add support for Amlogic Meson Graphic Controller")
Suggested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230303123312.155164-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_vpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/meson/meson_vpp.c b/drivers/gpu/drm/meson/meson_vpp.c
index 154837688ab0d..5df1957c8e41f 100644
--- a/drivers/gpu/drm/meson/meson_vpp.c
+++ b/drivers/gpu/drm/meson/meson_vpp.c
@@ -100,6 +100,8 @@ void meson_vpp_init(struct meson_drm *priv)
 			       priv->io_base + _REG(VPP_DOLBY_CTRL));
 		writel_relaxed(0x1020080,
 				priv->io_base + _REG(VPP_DUMMY_DATA1));
+		writel_relaxed(0x42020,
+				priv->io_base + _REG(VPP_DUMMY_DATA));
 	} else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
 		writel_relaxed(0xf, priv->io_base + _REG(DOLBY_PATH_CTRL));
 
-- 
2.39.2



