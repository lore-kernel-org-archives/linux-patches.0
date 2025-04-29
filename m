Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F62521ABC6;
	Tue, 29 Apr 2025 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950169; cv=none; b=Es/hK67Fe6pYsSn66+u6x+dKlq2CrPKtLOqUYAjS13QJ0snxWqVrQEMgxsQm0GJ9w7HpfBkUkRNziduB3LIHwR+KW64LRdDotSyTa76p+Ba9eaTSJwD4Wd6gf9uYgoBInhfiv12bq+MpHhSl9Yagynlt6xdg6I0OBgRKQMUVAKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950169; c=relaxed/simple;
	bh=KUEqJisrOOKqZ3+djCERmtk1hAopLG1gb3uq3Zjw6yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRhdVK4kTLVcyKVY/y4XFVrZGTuteJIfHBVyyzJ6ap9qnl96opTfRUT7W8VXjyHviHPcFG33BbIiXhVwLne8Rqef+yHJD2vtJR57jGiessvZZ4FxCsPrguq2EcY5cw1azTTfgcbi6ZuFhu6yYjvrsHXZb8mI3R1Y+Uc0mfdvKLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjyt0DJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjyt0DJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AE3C4CEE3;
	Tue, 29 Apr 2025 18:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950169;
	bh=KUEqJisrOOKqZ3+djCERmtk1hAopLG1gb3uq3Zjw6yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjyt0DJxeWQKkP/FPIAA9V55jVGXhTSyXKMc+ouhsWtqdR25vmTFM5Z8EjWOoAbdB
	 BumoqJUb/ZjKWfRz1/aS14C+/CMY3Bq8w8oQCkFgvAryM0eTXCgtkNaa1jTY8547pB
	 yDp4OPQh4oIEj9QiUAygeyfuYF+2KtQh8Ct1AGoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/204] media: subdev: Add v4l2_subdev_is_streaming()
Date: Tue, 29 Apr 2025 18:41:38 +0200
Message-ID: <20250429161059.825495795@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 5f3ce14fae742d1d23061c3122d93edb879ebf53 ]

Add a helper function which returns whether the subdevice is streaming,
i.e. if .s_stream or .enable_streams has been called successfully.

Reviewed-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 36cef585e2a3 ("media: vimc: skip .s_stream() for stopped entities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 25 +++++++++++++++++++++++++
 include/media/v4l2-subdev.h           | 13 +++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f555fd3c4b76d..5f115438d0722 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -2240,6 +2240,31 @@ void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_notify_event);
 
+bool v4l2_subdev_is_streaming(struct v4l2_subdev *sd)
+{
+	struct v4l2_subdev_state *state;
+
+	if (!v4l2_subdev_has_op(sd, pad, enable_streams))
+		return sd->s_stream_enabled;
+
+	if (!(sd->flags & V4L2_SUBDEV_FL_STREAMS))
+		return !!sd->enabled_pads;
+
+	state = v4l2_subdev_get_locked_active_state(sd);
+
+	for (unsigned int i = 0; i < state->stream_configs.num_configs; ++i) {
+		const struct v4l2_subdev_stream_config *cfg;
+
+		cfg = &state->stream_configs.configs[i];
+
+		if (cfg->enabled)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_is_streaming);
+
 int v4l2_subdev_get_privacy_led(struct v4l2_subdev *sd)
 {
 #if IS_REACHABLE(CONFIG_LEDS_CLASS)
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0a8d75b009ea2..b4fcd0164048e 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1918,4 +1918,17 @@ extern const struct v4l2_subdev_ops v4l2_subdev_call_wrappers;
 void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
 			      const struct v4l2_event *ev);
 
+/**
+ * v4l2_subdev_is_streaming() - Returns if the subdevice is streaming
+ * @sd: The subdevice
+ *
+ * v4l2_subdev_is_streaming() tells if the subdevice is currently streaming.
+ * "Streaming" here means whether .s_stream() or .enable_streams() has been
+ * successfully called, and the streaming has not yet been disabled.
+ *
+ * If the subdevice implements .enable_streams() this function must be called
+ * while holding the active state lock.
+ */
+bool v4l2_subdev_is_streaming(struct v4l2_subdev *sd);
+
 #endif /* _V4L2_SUBDEV_H */
-- 
2.39.5



