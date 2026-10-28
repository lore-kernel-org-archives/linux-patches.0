Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215145;
	b=Yt2ANE0mYU8tZTUcQMjbYtT394iJnOuSVCX2vU9c00xGwKU6WGPXGZkC6XBaxANzRXm0
	 B8dT+aQGBZkSij4YYDvNcTcsXJET7Qb9qEnVfxBZrShvIjBl27QE1ns2z7AOcsghCZXjQ
	 bdnE+MWIeCxHsos6Ol/a5/ch7BR3d/rmga+4VFrzGxNNMw+QNX1y2fSCVRCpNk6iNIWsb
	 Kqh4gke3BSm33IRYhS8atmNRed/b3MCN5vuf4jnR+x+x6Q/EVkweEmJ8oHO5a90Vl6xh4
	 a4K3GBl399OgEI0ODZrOiQjGkRJycvg9f6RG1n696fH2ybAG6uXPbwHtAoszP+m9Q1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RK/usSm1omVIa+0ztDI1I89dEkmItwFHQtuQgZsb8xE=;
	b=yovMHO9z5+r2ZfJjFPiO43+PeL/mCOBYxW8dTCAioFqNOay+jo7x9YE4jfzzrUhTM87v
	 pk51ogqrh5X5OYrKhQgnCeyEiXi4qYMLh33yxCFm9goIO0IiRWBDSzAcbNZVnb91bR7Ji
	 INH7C1pXkhiD11zvOzcRWqiMJfQigX8x+Jo8VGbUxyiyBzmESPOIXVnhjALFkw6AmmFxi
	 Ydy0EebDxkXf3OZ+CA6XHIFJM/eEV1SX+DT4naHA3QgkiMcaazFP0EWv0DVKVfs2nBkuX
	 xl0TGGy+q8eTrg6RVq1xbg2oDtypQqjo1HvBveziMokQI9uNcRvHT0ylo7bvikoGsXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=po5O8Klz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16EE606A322;
	Wed, 28 Oct 2026 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=po5O8Klz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED0F1F01828;
	Wed, 28 Oct 2026 19:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215144;
	bh=RK/usSm1omVIa+0ztDI1I89dEkmItwFHQtuQgZsb8xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=po5O8KlzHM3yHAptYvX3t+TNlvQKODtapqSt7tEeDs5yFHw+FJ6RFD+wybQ/XMzxO
	 9g4APiq35bIkum6kiZBE5KyR/7TboTIl4hkrOfGJbVMK2IHVc7J8Pe4XP63PZUsRGb
	 VyK9eU13CN6XXZubYsRv/dmudAzBoFWJcpGWV6ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1108/1887] drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()
Date: Wed, 28 Oct 2026 17:53:24 +0100
Message-ID: <20261028170524.618462305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit e8b4d37eba05141ee01794fc6b7f2da808cee83b ]

[Why & How]
The aux_rd_interval array in struct dc_lttpr_caps is declared with
MAX_REPEATER_CNT - 1 (7) elements, indexed 0..6. However, the offset
parameter passed to dp_get_eq_aux_rd_interval() can be as large as
MAX_REPEATER_CNT (8) when a sink reports 8 LTTPR repeaters via DPCD.
This leads to an out-of-bounds read of aux_rd_interval[7] when offset
is 8.

Fix this by growing aux_rd_interval to MAX_REPEATER_CNT elements to
accommodate the full range of valid repeater counts defined by the DP
spec.

Assisted-by: GitHub Copilot:Claude claude-4-opus
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a55a458a8df37a65ffda5cf721d554a8f74f6b04)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index 6050a3469a57c..579a38478d0f8 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -403,7 +403,7 @@ struct dc_lttpr_caps {
 	uint8_t max_ext_timeout;
 	union dp_main_link_channel_coding_lttpr_cap main_link_channel_coding;
 	union dp_128b_132b_supported_lttpr_link_rates supported_128b_132b_rates;
-	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t aux_rd_interval[MAX_REPEATER_CNT];
 };
 
 struct dc_dongle_dfp_cap_ext {
-- 
2.53.0



