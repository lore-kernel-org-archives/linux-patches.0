Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089821D1517;
	Wed,  2 Oct 2024 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878673; cv=none; b=FCk8SZDPLBurj71enY4Co7qJYy9Im5WBZtlfHUPBxBWVDsWl9LW7KQ76Nr9x8gyMSFY4FIhPXXP1Dln/umqAIB+Gf96gharAxp5p/rJsCDfaPe0LXZ5amuWMSukoi9CQXuzOn1yv6wRK2YoA7cCDRYlSi99b9TuvTy9r0HyrCHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878673; c=relaxed/simple;
	bh=tY+rFKoEx31Sfe5nu5REuiQ9tulJrn3tRBsSSUOpZtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8oDlR8Ilmp0wNbGfhECeLYJRw9wKOepVL2G+ORW4yVMSA2Drg7W/nc3k+qpgfMBdTmr2NPgADkMzygwKue1GGX+qcy1NcJZavIqIFVFR1c5nsx2zLkf47YPpp1XqQ/j9SOsr+0ccDjZjZmCrn4NiVDyaqn3CQWmyYqTX4YsEXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBMkU/m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBMkU/m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83160C4CEC2;
	Wed,  2 Oct 2024 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878672;
	bh=tY+rFKoEx31Sfe5nu5REuiQ9tulJrn3tRBsSSUOpZtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBMkU/m6hL7PEtZLkOQHzqorZ1sfQmjsgOpthEh488QmdpheAgPYnFU2ZwuosuJck
	 n9tIgwH/bRim7byUnLmP8C9HUCksB1nxNXdgXchtR8aNuRpfXh7hdWXntul+r/J6f1
	 fJgMClHz7POdvlEaiXeRhVFVrCwLPXHEHFov2Jgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 493/634] drm/amd/display: Round calculated vtotal
Date: Wed,  2 Oct 2024 14:59:53 +0200
Message-ID: <20241002125830.559637016@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Chen <robin.chen@amd.com>

commit c03fca619fc687338a3b6511fdbed94096abdf79 upstream.

[WHY]
The calculated vtotal may has 1 line deviation. To get precisely
vtotal number, round the vtotal result.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -134,7 +134,7 @@ unsigned int mod_freesync_calc_v_total_f
 
 	v_total = div64_u64(div64_u64(((unsigned long long)(
 			frame_duration_in_ns) * (stream->timing.pix_clk_100hz / 10)),
-			stream->timing.h_total), 1000000);
+			stream->timing.h_total) + 500000, 1000000);
 
 	/* v_total cannot be less than nominal */
 	if (v_total < stream->timing.v_total) {


