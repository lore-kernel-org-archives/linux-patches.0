Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC94522F0A;
	Wed, 30 Sep 2026 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790376; cv=none; b=V6/zTNjKHxEThLAk+icFrmtgRT5Tw00KsuiWIy0+Gv+A1hjQRi4fgjxmrjyhV1RoVsJl0xmtf8zH9nzz4didSJhfb1aTy9muPSaB/bKvRJKu87HXFkar9Pfd77Rd6W5w5MqdrrEFYf9Mu/UQCSgbfmakDpigRtBOEdY1Usl3ePo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790376; c=relaxed/simple;
	bh=J7ig5Mt7vyhaupXMlL82dcC3aYCxMjCwU08laE2HK84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=As9zILbwXK7yx0zBw4Ehtkq7/xLOMAkEpR4L88iNjfuOM02RGVth4xS1TEcHF/a+WqaSC9/E7nZwGUSjhqzwyBGS2UfjZOSRKzUWliSRM1MhP54iBRJqbTqJVIxrNeoA+Wlp/Wuct7c3Sn39tEgkVfUVZrcr8OdTJhasia3Z/pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01rij+tV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01rij+tV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0B51F000FF;
	Wed, 30 Sep 2026 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790375;
	bh=y8dT6Agmw3cp0DWfgca/hhcQBTvElo5kns9v2cikbE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01rij+tVUc8vvXgf7OSJL7glP5mU84HH50q5vBK+aNh2D43KBVvFKJIaXdnyijoE5
	 qnV6eCknDcgC5NXJiT7rSFDPLcDxL9QmTbX99ZeXTJLQhT0qsOC2rOp96WXc2hMdLZ
	 u3uN5+lV/x2mmBOmxAgDz7bUhA3xV34848eqRSWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 807/877] drm/amdgpu: set the VM pointer to NULL in amdgpu_job_prepare
Date: Wed, 30 Sep 2026 17:28:38 +0200
Message-ID: <20260930152432.130872188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 26c95e838e6301b0230430ec2fadeabfcb07aeda ]

As soon as the prepare phase is completed the VM might be released,
better set it to NULL.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5155002b03b2 ("drm/amdgpu: fix rmmio iounmap skipped on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -368,6 +368,13 @@ amdgpu_job_prepare_job(struct drm_sched_
 			dev_err(ring->adev->dev, "Error getting VM ID (%d)\n", r);
 			goto error;
 		}
+		/*
+		 * The VM structure might be released after the VMID is
+		 * assigned, we had multiple problems with people trying to use
+		 * the VM pointer so better set it to NULL.
+		 */
+		if (!fence)
+			job->vm = NULL;
 	}
 
 	return fence;


