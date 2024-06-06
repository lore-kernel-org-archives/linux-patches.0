Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B83197542;
	Thu,  6 Jun 2024 14:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683695; cv=none; b=NrEQ1bRr5rfBhCPJ1quBEmlBLlxPowUAIXKOy/okPBBtSvK9WrB2jac9yiz9eBks2hNqUBNNWWcz25hpU2Fb4iHMFuAnJoTrv+eS2j+3lwxLRvNUyIjKoAUgx+wPRL08EOHVbcHWN7kWdfSPq37ztDAUymi4fPwqEs1A2FWo478=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683695; c=relaxed/simple;
	bh=RcZENCftesLMumIVRYOzihaquGfAAmUJ5Ao5eoe3UW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wu2ftmdnkzL9Fu46Ov3uD/ItOHfPt+b+JDf2VscETbbAGRrcdv2rqbwxDxOEbPvE8JAYadZlrzX+WNMUrdum+qWSloFSkKkK/0wckpBeJEVPLJu6akgPU69tJOfnvCoENuTdfkaLq7q/4yItgeFtcHImXQhvmJ4b2gFAgvFT6xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs9Uo5O9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs9Uo5O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B0C2BD10;
	Thu,  6 Jun 2024 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683694;
	bh=RcZENCftesLMumIVRYOzihaquGfAAmUJ5Ao5eoe3UW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs9Uo5O94jqUtRR9Cwwc6O5zZzId6+uDZxLXb32dsuLn52kkrntzcGfVFweFnxhOc
	 bM/H8qdqD5d5neyMVkK7ONvF5XSEXBMD1ZvClh1LZfcysSirSYQwhjoNmPAoB7NMQD
	 7zdsBaAFsaF+WNytKqn4XdZVv8YdyUcskjh0KHn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Umang Jain <umang.jain@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 568/744] media: v4l: Dont turn on privacy LED if streamon fails
Date: Thu,  6 Jun 2024 16:04:00 +0200
Message-ID: <20240606131750.672667650@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit f2bf6cd8f44781349620e30a0af8987fe9af008f ]

Turn on the privacy LED only if streamon succeeds. This can be done after
enabling streaming on the sensor.

Fixes: b6e10ff6c23d ("media: v4l2-core: Make the v4l2-core code enable/disable the privacy LED if present")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f481d1ca32abb..a32ef739eb449 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -371,15 +371,6 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 	if (WARN_ON(!!sd->enabled_streams == !!enable))
 		return 0;
 
-#if IS_REACHABLE(CONFIG_LEDS_CLASS)
-	if (!IS_ERR_OR_NULL(sd->privacy_led)) {
-		if (enable)
-			led_set_brightness(sd->privacy_led,
-					   sd->privacy_led->max_brightness);
-		else
-			led_set_brightness(sd->privacy_led, 0);
-	}
-#endif
 	ret = sd->ops->video->s_stream(sd, enable);
 
 	if (!enable && ret < 0) {
@@ -387,9 +378,20 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 		ret = 0;
 	}
 
-	if (!ret)
+	if (!ret) {
 		sd->enabled_streams = enable ? BIT(0) : 0;
 
+#if IS_REACHABLE(CONFIG_LEDS_CLASS)
+		if (!IS_ERR_OR_NULL(sd->privacy_led)) {
+			if (enable)
+				led_set_brightness(sd->privacy_led,
+						   sd->privacy_led->max_brightness);
+			else
+				led_set_brightness(sd->privacy_led, 0);
+		}
+#endif
+	}
+
 	return ret;
 }
 
-- 
2.43.0



