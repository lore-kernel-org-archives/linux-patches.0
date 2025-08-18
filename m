Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A397E286D5E;
	Mon, 18 Aug 2025 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522270; cv=none; b=EfR2JE+c0E7AQwcpHRY0KnsNE+1NnYJB4FauWk1FxYN+fcyb9UvoQ0w8g957kcYZMFTQZHBwbef4qHFpGpe32xf6HNfflBE3vgqcWuMAldmXRfc2Yy4zOLUOHe/iAk5sxDXt4kMQGBJw4Nyf2V8vqsz8XrGApLnyXWSq1rMCZOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522270; c=relaxed/simple;
	bh=RJnjOX2YKVcAL4GVU0EqHwK0pEXv+VunDCq0hWQDM3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgA3ePO5LbPVn0/YQ/UD2iL40j9KsWFdUyhj8GFIrz3D6hDMymlwmjFp+Z9RUYi+pzKj6CcR/tP9yJsgZSztnLsFxgkWMzbcxZfYqpINTxNQWi8h/ccTiUXH4EylIaDt6dMWAIPckTV2ohV4W3+bnNb1kUsPKbLw7YIEt8VyZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtT4tg0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtT4tg0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD10BC4CEF1;
	Mon, 18 Aug 2025 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522270;
	bh=RJnjOX2YKVcAL4GVU0EqHwK0pEXv+VunDCq0hWQDM3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtT4tg0OrzOPlQrJzUlGBhUFzxGw5byKzG0j1Bthm3puD4pObdeYbUVzzFyD+Jd3s
	 h6/XMP9OrlAokOFGKG3WAWPFYTb1oyVCuyFOU4qrTt9RNr/XIrz/aFyoTeQZiMIgnL
	 D2E2JBivvRCmHhmqPOLABDcM30stVboCVcfV2EvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/444] drm/amd/display: Avoid trying AUX transactions on disconnected ports
Date: Mon, 18 Aug 2025 14:44:53 +0200
Message-ID: <20250818124458.844180952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit deb24e64c8881c462b29e2c69afd9e6669058be5 ]

[Why & How]
Observe that we try to access DPCD 0x600h of disconnected DP ports.
In order not to wasting time on retrying these ports, call
dpcd_write_rx_power_ctrl() after checking its connection status.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index aa2800129767..9d740659521a 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -140,7 +140,8 @@ void link_blank_dp_stream(struct dc_link *link, bool hw_init)
 				}
 		}
 
-		if ((!link->wa_flags.dp_keep_receiver_powered) || hw_init)
+		if (((!link->wa_flags.dp_keep_receiver_powered) || hw_init) &&
+			(link->type != dc_connection_none))
 			dpcd_write_rx_power_ctrl(link, false);
 	}
 }
-- 
2.39.5



