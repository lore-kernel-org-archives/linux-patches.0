Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3E92949F5;
	Wed, 30 Jul 2025 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869295; cv=none; b=klSBWt3nnDFb5/sNiIF3JICvh3rdHJzdlYmIiJ4ewq1OVKjgcF7BbywcZ9Xf2ptKPOEiFxVtiIa0mkRYBu7IuWPK7LesjJHAgQX48dX3X2Wxmhn0mrhx99RVCy02YE1fd60SnkysSAPiraefz2NUJnfzco+3KxQiZLyZlm/SVbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869295; c=relaxed/simple;
	bh=LNXZvdFdO5D297rnt457a3EvIx/MfylF87Na5eb5pmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxxVAzwLhzfwMCS0T0rFx53ehNvmGnCDECFWWMPyZTk+Iey3bbNkZXWCNaHUaHvgVPB93AO9IzmU21oSTqr/+R6SOyMvrcCDev2FyX0J+WlsASEOZmXoRpIR7hiDFpzkohS3+REeoku8HKQfSLARJB/0ePKtTKHRfMCYeHx8obY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCF3SeS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCF3SeS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FD0C4CEF9;
	Wed, 30 Jul 2025 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869294;
	bh=LNXZvdFdO5D297rnt457a3EvIx/MfylF87Na5eb5pmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCF3SeS7zzEVjEDx2/CbQvtUH8Yhjbf4zzHiFcF+nL5eC4fcHvu9UkW1XdzKnjZJI
	 tRh3eMxAb7EswvFNwwlc6s13xyGUt4ktrzGxX48f1ZFOp6vnWIHmOM907IyEHBElab
	 avvcTN4DZtxbC4iRnYtlg79vIpuHlWjsmP6V+5Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 84/92] drm/amdgpu: Fix SDMA engine reset with logical instance ID
Date: Wed, 30 Jul 2025 11:36:32 +0200
Message-ID: <20250730093233.998230830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

commit 09b585592fa481384597c81388733aed4a04dd05 upstream.

This commit makes the following improvements to SDMA engine reset handling:

1. Clarifies in the function documentation that instance_id refers to a logical ID
2. Adds conversion from logical to physical instance ID before performing reset
   using GET_INST(SDMA0, instance_id) macro
3. Improves error messaging to indicate when a logical instance reset fails
4. Adds better code organization with blank lines for readability

The change ensures proper SDMA engine reset by using the correct physical
instance ID while maintaining the logical ID interface for callers.

V2: Remove harvest_config check and convert directly to physical instance (Lijo)

Suggested-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5efa6217c239ed1ceec0f0414f9b6f6927387dfc)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
@@ -572,8 +572,10 @@ static int amdgpu_sdma_soft_reset(struct
 	case IP_VERSION(4, 4, 2):
 	case IP_VERSION(4, 4, 4):
 	case IP_VERSION(4, 4, 5):
-		/* For SDMA 4.x, use the existing DPM interface for backward compatibility */
-		r = amdgpu_dpm_reset_sdma(adev, 1 << instance_id);
+		/* For SDMA 4.x, use the existing DPM interface for backward compatibility,
+		 * we need to convert the logical instance ID to physical instance ID before reset.
+		 */
+		r = amdgpu_dpm_reset_sdma(adev, 1 << GET_INST(SDMA0, instance_id));
 		break;
 	case IP_VERSION(5, 0, 0):
 	case IP_VERSION(5, 0, 1):
@@ -600,7 +602,7 @@ static int amdgpu_sdma_soft_reset(struct
 /**
  * amdgpu_sdma_reset_engine - Reset a specific SDMA engine
  * @adev: Pointer to the AMDGPU device
- * @instance_id: ID of the SDMA engine instance to reset
+ * @instance_id: Logical ID of the SDMA engine instance to reset
  *
  * This function performs the following steps:
  * 1. Calls all registered pre_reset callbacks to allow KFD and AMDGPU to save their state.
@@ -649,7 +651,7 @@ int amdgpu_sdma_reset_engine(struct amdg
 	/* Perform the SDMA reset for the specified instance */
 	ret = amdgpu_sdma_soft_reset(adev, instance_id);
 	if (ret) {
-		dev_err(adev->dev, "Failed to reset SDMA instance %u\n", instance_id);
+		dev_err(adev->dev, "Failed to reset SDMA logical instance %u\n", instance_id);
 		goto exit;
 	}
 


