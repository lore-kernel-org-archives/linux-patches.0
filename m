Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAF4155C87;
	Tue, 13 Oct 2026 11:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892495; cv=none; b=WiA8zjzJNDjkRXE3LfcUsMoaOVyDXKEfeWDHUOjEaodDdPGqQARRVxUEvughO7uyRYkxfKGMjnaN6rFE1IF9pip9/r6Wk24/CwjJQqzxmO0kOp01XeLWG01RKUaXYQtt/UbdC6KjoVWIX4Qo2lBUlT5B7OEUIaVnI3Q6LR7mgIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892495; c=relaxed/simple;
	bh=03tZcbIp7qXiUDDHqTNOZ2YaaHUJd8WZmWeUy/taYGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ultIl9FU/pj87X88o+GlFWF86Wj3sAbSx8EabD7obrcX2SRuqgrQhJtkvHvIlzvmXXe9LO5oe3oQcKm+kUKZDqUqJXEJTo8czo6Wi/yqyk5SZFPIF+T6LNmoex/2FbdL/9d/4Tc5wDMwJ1w6w8XaBuwtI7Dw6g7jaQ7etDhCvlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzjphQIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzjphQIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EDF1F000FF;
	Tue, 13 Oct 2026 11:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892494;
	bh=k+Hxz6oyKfKmv3OhRzIk/5GOex/muq4aJQk6mYLXcAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzjphQIKPIFMV8BXDT+qvXTnIbluVlZGE0Cw5uUGgYojHVFLDgX5qCb3cnFyVjfe+
	 fLDLTPacg2wE7EIcd6uDOngijyeByrViqN8r8GJXqt28fzP6srwHlqSVUSWGqmpe6j
	 D2V+DhG/d9kFh5SVoYcWSlo/C6UPhU69iuk35g8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 192/281] drm/dp: dont mark the AUX backlight enabled when enabling failed
Date: Tue, 13 Oct 2026 13:38:28 +0200
Message-ID: <20261013112859.825399660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e623ccb4c1d8a..488fd123a01ad 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -4634,7 +4634,9 @@ static int dp_aux_backlight_update_status(struct backlight_device *bd)
 
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



