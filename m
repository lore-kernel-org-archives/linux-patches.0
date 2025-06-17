Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40533236453;
	Tue, 17 Jun 2025 16:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178773; cv=none; b=fD9JlT/hyTfKat9Uim31VgycmvGXOwwxulgqGqAds0kpdw17bKnBetcLGyneSXQadXMbk9BUbK0NQRQJi4y4EpqA1MXULZz1f6Jy/a4U+J0I+iORvRpshXVXt63mD+LrBIPkysyjuDOiiALqN/g+YkzAPjVmL27hizd9DsjebUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178773; c=relaxed/simple;
	bh=hJcfa3pxwvHP+0ivW8gOWmZ27Pj5xAFH8i1Y+PmKkko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM4kdUK5NLjIQigO/iQtYAjnLOo29ybbz9wLM8WaXh/Pk8sxbpDKM3AGQNJC4Z9AsLx/7/sM0QOrA2+e983FI+vVTquGvfJEUpqL6J9kBOX7wdn+xo5Rro2rly6PDiJRoQH7QffRDtUqMJaahdGP83MG57mY2sKQsThMdb1BDw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2lJ28Og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2lJ28Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77ACC4CEE3;
	Tue, 17 Jun 2025 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178773;
	bh=hJcfa3pxwvHP+0ivW8gOWmZ27Pj5xAFH8i1Y+PmKkko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2lJ28OgUoRt0SAgdmphxd3UY6SaIkhjWZSDg5gyC6eOgZScsRTV26+UF2LYWqWIW
	 TmJIGazvQyhvJOp5xxKchOBNusDd1eApKCV6UkoIxVH7SKzP+SobSSLgfQyZ7bkJnT
	 G+zFv4oZDDTkqALvyb0pT88YO/5kIAHPuYZ4RltM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 550/780] drm/connector: only call HDMI audio helper plugged cb if non-null
Date: Tue, 17 Jun 2025 17:24:18 +0200
Message-ID: <20250617152513.904150308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit be9b3f9a54101c19226c25ba7163d291183777a0 ]

On driver remove, sound/soc/codecs/hdmi-codec.c calls the plugged_cb
with NULL as the callback function and codec_dev, as seen in its
hdmi_remove function.

The HDMI audio helper then happily tries calling said null function
pointer, and produces an Oops as a result.

Fix this by only executing the callback if fn is non-null. This means
the .plugged_cb and .plugged_cb_dev members still get appropriately
cleared.

Fixes: baf616647fe6 ("drm/connector: implement generic HDMI audio helpers")
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250527-hdmi-audio-helper-remove-fix-v1-1-6cf77de364d8@collabora.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_hdmi_audio_helper.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_hdmi_audio_helper.c b/drivers/gpu/drm/display/drm_hdmi_audio_helper.c
index 05afc9f0bdd6b..ae8a0cf595fc6 100644
--- a/drivers/gpu/drm/display/drm_hdmi_audio_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_audio_helper.c
@@ -103,7 +103,8 @@ static int drm_connector_hdmi_audio_hook_plugged_cb(struct device *dev,
 	connector->hdmi_audio.plugged_cb = fn;
 	connector->hdmi_audio.plugged_cb_dev = codec_dev;
 
-	fn(codec_dev, connector->hdmi_audio.last_state);
+	if (fn)
+		fn(codec_dev, connector->hdmi_audio.last_state);
 
 	mutex_unlock(&connector->hdmi_audio.lock);
 
-- 
2.39.5



