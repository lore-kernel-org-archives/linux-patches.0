Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CB8466B77;
	Tue, 16 Jun 2026 16:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626322; cv=none; b=gozTi5GussMYF0I99sKylGNdWec4h3sZ1Gz/JzGtosSFMBRPwcEC75+I6Da4MzqPNL/sU51eU5i/leLEUZeUpeKAy0JpBS8Wa1UJe2uzEaHffB8bxrMsTrJiL65+xXiT20NgOz6zZS1ahiYZAgeQtfi9btxc8J3akmUgnH1DkVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626322; c=relaxed/simple;
	bh=6dHzV1ydSOWRCaO+LfnR8iA6QF66T8nU3GKibcU/7m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUizjs0nwbOAGhJ5fQ8jWvgi8XBP9+sEVIyFhq1j/Ui6+8WucD8MVTA8OSsVbvKjur+MXymcmMnYX8YeJXii4SGpP9CBsql4ADNZJsSdrk3InS8Jo1fArNiyPo8ssyJo9bvFDsQ/tDNB6CCV87YsIy+3pyEMsRoiwApyhVhk/vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9Q9Ve12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9Q9Ve12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B4D1F000E9;
	Tue, 16 Jun 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626321;
	bh=8QQGUhMTNiNc0Z2QttLNLD90uaYktQVIYIr7gZ7l0d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9Q9Ve12SwUQ3Iy/vW1emP61rKr1cONFE8/Qr0mnuAZbgXak3C6IllTVy/TC1GNLI
	 MYlgqIjfr4ZV1xtebWBwOP+iJRwLpuH5RV/abeX365zaVXgfCpfrSBhj5yuukU0VOh
	 HXvnK2Y0Jca7GX+2X2AQoKJ5j/u2PcIOhJ/rQ74c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 302/325] drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()
Date: Tue, 16 Jun 2026 20:31:38 +0530
Message-ID: <20260616145113.985927946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit e8b4d37eba05141ee01794fc6b7f2da808cee83b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -1188,7 +1188,7 @@ struct dc_lttpr_caps {
 	union dp_main_link_channel_coding_lttpr_cap main_link_channel_coding;
 	union dp_128b_132b_supported_lttpr_link_rates supported_128b_132b_rates;
 	union dp_alpm_lttpr_cap alpm;
-	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t aux_rd_interval[MAX_REPEATER_CNT];
 	uint8_t lttpr_ieee_oui[3]; // Always read from closest LTTPR to host
 	uint8_t lttpr_device_id[6]; // Always read from closest LTTPR to host
 };


