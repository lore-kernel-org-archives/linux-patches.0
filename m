Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DB8101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFC9C433EF;
	Mon, 15 May 2023 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173265;
	bh=Lb/4xfdWm52JyHHEGAfrzFh/aw2uT261NjwEKYqIOCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+395AQteDfXkid3rqq+F92/J4w3o9QTrmjn3F1D+QraFAliToHRlGMxy/g+ByTWf
	 ivm5/d15ibBVz6C0BRiJAljKvOMn4C0a4oM8qdR9Wf3z3j/QNLy+wTvHdlFQcAIWe0
	 /zFkNMzwmrZ+gyfizZcpfwIqgDNlFdYLSq8NddE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel@ffwll.ch>,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/282] drm/probe-helper: Cancel previous job before starting new one
Date: Mon, 15 May 2023 18:26:55 +0200
Message-Id: <20230515161723.383652001@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
index d45f43feaf862..4c8bb93a89fb2 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -460,8 +460,9 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
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



