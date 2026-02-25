Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA24025A642;
	Wed, 25 Feb 2026 01:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983656; cv=none; b=ERx6fnj7aceZCnmVK4uN4++TcO5VTNJPKeiiDScjcvR0B0jNTevLsUKv7TuuY1OeWutjJJaOeobxkL3eiY4+Sm1kH87P1VXTBoVz3sbgc6kA6LKkNmF8P5HVRd/k0dc9FGBNO6s49AsBEfdnjdrH6hacnOiA+jzsMh61iQJvc0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983656; c=relaxed/simple;
	bh=WLaBuml/7bKbvKA0lBEHyKv7hWbyeJtT/qIcEK5xyWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3V+aBEjhsPOydub9XetcUj2GOU0+CKYtKF2rzrDOqFtF+MYcLyhKQmPV7pZF4nZcFu3Ha8MBFURvtYblzBWeMTEOTR0Dq0m6PMaNBa48LYwlNhJfg2RzXv3REBu7NuH3/CRLn9bsJgROWf1yXKoEzsRlrbbZBHefZBX4CKvK4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueYQZO4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueYQZO4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98A2C116D0;
	Wed, 25 Feb 2026 01:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983655;
	bh=WLaBuml/7bKbvKA0lBEHyKv7hWbyeJtT/qIcEK5xyWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueYQZO4kU/HqS4ZLJ0JwMfGHluQJlPQeWyZl+cQccp4G+R9eTQPj1DJTfeHF8YkCI
	 +ZLzaUsoY9f9QA5kb+xPYqGHNKQU8Yz/TrmW0sW4r4YvxtfJKOCvlnnJq6T7nOV2ko
	 e0Lw+TgZkK0Rgr0T9js5W5RSSh1yZ5viaBSZS/WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 741/781] drm/amd/display: Only use analog stream encoder with analog engine
Date: Tue, 24 Feb 2026 17:24:10 -0800
Message-ID: <20260225012417.903148664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 17ff034f805e032ed1358624a71381f9d6e29e9e ]

Some GPUs have analog connectors that work with a DP bridge chip
and don't actually have an internal DAC: Those should not use
the analog stream encoders.

Fixes: 5834c33fd3f6 ("drm/amd/display: Add concept of analog encoders (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
index a916872db7bd4..83b9abb64bfcb 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
@@ -979,7 +979,10 @@ struct stream_encoder *dce100_find_first_free_match_stream_enc_for_link(
 	struct dc_link *link = stream->link;
 	enum engine_id preferred_engine = link->link_enc->preferred_engine;
 
-	if (dc_is_rgb_signal(stream->signal))
+	/* Prefer analog engine if the link encoder has one.
+	 * Otherwise, it's an external encoder.
+	 */
+	if (dc_is_rgb_signal(stream->signal) && link->link_enc->analog_engine != ENGINE_ID_UNKNOWN)
 		preferred_engine = link->link_enc->analog_engine;
 
 	for (i = 0; i < pool->stream_enc_count; i++) {
-- 
2.51.0



