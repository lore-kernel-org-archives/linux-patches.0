Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240801A256B;
	Tue, 26 Aug 2025 11:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207461; cv=none; b=HC+8NKqS8aLn9QEb333QXo/rGBl9DGdxyEKbJ42B3Sf1tsYPf5UANG7p4s17zADpwlPhFSGAHyhcT/8b+p7humhZRmp4qK5Y5ha1m+lWxWCj95hfKQSyIY9U7KAc4vgpQSqijYhEn+ZoS/j0LrmhVV52+qWQXGcUVnFQ2phvoYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207461; c=relaxed/simple;
	bh=npd1POhcwPYW197/8lwksrC42nYm19E13m9Rc5SFiD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY+jzsVLXBmCBBdMVVjeX9HBCoV/XCu9s0VOioOBZcJ1ao4tfnyg8mn4weDeLjLCQ8R8L6NLHLRCjFZfW8zoZNc+I1rgZ8PGIILfm80GQP7Wt1bi6v8f0lDUsNRnYREsCNU/owlYv5CnR0jPeqWKBcUFTAgSEm9PVS92FYx24k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lr0xG+73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lr0xG+73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8629C4CEF1;
	Tue, 26 Aug 2025 11:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207461;
	bh=npd1POhcwPYW197/8lwksrC42nYm19E13m9Rc5SFiD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lr0xG+73kwY6PZUUmEtVTk53CVduqlyNPFXDL/F5oe+hN3Ziya+JVShSIWoe1A60W
	 huSUrVYrGjdYtSR+mhDe8EFl5hhCX0vJ8H4VaUN1ZonJvqFZUw0/e3HUhIqmNhRLQR
	 ayvZXSBauSuP3N96HYhcSkkn836nE8Lp2tZft83k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 191/457] drm/amd/display: Pass up errors for reset GPU that fails to init HW
Date: Tue, 26 Aug 2025 13:07:55 +0200
Message-ID: <20250826110942.088510269@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 2b6943df54136f40aff8a6d7ba7c26724d89a0bd upstream.

[Why]
If a GPU is in reset and the hardware fails to initialize the rest of the
resume sequence shouldn't be run.

[How]
Pass error code up to caller of dm_resume().

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3343,8 +3343,10 @@ static int dm_resume(struct amdgpu_ip_bl
 		link_enc_cfg_copy(adev->dm.dc->current_state, dc_state);
 
 		r = dm_dmub_hw_init(adev);
-		if (r)
+		if (r) {
 			drm_err(adev_to_drm(adev), "DMUB interface failed to initialize: status=%d\n", r);
+			return r;
+		}
 
 		dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D0);
 		dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);


