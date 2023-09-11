Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9511705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349E4C433C8;
	Mon, 11 Sep 2023 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443358;
	bh=b1qrkjgjanB/zRQrETd1Nx0iKkvVPdTXkRoS3/bEJP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbzHxddZTg636pfgqMemBNAeS+nTtzCeHEQXXZ6VDADaKLMmbJNESZtwLb4LANESG
	 LgajBCELTI0m8YxsS3kkl+2YShQivYivjVOFl4jb8/yU0/rlNdHbfWVjjR6WV8ut6m
	 1L8VikezrWtV5bikPr45cKv/iCEcUIuHpM6ezKCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 349/737] drm/armada: Fix off-by-one error in armada_overlay_get_property()
Date: Mon, 11 Sep 2023 15:43:28 +0200
Message-ID: <20230911134700.271788003@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5f0d984053f74983a287100a9519b2fabb785fb5 ]

As ffs() returns one more than the index of the first bit set (zero
means no bits set), the color key mode value is shifted one position too
much.

Fix this by using FIELD_GET() instead.

Fixes: c96103b6c49ff9a8 ("drm/armada: move colorkey properties into overlay plane state")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/a4d779d954a7515ddbbf31cb0f0d8184c0e7c879.1689600265.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/armada/armada_overlay.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_overlay.c b/drivers/gpu/drm/armada/armada_overlay.c
index f21eb8fb76d87..3b9bd8ecda137 100644
--- a/drivers/gpu/drm/armada/armada_overlay.c
+++ b/drivers/gpu/drm/armada/armada_overlay.c
@@ -4,6 +4,8 @@
  *  Rewritten from the dovefb driver, and Armada510 manuals.
  */
 
+#include <linux/bitfield.h>
+
 #include <drm/armada_drm.h>
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
@@ -445,8 +447,8 @@ static int armada_overlay_get_property(struct drm_plane *plane,
 			     drm_to_overlay_state(state)->colorkey_ug,
 			     drm_to_overlay_state(state)->colorkey_vb, 0);
 	} else if (property == priv->colorkey_mode_prop) {
-		*val = (drm_to_overlay_state(state)->colorkey_mode &
-			CFG_CKMODE_MASK) >> ffs(CFG_CKMODE_MASK);
+		*val = FIELD_GET(CFG_CKMODE_MASK,
+				 drm_to_overlay_state(state)->colorkey_mode);
 	} else if (property == priv->brightness_prop) {
 		*val = drm_to_overlay_state(state)->brightness + 256;
 	} else if (property == priv->contrast_prop) {
-- 
2.40.1



