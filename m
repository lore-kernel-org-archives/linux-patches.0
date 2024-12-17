Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297008615A;
	Tue, 17 Dec 2024 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456534; cv=none; b=Wcyb5JIossuJO8KRakE2LmHYz7oKf186hShAubTf0lhStM+8YMqVWIMBh20YEYuGff942yETZ1P2lKJEtbKvOeiF4FfVv5b3y0Og1wiqbd9Vcm9NQBjqdUCtL/7leGalx+gGyH9HLCE78r1I/JYitBCOkMGcfHEX3BCVRTsbN3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456534; c=relaxed/simple;
	bh=taLJPHvg4EAMX8etQ9Wr4tMiN5VQVletPkgcKvM58YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OhVFHCYExhLaiIKwlHlHTFEI7Azv93f1nhU+V8bollZ8o1eS9LlZjzOAZRqN7ArvXdClkq6fJl2g5nPCj2WDE30DDsCRQx/rU1ZVJVLMIzsI7sUeN7emFHoG6mGfS8UMQXh4h8mfqAdEEJq7e3IqHciQJdF6/tEaVvwkmSWaU5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ibty/sj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ibty/sj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60EEC4CED3;
	Tue, 17 Dec 2024 17:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456534;
	bh=taLJPHvg4EAMX8etQ9Wr4tMiN5VQVletPkgcKvM58YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ibty/sj6He/2Y8Gxb72HIXdQ+mQd2kd4dVv/qAIw9u+VudOw3w8kuvoUX1z5gerI/
	 wJCzUJeSAGSGr521GPa+drnbnUUgDWUmYNcBU1U6bC8sxIs/QnbXoIHaPA0Cu6WD0Q
	 mLCZCIYEMC3AgmYlV/45hD5wxb6jxZjhfkl8BwNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/172] amdgpu/uvd: get ring reference from rq scheduler
Date: Tue, 17 Dec 2024 18:07:25 +0100
Message-ID: <20241217170549.987508811@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6068b784dc69..9a30b8c10838 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -1289,7 +1289,7 @@ static int uvd_v7_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 					   struct amdgpu_job *job,
 					   struct amdgpu_ib *ib)
 {
-	struct amdgpu_ring *ring = to_amdgpu_ring(job->base.sched);
+	struct amdgpu_ring *ring = amdgpu_job_ring(job);
 	unsigned i;
 
 	/* No patching necessary for the first instance */
-- 
2.39.5



