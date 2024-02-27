Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C3013DBBF;
	Tue, 27 Feb 2024 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040994; cv=none; b=jFD74ZimYDXXVvfeZvKRnvOLJjshhHB7S65ebLgU5HFZXmQvBSG2jfj8RKcLeyybmP2XAkka5KO/Bzts4pl21KednPwRQUzaFvIWWmG3clUPCfMeanm0Watt7tlPjmYhPD2e1MHTCVHX08bAWwSQY4AIZJHT4PxaRaG7uAUAH8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040994; c=relaxed/simple;
	bh=sgVThatTTZUnaaBJYFY5wDTHLNplK41zuH7oC4DpcpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCMW44cDlaS+Df0GwCwJrDoMs8KdSbFgST9HYAcuEljI5Sc1a39HNOrXrew1nbtT/xsHjGaNnnwXzbkHGjZFLx08L0GiMhZXojABD1b+jAs3ziIC1x9IDeLeix/M3NXg1ZThxkX5KkZNZ5m7/BaVHLa4Nn8ftNdpqJYtrRdz894=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Q05RhGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Q05RhGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23E7C433C7;
	Tue, 27 Feb 2024 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040994;
	bh=sgVThatTTZUnaaBJYFY5wDTHLNplK41zuH7oC4DpcpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Q05RhGmhcXie0vrCUPMZKjRX/iwxs4dn3D8xfVHeOalPtkSbyDPoF3tNE1I3zjfp
	 Qckxpvq3tUSFzX0UIDyP24ZIrUBRUzbKiGi8fTM/6Z9AQrSGX1J60ERXqFsLJQv//3
	 MCpdH9rnzjurN0K0z7nyzg2KiYOsZ+enHY7q7SK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 153/334] drm/amdgpu: Fix the runtime resume failure issue
Date: Tue, 27 Feb 2024 14:20:11 +0100
Message-ID: <20240227131635.393069585@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

commit bbfaf2aea7164db59739728d62d9cc91d64ff856 upstream.

Don't set power state flag when system enter runtime suspend,
or it may cause runtime resume failure issue.

Fixes: 3a9626c816db ("drm/amd: Stop evicting resources on APUs in suspend")
Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1528,6 +1528,9 @@ bool amdgpu_acpi_is_s0ix_active(struct a
  */
 void amdgpu_choose_low_power_state(struct amdgpu_device *adev)
 {
+	if (adev->in_runpm)
+		return;
+
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = true;
 	else if (amdgpu_acpi_is_s3_active(adev))


