Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9444714A4E7;
	Tue, 17 Dec 2024 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455781; cv=none; b=dvvrypKIS1oDewReSJkN24Fz1Wcfmzuwb8Jf1PuGhlwDP2ixI1SIeuiVeUD5uHzBKcKZ7IZbjM2qVn+bahLuEvVML+Hh0Yyp8zVs2rbqQ2Sibl1iwAg+0R94lCUkT3x7JPBaphNVSP4JtoGxmuJAIv0zsY14qfdxSulABgcOAV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455781; c=relaxed/simple;
	bh=ZToC6hT4o0srGvftp1Pc2GkauFnY+c4XQv7vXaiG9Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwzZQXByf/F9g/y8UfsOGI9kSvDBlYeauyRtfvUfqQad0/n6bP2F+0JZL5HapdwrAV4uFyuDOepEHbI5x85bAk60AqOnSHx/dIsJIeNpBB+4MtLfYNr6rf5mkie0P61NtoeMMSOtc2Wg67qeBxTSdB7/A+BHHOF8MIJbkh+jAg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cu5BEkUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cu5BEkUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF98C4CED3;
	Tue, 17 Dec 2024 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455781;
	bh=ZToC6hT4o0srGvftp1Pc2GkauFnY+c4XQv7vXaiG9Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cu5BEkUJoISx2oqblRT9Mt0pzorAKsp9zJ+o6VqwBt77ojXd9eC8jDdw7Gmm2ijch
	 frJuJjitSSpvFktSgmHQtj1pEek4OM6rLGmLdm/cJ3e9DRbwZbNFKn9gWChvTBoM8I
	 VLRF7+1ANQr5BWfLw6AGOQTiT0SBbiJ7D+WnF1pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/76] amdgpu/uvd: get ring reference from rq scheduler
Date: Tue, 17 Dec 2024 18:07:11 +0100
Message-ID: <20241217170527.557636449@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

[ Upstream commit 47f402a3e08113e0f5d8e1e6fcc197667a16022f ]

base.sched may not be set for each instance and should not
be used for cases such as non-IB tests.

Fixes: 2320c9e6a768 ("drm/sched: memset() 'job' in drm_sched_job_init()")
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
index e668b3baa8c6..1c5d79528ca7 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -1284,7 +1284,7 @@ static int uvd_v7_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 					   struct amdgpu_job *job,
 					   struct amdgpu_ib *ib)
 {
-	struct amdgpu_ring *ring = to_amdgpu_ring(job->base.sched);
+	struct amdgpu_ring *ring = amdgpu_job_ring(job);
 	unsigned i;
 
 	/* No patching necessary for the first instance */
-- 
2.39.5



