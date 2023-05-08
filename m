Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B6168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C60C433EF;
	Mon,  8 May 2023 10:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540216;
	bh=6JFbvQjiOjBQ6JRJA1usAVZ2bTapl9FU1ROFF43zQI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjlQiGQYh/VTtHXlqQQiC4hJCdRc/3+9qp8DVRhWloOwKhrtEOpXMMd65CCwqFDrk
	 rc1ZmLtuL1Cad55cKw69PcpcGuz1Cb+15lCWtPwLMfN7jWLIAZ9RstK0N5/aytL9qF
	 z3Mc1TeDpHNp1du+bWm/t1s9XRFQDlAVQH4PeHUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/611] drm/amd/display: Fix potential null dereference
Date: Mon,  8 May 2023 11:41:30 +0200
Message-Id: <20230508094430.472951489@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Igor Artemiev <Igor.A.Artemiev@mcst.ru>

[ Upstream commit 52f1783ff4146344342422c1cd94fcb4ce39b6fe ]

The adev->dm.dc pointer can be NULL and dereferenced in amdgpu_dm_fini()
without checking.

Add a NULL pointer check before calling dc_dmub_srv_destroy().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9a71c7d31734 ("drm/amd/display: Register DMUB service with DC")
Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6c5ea99223bab..99b99f0b42c06 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1763,7 +1763,8 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 		dc_deinit_callbacks(adev->dm.dc);
 #endif
 
-	dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
+	if (adev->dm.dc)
+		dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
 
 	if (dc_enable_dmub_notifications(adev->dm.dc)) {
 		kfree(adev->dm.dmub_notify);
-- 
2.39.2



