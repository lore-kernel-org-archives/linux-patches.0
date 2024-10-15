Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F397F1EABB9;
	Tue, 15 Oct 2024 11:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993133; cv=none; b=j0sHUuDBmAc/Tu2SKSyuG0pbBfM6Hx6XyVysHSD8GeVb7ZuVsk4M/YpFm23Hf1cW3gYyg+0RGX1WUXzMOt49VSbaDzYQlWeAMfDRvlc0a0EhP3+ojbxRzYGfKF2LeWULcUqUTEbSwirgJvwz1QXZEZprQa2DZ5FoZ5n2b1OMHRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993133; c=relaxed/simple;
	bh=lyPXRuWHNtFmZMHhFyJDWnPtCs36zrf8XKSxf0uAr9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5zfjYtN4uJBAxr0IuEAh7K/XItzg0a66M7J4WPSlByy2GqagyM1f+DLQH8ilDpNk62ApUi3wNMjILkKGv/J7XH7KFL9ktDEPQS1vWep4pTy2tighglgKLwNIO6lHmAxxbi38TkVSeeDEquO98a4B1gUwhn8HVVcANXpnepyyCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zL56+JIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zL56+JIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63609C4CEC6;
	Tue, 15 Oct 2024 11:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993132;
	bh=lyPXRuWHNtFmZMHhFyJDWnPtCs36zrf8XKSxf0uAr9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zL56+JIPXjKlJFj0+paFgLqpg9VXDK0Hmz8W3P0KKwYG8XBjplURnY1rIpu6InE3Q
	 MeO1/4ow6/nmiL1eeJO4u374w7geXdMvRvIQ6jDrxvJmFgndlFzHyiiUkCkLvxp5KW
	 2MGNRlOo+9J4hUhFSxqSDzdQcM2DEXHPup0VBmTc=
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
Subject: [PATCH 5.15 313/691] drm/amd/display: Round calculated vtotal
Date: Tue, 15 Oct 2024 13:24:21 +0200
Message-ID: <20241015112452.760052114@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,7 +131,7 @@ unsigned int mod_freesync_calc_v_total_f
 
 	v_total = div64_u64(div64_u64(((unsigned long long)(
 			frame_duration_in_ns) * (stream->timing.pix_clk_100hz / 10)),
-			stream->timing.h_total), 1000000);
+			stream->timing.h_total) + 500000, 1000000);
 
 	/* v_total cannot be less than nominal */
 	if (v_total < stream->timing.v_total) {


