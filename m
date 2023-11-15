Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B7D381C6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDKrXC7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EA0C433C8;
	Wed, 15 Nov 2023 19:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078126;
	bh=dryMz6diMyXgl/X3Lb4Gx/XydnGb8y6eT4vuXqYmy/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDKrXC7Scwc7U3PqGOfrmkHXA4bQLVKXwwdcxQph2QHXUsIG/ago3DCCVToMsyr0s
	 g/Y3L/e+3jtDHSVILB4xJXVMj13+ZaDau1lidU7M4eG7PFVryuLTyPI9K21ZT9vQ6N
	 zBePUeFJBA8ejCnZW7PHC8eRgOU+ggvwUDJneRk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Maxim Schwalm <maxim.schwalm@gmail.com>
Subject: [PATCH 6.1 126/379] drm/bridge: tc358768: Fix use of uninitialized variable
Date: Wed, 15 Nov 2023 14:23:21 -0500
Message-ID: <20231115192652.569908031@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

[ Upstream commit a2d9036615f0adfa5b0a46bb2ce42ef1d9a04fbe ]

smatch reports:

drivers/gpu/drm/bridge/tc358768.c:223 tc358768_update_bits() error: uninitialized symbol 'orig'.

Fix this by bailing out from tc358768_update_bits() if the
tc358768_read() produces an error.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> # Asus TF700T
Tested-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230906-tc358768-v4-2-31725f008a50@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index 2d0ac9987b58e..16aa849e992bd 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -217,6 +217,10 @@ static void tc358768_update_bits(struct tc358768_priv *priv, u32 reg, u32 mask,
 	u32 tmp, orig;
 
 	tc358768_read(priv, reg, &orig);
+
+	if (priv->error)
+		return;
+
 	tmp = orig & ~mask;
 	tmp |= val & mask;
 	if (tmp != orig)
-- 
2.42.0



