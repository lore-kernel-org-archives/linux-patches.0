Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6FA6280B;
	Tue, 23 Jan 2024 00:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971145; cv=none; b=gmiC2F2153XlnZx3X71afL/ZyDGU461ETHGZ3KSWKuWECNIhtt7AlUYMZz7m2c5XAsoMMb+3RiA5ZI8jUOGt+ovzaqfl4gMVFF6oy98PLGAXBwnrcZ4aEH4tA1hyNADu81QAnvn49sS5PCEpzbSxzDNbPKeR6aPncMbmFyDGodU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971145; c=relaxed/simple;
	bh=xlpIp4GovZyMZchsc7cbKs2nh7qYZ9aaYklq/mZhucY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffRJyXPdhfzBchJDKmks4FSHgPKJ8W2rkQuXKzXmr4Q6slm3n9PfXXN24J0dl9qMwiZxpEzEhBbUBat5yxj3dC5ikX0XRcoK+AIaomSciWZYcfVzi7GaOOy0+aae55m636XLckNJr1HsKt27O37SoTJz4BwCDzyZ1sqhQjTdso8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wYM7Utk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wYM7Utk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0988EC43390;
	Tue, 23 Jan 2024 00:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971145;
	bh=xlpIp4GovZyMZchsc7cbKs2nh7qYZ9aaYklq/mZhucY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wYM7UtkZ7ZHmPSJisPbbkM+eAVMC70SwxriglZ7/jNHrfANNGMfr2hPgHfbMOni+
	 UX4dmqwkYnfK/T9Jya7Xu0zwf/+Zq+c3Fb9gVHtVRYn2hiOaKoBToRS3pol7HYH3s3
	 YlVspDVNtGbJ1wJWn9W4pnT/HyZAUUrjpuv80+y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/417] drm/bridge: tc358767: Fix return value on error case
Date: Mon, 22 Jan 2024 15:55:58 -0800
Message-ID: <20240122235758.495189740@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 32bd29b619638256c5b75fb021d6d9f12fc4a984 ]

If the hpd_pin is invalid, the driver returns 'ret'. But 'ret' contains
0, instead of an error value.

Return -EINVAL instead.

Fixes: f25ee5017e4f ("drm/bridge: tc358767: add IRQ and HPD support")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-4-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 7ef78283e3d3..926ab5c3c31a 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -2097,7 +2097,7 @@ static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	} else {
 		if (tc->hpd_pin < 0 || tc->hpd_pin > 1) {
 			dev_err(dev, "failed to parse HPD number\n");
-			return ret;
+			return -EINVAL;
 		}
 	}
 
-- 
2.43.0



