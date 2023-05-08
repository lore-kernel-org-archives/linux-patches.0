Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207B413AE8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ED9C433EF;
	Mon,  8 May 2023 11:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543639;
	bh=eIWazFC3QSid1eAZGLSTF5bi4cy3ezlf2fUq9SzBLFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y96NT5Bc3m9h00MKmB8Q6IM1r0XTyyUa25kbgH2SQ4S3r5FJi54ml/RUjcP3Esevl
	 Krt7ojYbWRQU0esvO/ZMWuJMhbB5KifzNmf0bVV7j7EEH77pV/BshxD9NFf+qydo1O
	 XgQ5MVv8feJKGFuDXv6Yx5u5TvNoAnTCM1341frw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel@ffwll.ch>,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 154/694] drm/probe-helper: Cancel previous job before starting new one
Date: Mon,  8 May 2023 11:39:49 +0200
Message-Id: <20230508094437.433352768@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit a8e47884f1906cd7440fafa056adc8817568e73e ]

Currently we schedule a call to output_poll_execute from
drm_kms_helper_poll_enable for 10s in future. Later we try to replace
that in drm_helper_probe_single_connector_modes with a 0s schedule with
delayed_event set.

But as there is already a job in the queue this fails, and the immediate
job we wanted with delayed_event set doesn't occur until 10s later.

And that call acts as if connector state has changed, reprobing modes.
This has a side effect of waking up a display that has been blanked.

Make sure we cancel the old job before submitting the immediate one.

Fixes: 162b6a57ac50 ("drm/probe-helper: don't lose hotplug event")
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
[Maxime: Switched to mod_delayed_work]
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127154052.452524-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_probe_helper.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index 8127be134c39e..2fb9bf901a2cc 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -590,8 +590,9 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
 		 */
 		dev->mode_config.delayed_event = true;
 		if (dev->mode_config.poll_enabled)
-			schedule_delayed_work(&dev->mode_config.output_poll_work,
-					      0);
+			mod_delayed_work(system_wq,
+					 &dev->mode_config.output_poll_work,
+					 0);
 	}
 
 	/* Re-enable polling in case the global poll config changed. */
-- 
2.39.2



