Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91D13C07A;
	Thu, 20 Aug 2026 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238684; cv=none; b=bqrW03vldN+b9k9xz1ccfSFGWdv+frtv3kEnqD/TDS0ceYnNs2JwRW3Dco6r0voXvxdNLxut2+8QaycDTTxftDuqQ/obJ25SWi2a3Jra+PblhU0ZruJijOVl61v/1yrqikIZfixpK35ErB2IfDVBXPJMGqvGy49EVqfGa8Fn1nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238684; c=relaxed/simple;
	bh=DyVorKE0bIEsP5BnsTZ4lAoiEbzBy7V3u1GTC4ri6FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfylcxmKR+z55vvMoGh9Z70knvLfYbEdZG/zI2d2gEC3o96ADBfAnQpEeIeG2znR2vi7T/HirkqXpJwR1htkBDyauRsuxxZJuVKo/LB6wZ2AhtVKzJVhBuL0ywNaVf/rbQPo4T6gQ8d0fiaVDBoy2lsGZvqkruP4/2Pu6rbobSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7qHa0HQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7qHa0HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DC11F00A3A;
	Thu, 20 Aug 2026 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238682;
	bh=mj6nZ3NVwELk1ZhyUr+U7nvUZ4ziY9TrM6tyHFR3dfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7qHa0HQ7hcxgnLxuwMV4XnODt5I2HemecHCnhDtn/4miYaJsX/MzHet5O9Sy4rYJ
	 qhgZjviE/9D5EGhmpKa+pAtDn0nep4O7RRRqn9jjFiGoL9pJjWiY+TQYwSbJkelTzy
	 tK5HBB1fx3XN7bp2inCtZFIkKFUJ/uL7QR1A3V9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 226/228] drm/log: Fix infinite loop when scale is too large for display
Date: Thu, 20 Aug 2026 16:56:08 +0200
Message-ID: <20260820145251.952202118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit f4f2bba28df9b9aaa00262a462139dbbcdc38d9f ]

When scale is large enough that scaled_font exceeds the display
dimensions, rows or columns become 0. A columns value of 0 causes
an infinite loop in drm_log_draw_kmsg_record() because the loop
never decrements len.

Check for zero rows/columns in drm_log_setup_modeset() and return
an error, cleaning up the already allocated buffer to avoid a leak.

Fixes: 8a4b913df427 ("drm/log: Add integer scaling support")
Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patch.msgid.link/20260729084815.692944-1-oushixiong1025@163.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/clients/drm_log.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/clients/drm_log.c b/drivers/gpu/drm/clients/drm_log.c
index f23a92f826c92..467cdce57dd3e 100644
--- a/drivers/gpu/drm/clients/drm_log.c
+++ b/drivers/gpu/drm/clients/drm_log.c
@@ -218,6 +218,12 @@ static int drm_log_setup_modeset(struct drm_client_dev *client,
 	scanout->scaled_font_w = scanout->font->width * scale;
 	scanout->rows = height / scanout->scaled_font_h;
 	scanout->columns = width / scanout->scaled_font_w;
+	if (!scanout->rows || !scanout->columns) {
+		drm_client_buffer_delete(scanout->buffer);
+		scanout->buffer = NULL;
+		mode_set->fb = NULL;
+		return -EINVAL;
+	}
 	scanout->front_color = drm_draw_color_from_xrgb8888(0xffffff, format);
 	scanout->prefix_color = drm_draw_color_from_xrgb8888(0x4e9a06, format);
 	return 0;
-- 
2.53.0



