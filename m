Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93938239573;
	Tue, 26 Aug 2025 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207535; cv=none; b=C1MwgrBh+pJ9WlV5Y2tJxWgxcb4gt2VCPpT210sCLH8okFlZQr4uHirbGhvMaZ+9aVA4ISCZCX+YrOUXBzHdMQIhzVVVF+WXuUkUqEkLn4QCxuWKooaLnaVyp/jJ46979TZ/Vg+Gy9MLrNuZefIMTJ7uAj7CjLzo75PW53YarwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207535; c=relaxed/simple;
	bh=Nte42+I1cZEhUSdrfaUzXTqegPyLyt6BIiAje8oIrbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTh3BVczhgxKsaDTjNqpqBUE0a7mA7xSL6Q80pbLhKG56hHelR80oujOp5d7LfB/9/VOiDvDGFFkk0r9KoStOyDc7YZCKTux0uNTZ0KEZGApP27QvXmgxv8KI5qd290ls8RTQn32H2MfQHbFF+y1A5fC01n0YOlE3MFKf2+WkC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BL6YX9/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BL6YX9/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D081C4CEF1;
	Tue, 26 Aug 2025 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207535;
	bh=Nte42+I1cZEhUSdrfaUzXTqegPyLyt6BIiAje8oIrbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BL6YX9/tKGyRgpUUt3XFevUtZMmtgp3eRztxNhkHBWruKgN3Z46aB+7n5FfJmkYPp
	 9bSVxxjbFRiZeLvrFrQjvpUUbkcaWSyuD/n35zN7kQH4KoM8kxZcAsQ/Dc06hHQvTX
	 RiozrNunxjSh9zsCHoxqIL+vC8j/HiY1GVpi4A6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Siyang Liu <Security@tencent.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 188/457] drm/amd/display: fix a Null pointer dereference vulnerability
Date: Tue, 26 Aug 2025 13:07:52 +0200
Message-ID: <20250826110942.015562424@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Siyang Liu <Security@tencent.com>

commit 1bcf63a44381691d6192872801f830ce3250e367 upstream.

[Why]
A null pointer dereference vulnerability exists in the AMD display driver's
(DC module) cleanup function dc_destruct().
When display control context (dc->ctx) construction fails
(due to memory allocation failure), this pointer remains NULL.
During subsequent error handling when dc_destruct() is called,
there's no NULL check before dereferencing the perf_trace member
(dc->ctx->perf_trace), causing a kernel null pointer dereference crash.

[How]
Check if dc->ctx is non-NULL before dereferencing.

Link: https://lore.kernel.org/r/tencent_54FF4252EDFB6533090A491A25EEF3EDBF06@qq.com
Co-developed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
(Updated commit text and removed unnecessary error message)
Signed-off-by: Siyang Liu <Security@tencent.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9dd8e2ba268c636c240a918e0a31e6feaee19404)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -938,17 +938,18 @@ static void dc_destruct(struct dc *dc)
 	if (dc->link_srv)
 		link_destroy_link_service(&dc->link_srv);
 
-	if (dc->ctx->gpio_service)
-		dal_gpio_service_destroy(&dc->ctx->gpio_service);
+	if (dc->ctx) {
+		if (dc->ctx->gpio_service)
+			dal_gpio_service_destroy(&dc->ctx->gpio_service);
 
-	if (dc->ctx->created_bios)
-		dal_bios_parser_destroy(&dc->ctx->dc_bios);
+		if (dc->ctx->created_bios)
+			dal_bios_parser_destroy(&dc->ctx->dc_bios);
+		kfree(dc->ctx->logger);
+		dc_perf_trace_destroy(&dc->ctx->perf_trace);
 
-	kfree(dc->ctx->logger);
-	dc_perf_trace_destroy(&dc->ctx->perf_trace);
-
-	kfree(dc->ctx);
-	dc->ctx = NULL;
+		kfree(dc->ctx);
+		dc->ctx = NULL;
+	}
 
 	kfree(dc->bw_vbios);
 	dc->bw_vbios = NULL;


