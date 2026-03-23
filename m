Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170F826B2DA;
	Mon, 23 Mar 2026 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278522; cv=none; b=cliUvVzkrXRm447oAI2mOgFjvlUc4m2EqTKL1hJ4Jmf9I1E7y5+85oTYBOYYN59SxKNNbyb+PHXKH2QjITZwXDjoUnt80qGA1CRTjvLF4WVmYfpzfv/P538MrTEapQ9V1ve8Qw/eAyUiESZl18NybGKxhhMyulewHsz0pq4GVu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278522; c=relaxed/simple;
	bh=02x4H+wsAEBwvY19ZC35QDU6QepqtuZWbxRruIu71fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig0XN9yEC6WiVPkdkBtvNdVgulhhldv8XeDgL5PFVmx5AOWWLNoQtlF64hAlXVlVIxEdXP3e9quKQa0PmbKMS56Rs62ZqmR3pynfDUZ8fZ0ze4Bm9U9P5XEGTpisB3x+FNS/mXCw3zM+eUKKVGqfGIjHGP8z+DELfHUrGJY78TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYQpQF+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYQpQF+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A74C4CEF7;
	Mon, 23 Mar 2026 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278522;
	bh=02x4H+wsAEBwvY19ZC35QDU6QepqtuZWbxRruIu71fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYQpQF+XgqNDZUpSm+6oq/cz9f1e0vkBRhKys4J81zfTfZ0oRmq3stioPSMfMI+e2
	 /nXw+OQCldqxgd0Sr10q0JrBdQo1k7qGmuqZeI1kFlXO51jOK0Ec19Ek4BOBCtKqJ3
	 xcCOcn2ntLzFvbjwvpK/827lfl8RqV7p/Yd0eEkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 335/567] drm/amd: Set num IP blocks to 0 if discovery fails
Date: Mon, 23 Mar 2026 14:44:15 +0100
Message-ID: <20260323134542.120567320@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3646ff28780b4c52c5b5081443199e7a430110e5 upstream.

If discovery has failed for any reason (such as no support for a block)
then there is no need to unwind all the IP blocks in fini. In this
condition there can actually be failures during the unwind too.

Reset num_ip_blocks to zero during failure path and skip the unnecessary
cleanup path.

Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fae5984296b981c8cc3acca35b701c1f332a6cd8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c    |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2096,8 +2096,10 @@ static int amdgpu_device_ip_early_init(s
 		break;
 	default:
 		r = amdgpu_discovery_set_ip_blocks(adev);
-		if (r)
+		if (r) {
+			adev->num_ip_blocks = 0;
 			return r;
+		}
 		break;
 	}
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -82,7 +82,7 @@ void amdgpu_driver_unload_kms(struct drm
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
 
-	if (adev == NULL)
+	if (adev == NULL || !adev->num_ip_blocks)
 		return;
 
 	amdgpu_unregister_gpu_instance(adev);


