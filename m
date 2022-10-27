Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC70AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A63C43141;
	Thu, 27 Oct 2022 17:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890130;
	bh=s0Dw6kHleEfmhqgS/zE8kn4fzuRvGuVpdxdAds7fAGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkVYauPhCiC8S8YxZFYbj4DIvABqCTfayAbb0JRT1X8fHtaMjlYDgF2XG2sqbtu8a
	 2JSO+psCCYoX5zGAdrPLZoGeCamPHEpLvTspsyez7OyCEmhLzSeKdSQxRqfxjC7vnQ
	 trlcW9ZQt8sOBP7/5EQdrMlCduqmMefEqBwh30aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/79] drm/vc4: Add module dependency on hdmi-codec
Date: Thu, 27 Oct 2022 18:55:32 +0200
Message-Id: <20221027165056.073728955@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit d1c0b7de4dfa5505cf7a1d6220aa72aace4435d0 ]

The VC4 HDMI controller driver relies on the HDMI codec ASoC driver. In
order to set it up properly, in vc4_hdmi_audio_init(), our HDMI driver
will register a device matching the HDMI codec driver, and then register
an ASoC card using that codec.

However, if vc4 is compiled as a module, chances are that the hdmi-codec
driver will be too. In such a case, the module loader will have a very
narrow window to load the module between the device registration and the
card registration.

If it fails to load the module in time, the card registration will fail
with EPROBE_DEFER, and we'll abort the audio initialisation,
unregistering the HDMI codec device in the process.

The next time the bind callback will be run, it's likely that we end up
missing that window again, effectively preventing vc4 to probe entirely.

In order to prevent this, we can create a soft dependency of the vc4
driver on the HDMI codec one so that we're sure the HDMI codec will be
loaded before the VC4 module is, and thus we'll never end up in the
previous situation.

Fixes: 91e99e113929 ("drm/vc4: hdmi: Register HDMI codec")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220902144111.3424560-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index ef8fa2850ed6..d216a1fd057c 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -397,6 +397,7 @@ module_init(vc4_drm_register);
 module_exit(vc4_drm_unregister);
 
 MODULE_ALIAS("platform:vc4-drm");
+MODULE_SOFTDEP("pre: snd-soc-hdmi-codec");
 MODULE_DESCRIPTION("Broadcom VC4 DRM Driver");
 MODULE_AUTHOR("Eric Anholt <eric@anholt.net>");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1



