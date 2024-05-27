Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2366A039;
	Mon, 27 May 2024 19:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837173; cv=none; b=Hk/vBgGl6h9NYyLghzHOSgU/G7Znw0pPbP8lejKskG+bjvi9gNucH6pdnpfoxQK8X3HLpx3O0jZoP3xZ2OnZnuWT8TC9OgOW/THRiHmjapxZ9TSfW0eRuoWLJJceKDh0jqX7U2fuWzh4oK8QnrYoY5CRhcQNKuuUQZwQ7j77eOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837173; c=relaxed/simple;
	bh=3LZplkpMttu/CIGk/GrUCt4fJr1DNO0i/9tpJbRwrus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozMewPkw0Q8MdcbPx7s2VBghgXOoiNHwJK1xyNW2N4Swh9P6TWyxJ+JzYFyYnqNRyw8fuWDCluw01abjMfDBb3oleHmWUV/y5R6mpBqRXJwQnMQsH3ZsyHAdauxE7uc5LzxPs+zaOevGDcfFRyAuz84Hzl878v/+vjRpTjmKX48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrBhuRc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrBhuRc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E77C2BBFC;
	Mon, 27 May 2024 19:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837173;
	bh=3LZplkpMttu/CIGk/GrUCt4fJr1DNO0i/9tpJbRwrus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrBhuRc0SYVJ99zQDMHy7UNGQqaBPVCD8RTtjVqcvKONyL504VGexrLoDBJOMZIfu
	 eVksROrLIJLRqeJv3inZ4xvY4hItX0atwF770OYch5FqLX6Lz4tTm1ajpzIfM7DieO
	 gPURdmSVn6zUBo8tXsIYHBeGSOOUgtkjeG8hvekQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 338/427] drm/bridge: anx7625: Update audio status while detecting
Date: Mon, 27 May 2024 20:56:25 +0200
Message-ID: <20240527185632.701328106@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit a665b4e60369867cddf50f37f16169a3e2f434ad ]

Previously, the audio status was not updated during detection, leading
to a persistent audio despite hot plugging events. To resolve this
issue, update the audio status during detection.

Fixes: 566fef1226c1 ("drm/bridge: anx7625: add HDMI audio function")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240416-anx7625-v3-1-f916ae31bdd7@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 02bf450053076..59e9ad3499696 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2469,15 +2469,22 @@ static void anx7625_bridge_atomic_disable(struct drm_bridge *bridge,
 	mutex_unlock(&ctx->aux_lock);
 }
 
+static void
+anx7625_audio_update_connector_status(struct anx7625_data *ctx,
+				      enum drm_connector_status status);
+
 static enum drm_connector_status
 anx7625_bridge_detect(struct drm_bridge *bridge)
 {
 	struct anx7625_data *ctx = bridge_to_anx7625(bridge);
 	struct device *dev = ctx->dev;
+	enum drm_connector_status status;
 
 	DRM_DEV_DEBUG_DRIVER(dev, "drm bridge detect\n");
 
-	return anx7625_sink_detect(ctx);
+	status = anx7625_sink_detect(ctx);
+	anx7625_audio_update_connector_status(ctx, status);
+	return status;
 }
 
 static const struct drm_edid *anx7625_bridge_edid_read(struct drm_bridge *bridge,
-- 
2.43.0



