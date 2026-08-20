Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FA6381B0A;
	Thu, 20 Aug 2026 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239281; cv=none; b=KhgesPjytJZpigj9cDz3S76R14LKCAQumu1SO2AfFr0vITbD4WnektnoH+VhmJqNMAWiPHmQYWvoUo1uqUc1F5bENNo+sfK7bU0Jnhn/Kj+PocxIazAAJH4068E35dpmmxz1VgCJ3Op9jfX9cbV6P0UEfy8Co0clxHIXu7Nj1CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239281; c=relaxed/simple;
	bh=HhzbMVTNavyUoAgJ1HgYzW//phPwy7HdTuwxGLNZYNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX9Xh0TK5qTQTyl6vmwZWMOLh6WZG+BRJXJwnIp9+xWKV0zjcKB9u0cPoq4OdxVBY2tShjuddmSY9bKneEs73mbGA4NGDNnx0bU6brkXxwwwIfL2UzJMrjZUlHn2wv8fqkNAFL3cpTFdJZ6bbZdPYGwLt3uRB5uiPr97cfmuOz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqt+45cD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqt+45cD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422611F000E9;
	Thu, 20 Aug 2026 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239279;
	bh=KtpRCTamsdwV2/uBtl3sKitKd9pc04Rx1oPyh8/3nDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqt+45cDIwAJxLq1+8018WHn8x3tjiXZomZIu8lH4PbZZNY7M9G/6A3NRZIZIcStz
	 8kQoA0FDtO7J7CxLFn3MqTWs32pOTQKTeWsRuXIzIq33s5ROKkCfWoDLwkEPyHitcv
	 XTYbdhIaX4k96fmvyMmQ7G8mh0TTvG/A8NrZD6X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 213/217] drm/log: Fix infinite loop when scale is too large for display
Date: Thu, 20 Aug 2026 16:56:21 +0200
Message-ID: <20260820145244.098387493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d040b55e5badd..1e137786b36a1 100644
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



