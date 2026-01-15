Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FC72C028F;
	Thu, 15 Jan 2026 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496443; cv=none; b=PcA/L1o2cCKqM3wyGtiXBCE+qOJmx5z3b/rdiujH/HumUT6H0AVupVRgaZ0/8cPMftpqn75oPQ2PiJ7gOQnuZhpN14kN2wABiAgha75FBhU+4ecfgv2Xwkbu2nNGUKB/pHOUQOAWZk8+zawAbCO+8vkrSjz4VT/FZHBEy3ZnGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496443; c=relaxed/simple;
	bh=DS7dYTSjAN/bA/OoZMVAJnsnRivWRlF6wY/DMJYpQ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reUxBRT9hDqtRndEqK6BaU/YYZWQVCX7+9oJbOjWAv2L2jqd6k5sPjD9mnRyBIUKY8aRMXtS+Ii+PQsZlt3ZsE8KHWz3CmV7sd466S6mSoKo7NoRH7PmADYQdrG9H9kd/AQYDwsJMyDL588SDBMj/4rlA3mtyxg6+WgvWx83B98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XevD2Z/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XevD2Z/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA91DC116D0;
	Thu, 15 Jan 2026 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496443;
	bh=DS7dYTSjAN/bA/OoZMVAJnsnRivWRlF6wY/DMJYpQ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XevD2Z/wrNFuzq/+jQ8bDLJnMXL+Z4P4NWDlb/ye6oDt86P5gD9IpHOx9DkB/qVmL
	 g78XkZZUvSPJV6xw5hA3z+vT4EOn07jRSyFdPe4yua4/8RpeZ9W0X84ZlP6uRNDkW7
	 w6nY3aQKL/Lva8nIfbcdOAL07ged1TZ/0Bk3O9SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	Alan Liu <haoping.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 015/119] drm/amdgpu: Fix query for VPE block_type and ip_count
Date: Thu, 15 Jan 2026 17:47:10 +0100
Message-ID: <20260115164152.513120608@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Liu <haoping.liu@amd.com>

commit 72d7f4573660287f1b66c30319efecd6fcde92ee upstream.

[Why]
Query for VPE block_type and ip_count is missing.

[How]
Add VPE case in ip_block_type and hw_ip_count query.

Reviewed-by: Lang Yu <lang.yu@amd.com>
Signed-off-by: Alan Liu <haoping.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a6ea0a430aca5932b9c75d8e38deeb45665dd2ae)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -200,6 +200,9 @@ static enum amd_ip_block_type
 		type = (amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_JPEG)) ?
 				   AMD_IP_BLOCK_TYPE_JPEG : AMD_IP_BLOCK_TYPE_VCN;
 		break;
+	case AMDGPU_HW_IP_VPE:
+		type = AMD_IP_BLOCK_TYPE_VPE;
+		break;
 	default:
 		type = AMD_IP_BLOCK_TYPE_NUM;
 		break;
@@ -670,6 +673,9 @@ int amdgpu_info_ioctl(struct drm_device
 		case AMD_IP_BLOCK_TYPE_UVD:
 			count = adev->uvd.num_uvd_inst;
 			break;
+		case AMD_IP_BLOCK_TYPE_VPE:
+			count = adev->vpe.num_instances;
+			break;
 		/* For all other IP block types not listed in the switch statement
 		 * the ip status is valid here and the instance count is one.
 		 */


