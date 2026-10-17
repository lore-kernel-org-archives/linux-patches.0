Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E0394470;
	Sat, 17 Oct 2026 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257598; cv=none; b=SvxjeBNoNHo8kybC3J9LOev44miSI1Tgso9WuYqWsAhc6R7Bn92NBqayqUYvxnQmNFqqTRfiDueBp788PDkDQgyIYXC9OWiNYNhoN2e53EHHv2I4zztWPcL25wweuQ8jtyDVr52DBYVaf+lSr5EIuc3+WJJ8vXlrfA23FBxiG2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257598; c=relaxed/simple;
	bh=TJsOslc1R5jpCuG41MIez/H4bHkAvIw2tSHO9J5QpbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g09lWis2XmhPfP4iZ8RK3s1Uyg5Pp8Bf/F/MHw/y35PddtIDFabYqAlxlrpcPyrzUZX2JYzgL8AxyVzn844+cHw87lGlaoizMOTwCdfko4TO35SDypdrl20qTA1tKnofPSsiX2OPI89USVpr9qUU3W8MKj8lkaodTv4CMRydAS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgNrTwTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgNrTwTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16D11F000C5;
	Sat, 17 Oct 2026 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257597;
	bh=aBtf7u3bKqTRu9CJK+SLJ8OvcVleDrxwiCV7xpULrmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgNrTwTFOYwktG9zfvkcMzQOfm9yQbgboIksXzJS9BvbWk7BbvwPgWzNOQKMBxQKF
	 u14VA3hdGRgl+6cxEYJtvdfqjYnnNWlv+uxZTPeNfgvx8T/xNiQ+VX/la9UjATXSle
	 Idw4KwPrNc+/BjRQPHbrLuv+uO1mVk4bk/BK5+M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0608/1674] drm/vc4: Fix firmware reference leak in vc4_drm_bind()
Date: Sat, 17 Oct 2026 17:48:00 +0200
Message-ID: <20261017160446.689988805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b816da5d5df1461446a0a5f3fe2b4948a659a790 ]

The firmware reference obtained via rpi_firmware_get() is leaked when
aperture_remove_all_conflicting_devices() fails, as the error label
returns without putting it. This happens before the firmware is
consumed and put further down in the function.

Put the firmware reference before jumping to err.

Fixes: c406ad5e4a85 ("drm/vc4: Notify the firmware when DRM is in charge")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916154015.2056797-1-vulab@iscas.ac.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
[ sashal: Adapted to drm_aperture_remove_framebuffers() and its direct-return error path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 1b3531374967e..ddeb9ffc3063a 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -351,8 +351,11 @@ static int vc4_drm_bind(struct device *dev)
 	}
 
 	ret = drm_aperture_remove_framebuffers(driver);
-	if (ret)
+	if (ret) {
+		if (firmware)
+			rpi_firmware_put(firmware);
 		return ret;
+	}
 
 	if (firmware) {
 		ret = rpi_firmware_property(firmware,
-- 
2.53.0



