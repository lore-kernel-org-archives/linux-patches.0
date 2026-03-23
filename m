Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202423BE170;
	Mon, 23 Mar 2026 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282691; cv=none; b=bj5Wc82RWSLhJOmUDqEHHejWj2lFymeGlTqXh533VbT3h8DWuER7tQHfYt9G8WB7XUxHHVwagxa1PSl7QIkdlZ4M4KmHpri6FgwFnV7ZuJBEh//Hv+jAm3KQ/lijpSABXcABgnU0BJ6LsP2ZjTYvcRdg16HSF4eFqjvAn9gBcFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282691; c=relaxed/simple;
	bh=PNaaFkieZRlpP9RdlBbTh8OwqK+TF/34u6MHfZpkhu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlSN68KhyLRGHwVTSWxMTQ3PC/aarQoPKGkWR3jhyjA1RbTiYx5Lsk+kk7k2rWGAOHne8Qz9p31sgd4xKAujiB29ScKBQQ6kX+s3znKuyowr1zL4gFrytUFmPQupD+SwjAzqFCn9fSsJZNfH2IVeiBMzRER1Go1ayDk37qLi/AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtrbiNkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtrbiNkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6C0C4CEF7;
	Mon, 23 Mar 2026 16:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282690;
	bh=PNaaFkieZRlpP9RdlBbTh8OwqK+TF/34u6MHfZpkhu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtrbiNknDBE6E1V2+6M2jwi7teyTL5CTX8X6xbvDFyvs+fMDwNcpfeGSCjh/1Iz1b
	 jcrhb4J+ju0M1BiZFAOQn39KwBwvTCmU9Naw3GI0LDPLw1VBajihj+wehsn5kcFF41
	 shzneQL2x4gfBADLi4vGlCMjSWh3ONoI61hoh2tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 250/481] drm/amd: Set num IP blocks to 0 if discovery fails
Date: Mon, 23 Mar 2026 14:43:52 +0100
Message-ID: <20260323134531.245802472@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2182,8 +2182,10 @@ static int amdgpu_device_ip_early_init(s
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
@@ -79,7 +79,7 @@ void amdgpu_driver_unload_kms(struct drm
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
 
-	if (adev == NULL)
+	if (adev == NULL || !adev->num_ip_blocks)
 		return;
 
 	amdgpu_unregister_gpu_instance(adev);


