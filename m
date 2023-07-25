Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B72D1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B053FC433C7;
	Tue, 25 Jul 2023 11:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283278;
	bh=6W9tot0dUX7fqx9qMlA4fid9QiWn43P2mpeBPjyr2hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpqXxbhuO3T4uOevCjKj5iAmcqsI9xxXnSuqZyjU73O3R2wD8kh8yCQHr20d+1esw
	 IlKryVakKmsFysA14gETzP3kjRFrLfmLG/jS1krXnCq1m8HVkSGFtlD9B/sgS/qsSE
	 udP2NJSAkwTWUQp0ZTJ6bKA1vJjUBtESxzHvIqZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Josip Pavic <josip.pavic@amd.com>,
	Alan Liu <haoping.liu@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.15 19/78] drm/amd/display: Keep PHY active for DP displays on DCN31
Date: Tue, 25 Jul 2023 12:46:10 +0200
Message-ID: <20230725104452.074402960@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 2387ccf43e3c6cb5dbd757c5ef410cca9f14b971 upstream.

[Why & How]
Port of a change that went into DCN314 to keep the PHY enabled
when we have a connected and active DP display.

The PHY can hang if PHY refclk is disabled inadvertently.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Josip Pavic <josip.pavic@amd.com>
Acked-by: Alan Liu <haoping.liu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -81,6 +81,11 @@ int dcn31_get_active_display_cnt_wa(
 				stream->signal == SIGNAL_TYPE_DVI_SINGLE_LINK ||
 				stream->signal == SIGNAL_TYPE_DVI_DUAL_LINK)
 			tmds_present = true;
+
+		/* Checking stream / link detection ensuring that PHY is active*/
+		if (dc_is_dp_signal(stream->signal) && !stream->dpms_off)
+			display_count++;
+
 	}
 
 	for (i = 0; i < dc->link_count; i++) {


