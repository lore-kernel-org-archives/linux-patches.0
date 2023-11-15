Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279D9381C6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuqTGw4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9F7C433CA;
	Wed, 15 Nov 2023 19:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078117;
	bh=Pw32qfDHJxVQCi584KBRkPDevTtAuuFUxEsFeBPAUfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuqTGw4c6gBx1tHvLnXN5iYl9uO+3OOX9J7dIYW2YRSmsEWEKXvwhQzEZACfJDy1l
	 D2IPC1s4c8JZUrFVz3LbLX8njVGyKmzuiy+qQqAgdv3UerHUfi9jej7VvLCXbkOZmZ
	 Er/zsYGfJh4RgWg0MoraHclyT7vB67OIUSckFAIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Helen Koike <helen.koike@collabora.com>,
	Jai Luthra <j-luthra@ti.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/379] drm: bridge: it66121: Fix invalid connector dereference
Date: Wed, 15 Nov 2023 14:23:15 -0500
Message-ID: <20231115192652.218993055@linuxfoundation.org>
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

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit d0375f6858c4ff7244b62b02eb5e93428e1916cd ]

Fix the NULL pointer dereference when no monitor is connected, and the
sound card is opened from userspace.

Instead return an empty buffer (of zeroes) as the EDID information to
the sound framework if there is no connector attached.

Fixes: e0fd83dbe924 ("drm: bridge: it66121: Add audio support")
Reported-by: Nishanth Menon <nm@ti.com>
Closes: https://lore.kernel.org/all/20230825105849.crhon42qndxqif4i@gondola/
Reviewed-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Tested-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230901-it66121_edid-v2-1-aa59605336b9@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 4f6f1deba28c6..9d7f3c99748b4 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -1464,10 +1464,14 @@ static int it66121_audio_get_eld(struct device *dev, void *data,
 	struct it66121_ctx *ctx = dev_get_drvdata(dev);
 
 	mutex_lock(&ctx->lock);
-
-	memcpy(buf, ctx->connector->eld,
-	       min(sizeof(ctx->connector->eld), len));
-
+	if (!ctx->connector) {
+		/* Pass en empty ELD if connector not available */
+		dev_dbg(dev, "No connector present, passing empty EDID data");
+		memset(buf, 0, len);
+	} else {
+		memcpy(buf, ctx->connector->eld,
+		       min(sizeof(ctx->connector->eld), len));
+	}
 	mutex_unlock(&ctx->lock);
 
 	return 0;
-- 
2.42.0



