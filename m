Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351C31DB92A;
	Tue, 12 Aug 2025 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023720; cv=none; b=IKWuV04aIJXlQg2htj4SwqHjkb0YnsFNg6vzNxN+M412QShWFbfFIrUT2Y0TESnUtm9DhPqvl0GXDsyKii1YUDY7+PVTNJhqDtbE5eXTYifQeARBxxbQauKOgzcYuMu2LK4i1nAlRGCRYfhIy/RXeycYjhoLuc88N3xfMDo0p+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023720; c=relaxed/simple;
	bh=YhBgzSiV7LqaxMErEtnJXm/0J5MXTHYQNHOWr9L1AHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4lJE7LO8w+ztDpRygoJQO0UZezyg8CXCheWXJvC6GDKjYiVOrKGDg38wajojdBBtjJVVLm3rDAHSbWs8ppJ1JkjK8Q2P+U9Q4nqtE4tTn5qvqzwPpcSkqojBSo4aeQb9rEwIBXWuwEyL7+EHcMSYz0U5xrGm5N0M1QsUrgFfqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEh6BKbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEh6BKbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B94C4CEF0;
	Tue, 12 Aug 2025 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023717;
	bh=YhBgzSiV7LqaxMErEtnJXm/0J5MXTHYQNHOWr9L1AHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEh6BKboeKtaANtZa69jYbrrWIKa/gQbhMhqHilti+1LB6Pzm2u2mwN2mxbmwUPLj
	 pWWEfnkEzC0qxmu3PqUEfA3V633frKCQvAJMDrVy5AwT5ljChvp7J/YhZcpPGU2CM6
	 7C+atAUh/W8QfpjNxClJLkqkPb8EvyhWyLaZjieA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <lumag@kernel.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 134/627] drm/connector: hdmi: Evaluate limited range after computing format
Date: Tue, 12 Aug 2025 19:27:09 +0200
Message-ID: <20250812173424.407951551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 21f627139652dd8329a88e281df6600f3866d238 ]

Evaluating the requirement to use a limited RGB quantization range
involves a verification of the output format, among others, but this is
currently performed before actually computing the format, hence relying
on the old connector state.

Move the call to hdmi_is_limited_range() after hdmi_compute_config() to
ensure the verification is done on the updated output format.

Fixes: 027d43590649 ("drm/connector: hdmi: Add RGB Quantization Range to the connector state")
Reviewed-by: Dmitry Baryshkov <lumag@kernel.org>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20250527-hdmi-conn-yuv-v5-1-74c9c4a8ac0c@collabora.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_hdmi_state_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_hdmi_state_helper.c b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
index d9d9948b29e9..45b154c8abb2 100644
--- a/drivers/gpu/drm/display/drm_hdmi_state_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
@@ -798,12 +798,12 @@ int drm_atomic_helper_connector_hdmi_check(struct drm_connector *connector,
 	if (!new_conn_state->crtc || !new_conn_state->best_encoder)
 		return 0;
 
-	new_conn_state->hdmi.is_limited_range = hdmi_is_limited_range(connector, new_conn_state);
-
 	ret = hdmi_compute_config(connector, new_conn_state, mode);
 	if (ret)
 		return ret;
 
+	new_conn_state->hdmi.is_limited_range = hdmi_is_limited_range(connector, new_conn_state);
+
 	ret = hdmi_generate_infoframes(connector, new_conn_state);
 	if (ret)
 		return ret;
-- 
2.39.5



