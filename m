Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E2048A2C7;
	Tue, 13 Oct 2026 12:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894500; cv=none; b=P6Jl8Hbhdf72aP4X2FtKYtsRYFCLGQLrgjE4OaoK4BMgMrKl/5oWhxSglUr2wbZrXxCYKkq/43dr+GuK9SxtUZ0DhbtuJPQavVk7lddkyDn7/WjkEl9XOMbdSl9Yapy1oZnk794Lle6RaE+gVMy0Q+cRKDwmbX/ZuANwIBkVjU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894500; c=relaxed/simple;
	bh=hOXIrEK8v0K7NVX6oH/sDbq6DwEsvpl/wB6JlOnZymo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRSvolmeU4j8evwIKntS/jQCiUe1OlbFnAk96YYOcX+loc0LyIvUrhQJf38JPPzmRY8McsYnYUpabcMEvk57v25y0f+amQpjyEUHeccR/rR+YoGf2iw1Od/q0AILsRXOeX3acT7/CxUuevNrm6a0/dba7V+xqF+UXlrvcU5lAjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tutTE8Cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tutTE8Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B758E1F000FF;
	Tue, 13 Oct 2026 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894499;
	bh=WiRIZUNyjZiRVzzNDUuW84gJbryDcLMNY/IXcv92kno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tutTE8CdEUHLAWevonvzchbBIbs4MuQbPk+lidCNJx+7mySiP5PDi7B8PJ6ec2yAA
	 8YWTXlpHQq/Z9mAenJplNwTQ4SmLVDPsnkyTpfTMM1k0lH+OtEVR896GjS/dFD/OVn
	 lNVRMuxruidJCWOKzVXBorcuPPQpsXR+pl7Y8T3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 537/621] drm/dp: dont mark the AUX backlight enabled when enabling failed
Date: Tue, 13 Oct 2026 13:38:52 +0200
Message-ID: <20261013112933.563397464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit 707ce102521496c67860d81221b20c56d8255f2f ]

If drm_edp_backlight_enable() fails, dp_aux_backlight_update_status()
still marks the backlight as enabled. From then on every brightness
change only updates the level and the enable is never retried, so the
panel stays dark until something blanks and unblanks the backlight.

Return the error instead, so the next update tries to enable again.

Fixes: 10f7b40e4f30 ("drm/panel: add basic DP AUX backlight support")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260925132558.27518-1-okerixx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 77336bc3e62c2..4fc371f0fa123 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -4378,7 +4378,9 @@ static int dp_aux_backlight_update_status(struct backlight_device *bd)
 
 	if (!backlight_is_blank(bd)) {
 		if (!bl->enabled) {
-			drm_edp_backlight_enable(bl->aux, &bl->info, brightness);
+			ret = drm_edp_backlight_enable(bl->aux, &bl->info, brightness);
+			if (ret)
+				return ret;
 			bl->enabled = true;
 			return 0;
 		}
-- 
2.53.0



