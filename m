Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963603A542B;
	Sat, 17 Oct 2026 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258088; cv=none; b=KvP76NR+Cr9uC9DTcwuu9k46eMtuejolT6Uv/dRFvS5dvrA1d5Rvs9i63s9N9MPhV1Td6K62cWkH5MhPx3zzpdS+8p/PCHQf1DzjqhBSv0HmF7rK0oob6AAzFO7oN4yZ1dVU9FYf9hxT4kuZs0w5YGUK6I+NbPq8oD365ILuRC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258088; c=relaxed/simple;
	bh=+8phvtZ3G9VRZH0mB6oRQUvK1sCfKSpfjekfiH7hp5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHAtcriyqMNoURMjyH0p3klfmHm2soVJHPq+BslRTPOYk/vMhLmy+OVfKm7L1FoTFajfDLPps4LmGdtQ52D/rz8mACGX2NpWKsYTAVwbVnrFmn/ha/nrZc5EDpVlwVc9UYgbWnlWfAWQttFo5qC8wZuThU/WatvMSu82Ac3kKeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnqECI0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnqECI0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038281F000C5;
	Sat, 17 Oct 2026 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258087;
	bh=jVEYqmqXFiUVoY9FWMAf10N1n06oaV6WOSpPElwcnIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnqECI0MiD6YnHqETVRZM+ik3j6AFHmWafgnzoGy58M5TUXscbfugDh3oxAYHnabL
	 3lT4zIWjePR8WwW1eBqGMWSR4xiMQsv+CB1PRmEXYDaqhA8hQUD43rHhuNdkXcYFfN
	 z8m5y0Qj8HF5jc2ieCDK/IBPuCgAtUzHD8DN7j1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Siyang Liu <Security@tencent.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0769/1674] drm/amd/display: fix a Null pointer dereference vulnerability
Date: Sat, 17 Oct 2026 17:50:41 +0200
Message-ID: <20261017160450.842475863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siyang Liu <Security@tencent.com>

[ Upstream commit 1bcf63a44381691d6192872801f830ce3250e367 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index fc9ab5f5a6081..25edc0f0f60c3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -825,17 +825,18 @@ static void dc_destruct(struct dc *dc)
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
-- 
2.53.0



