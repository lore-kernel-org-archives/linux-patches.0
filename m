Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946FF2AF1D;
	Fri,  9 Oct 2026 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556388; cv=none; b=Xa9u35e9P6JtFdAqm6zqfswAHkvv2l93lpdoPxBSUutVE0Q0STm3pjjoYmcf8BTdpb/jq2wN+QYyWiXz1pgRMHjA8VVdQ/yBpgnh5Uo1VijJl0tvo5Wucf+a6ARFjFualqB70BR5Hm2iDnC5Z0ulbXLZn3wonwMAehXf9YG/6es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556388; c=relaxed/simple;
	bh=gtUg+fsJrwlOrC33B9bFwkhi6Q884SMLXCqyjmK8IG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICRiFebwIfhsA9Vu4BqG/2lxFAtH7cV44DkEwPX3vVG9YCy+3nBPMpUZfpkAYtLQySnMeJ03jc/eev2JKiPVoiH3l9Mb1RXNCIAPgqcW6p5e82S2WQZfcRDufrebsdJCMFyHyqnd6VLS8H10UqfopW4H96KwJjZdqPAvb62xkAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGIc2aD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGIc2aD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F2E1F000FF;
	Fri,  9 Oct 2026 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556387;
	bh=dHUqM/i95iR7ULly+Ohzim4INYLw2LdVqZJRwAzYuQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGIc2aD+vNiOIWtUy/SVCQJAcyhg5MsJAv6jGwUGUo7F1IKKuHz4d1+A8PGA3i0Aa
	 GUK7Z/FMRW+UHv+8fu3G3bk34zEZf1qJWTKd+5kECi7jjq+6Z5PK03l8H4iGWhBjlt
	 /GP22vTiUfzdAebOHF0/FMIT3tfvw/gidjtCeAo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 168/428] drm/amd/display: guard dc_sink dereferences in MST mode validation
Date: Fri,  9 Oct 2026 16:08:25 +0200
Message-ID: <20261009140949.845421912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Mishal <harimishal1@gmail.com>

commit 217f64f348c90cba62164e7ff38e0ccf78a5ca09 upstream.

dm_dp_mst_is_port_support_mode() reads
aconnector->dc_sink->dsc_caps... for the DSC branch-throughput check,
and get_conv_frl_bw()'s HDMI-PCON FRL-bandwidth path reads
aconnector->dc_sink->edid_caps.max_frl_rate, both without a NULL
check. dc_sink is cleared asynchronously on MST unplug, and both
functions run from paths that the driver's own comments document as
racing that teardown: the connector probe worker's ->mode_valid
callback and a compositor's atomic check, neither of which holds the
MST manager lock that the teardown path uses. The former does have an
existing dsc_aux NULL check, but dsc_aux isn't reliably cleared in
every path that clears dc_sink, so it doesn't cover this.

Fail the port-support check and skip the FRL conversion path when the
sink is already gone.

Fixes: f04d275d94e1 ("drm/amd/display: add mst port output bw check")
Fixes: 5c9b8b27a883 ("drm/amd/display: Tie FRL support into amdgpu_dm")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7c3db8da4e039698ae198c870712428644e965c7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1181,7 +1181,8 @@ static bool get_conv_frl_bw(struct amdgp
 	unsigned int max_sink_bw_in_kbps = 0;
 	unsigned int dsc_max_sink_bw_in_kbps = 0;
 
-	if (aconnector->dc_link->dc->caps.dp_hdmi21_pcon_support &&
+	if (aconnector->dc_sink &&
+	    aconnector->dc_link->dc->caps.dp_hdmi21_pcon_support &&
 	    aconnector->mst_downstream_port_caps.bytes.byte0.bits.DWN_STRM_PORTX_TYPE == DOWN_STREAM_DETAILED_HDMI) {
 		max_conv_bw_in_kbps = dc_link_bw_kbps_from_raw_frl_link_rate_data(
 				aconnector->dc_link->dc,
@@ -1946,6 +1947,9 @@ enum dc_status dm_dp_mst_is_port_support
 	struct dc_dsc_config_options dsc_options = {0};
 	uint32_t stream_kbps;
 
+	if (!aconnector->dc_sink)
+		return DC_FAIL_BANDWIDTH_VALIDATE;
+
 	/* DSC unnecessary case
 	 * Check if timing could be supported within end-to-end BW
 	 */


