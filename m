Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89281C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E58CC4339C;
	Mon, 20 Mar 2023 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326104;
	bh=6roGfIbwxCCrhisq3MIwP6E0vzrF/ZPUGuwY/KUhqyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyAgeWl1ozuSR39LjKmd6N08ZaeyGRAovGdpPCuWCBc9taejogNrUajWh2IVh8raS
	 em/fh2sw60tJ95JFsf0zNlnsEJe8VhafmhTp60xO4Aj3vMv13v1Pqp/zw1mvPNPJLj
	 Xi4XV0tuVMmo8x2DvW2XgmyD1XidnX3NHbs92OeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 161/211] drm/edid: fix info leak when failing to get panel id
Date: Mon, 20 Mar 2023 15:54:56 +0100
Message-Id: <20230320145520.191538595@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 4d8457fe0eb9c80ff7795cf8a30962128b71d853 upstream.

Make sure to clear the transfer buffer before fetching the EDID to
avoid leaking slab data to the logs on errors that leave the buffer
unchanged.

Fixes: 69c7717c20cc ("drm/edid: Dump the EDID when drm_edid_get_panel_id() has an error")
Cc: stable@vger.kernel.org	# 6.2
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230302074704.11371-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 3841aba17abd..8707fe72a028 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2797,7 +2797,7 @@ u32 drm_edid_get_panel_id(struct i2c_adapter *adapter)
 	 * the EDID then we'll just return 0.
 	 */
 
-	base_block = kmalloc(EDID_LENGTH, GFP_KERNEL);
+	base_block = kzalloc(EDID_LENGTH, GFP_KERNEL);
 	if (!base_block)
 		return 0;
 
-- 
2.40.0



