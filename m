Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C59393DD1;
	Tue, 26 Aug 2025 11:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208482; cv=none; b=dyZDWLc0ybVOSrkwRkYi92TxzbWYpE0MRAcmMrPjvsatuAzRpIme2d8aU2Zb+hOX3uogF3z2MULIFqtwQY2lbIx+A66z6jDdHaZ3wdH/W48/XCHlKZ9KUnJPaUUjkIx2louj4xbmTSRdxFzPJr/S5OqErRlkuxyS3AESuuZcBxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208482; c=relaxed/simple;
	bh=yAxXU9t8Rw0O1oPRPDTxYktdeSKjr94luINAahIfgMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npLGBZJxelgzPURD8p419GlH8ZUdVNlhDghJ4WUJ/aroF9b8GnzLjNVZ1oNBJGJvU39z2gfDgq76nBVEk+apHzT0XuAMHeCIqMcq20rXk6ZV0XBOrwQkexGx7Poq9LSgE9N9OPrVYZJlMuyy1oT8ZPdYh1wMHr1UpF+8bnTxnug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIMawy56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIMawy56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CC3C4CEF1;
	Tue, 26 Aug 2025 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208482;
	bh=yAxXU9t8Rw0O1oPRPDTxYktdeSKjr94luINAahIfgMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIMawy56X2+ljBYrYdveNI3xGdJ7+yzpxzZ0Fsx2tLC9klpdhGc0OUIoOLmKuPlTv
	 tPwbcUa3pu0M1igeJ3dUIXa7yPm7qTRrPw5N40pPvw4PPwR2jCw9VHdwmESgnr8Exw
	 YTGa3MSC66HYddqITAhne3G4ZZunj4bbQMOleG4U=
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
Subject: [PATCH 6.12 128/322] drm/amd/display: fix a Null pointer dereference vulnerability
Date: Tue, 26 Aug 2025 13:09:03 +0200
Message-ID: <20250826110918.960699926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -890,17 +890,18 @@ static void dc_destruct(struct dc *dc)
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


