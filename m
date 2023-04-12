Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6171D2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD699C433D2;
	Wed, 12 Apr 2023 08:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289645;
	bh=DGCEVk0ez/QVWhJzJzF6ckBMxG1gvKmSHLc+KcAe6qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAI/VGZWYuUnuxOFW5ZaxtoySslm/tkLkycteQb4alzDPXZSf4Rvxaj4VMM/gnaZ4
	 1K3LsRGGW5mmOohgQQw6gAekABl/XEgxOB7yOMj2iSXrMXm33bxeRd6hEUddV1NIDZ
	 brA/WGTusnoi3RYotMZfB72jO4twTnqlWPgbqETw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.2 157/173] drm/amdgpu: for S0ix, skip SDMA 5.x+ suspend/resume
Date: Wed, 12 Apr 2023 10:34:43 +0200
Message-Id: <20230412082844.458239965@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit 2a7798ea7390fd78f191c9e9bf68f5581d3b4a02 upstream.

SDMA 5.x is part of the GFX block so it's controlled via
GFXOFF.  Skip suspend as it should be handled the same
as GFX.

v2: drop SDMA 4.x.  That requires special handling.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3045,6 +3045,12 @@ static int amdgpu_device_ip_suspend_phas
 		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_MES))
 			continue;
 
+		/* SDMA 5.x+ is part of GFX power domain so it's covered by GFXOFF */
+		if (adev->in_s0ix &&
+		    (adev->ip_versions[SDMA0_HWIP][0] >= IP_VERSION(5, 0, 0)) &&
+		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SDMA))
+			continue;
+
 		/* XXX handle errors */
 		r = adev->ip_blocks[i].version->funcs->suspend(adev);
 		/* XXX handle errors */


