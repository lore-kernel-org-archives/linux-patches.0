Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A788C129;
	Mon,  1 Apr 2024 16:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988515; cv=none; b=tTIjBngrFP9Mfm4JlT+7PfzIPCzDBqRaQn16v8t4bsg9rsk808ffEXMOnKE8WwqDl1uphma4rFaQt8nV+9YNzP3NXgDgBmSSs3WeXAMeC/CTztvg7Qj9rpYmQo7feMsZM/tVg7c5M9AzyQDF7gqCiB2+QM5ToYKsB6JGf0Ar2f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988515; c=relaxed/simple;
	bh=VjYJ9KcQVy6Rts3Fbx40NG4KgWPAVxcazVtcsl0Dtu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=un+gAjy0nkv3PksgKrVv3zfmEC0Wf83pzb+QvKpFAtjz75f/jY2mlhLg36QLedYDAJSHL7VKGRnJ2sMcA/31Gfs7cyVXxALz9vCVa2JApkg/kgO3m/13vOosWfsi+BVff4eJBAFj322a6ZBavxRlpUC1FwEIs/CUuW1drF4pNik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvAmqb5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvAmqb5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F4DC433C7;
	Mon,  1 Apr 2024 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988515;
	bh=VjYJ9KcQVy6Rts3Fbx40NG4KgWPAVxcazVtcsl0Dtu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvAmqb5QQnWE3jsJoYlOertXup4IZ0jxn85MLZ3slrqtdN6erblU1gYaalhmycNTt
	 69gaTkaCWbKNzD3OqE5+SCiyHEM96PIGUIepC2gQW8AOQjbmUPvBJxCd/vQm1WXKBp
	 dinkw9FXgPhvmwVeLhbZtnD7uJIN0gi9BPy2twv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 208/432] drm/amdgpu: amdgpu_ttm_gart_bind set gtt bound flag
Date: Mon,  1 Apr 2024 17:43:15 +0200
Message-ID: <20240401152559.343000923@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 6c6064cbe58b43533e3451ad6a8ba9736c109ac3 ]

Otherwise after the GTT bo is released, the GTT and gart space is freed
but amdgpu_ttm_backend_unbind will not clear the gart page table entry
and leave valid mapping entry pointing to the stale system page. Then
if GPU access the gart address mistakely, it will read undefined value
instead page fault, harder to debug and reproduce the real issue.

Cc: stable@vger.kernel.org
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 75c9fd2c6c2a1..b0ed10f4de609 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -869,6 +869,7 @@ static void amdgpu_ttm_gart_bind(struct amdgpu_device *adev,
 		amdgpu_gart_bind(adev, gtt->offset, ttm->num_pages,
 				 gtt->ttm.dma_address, flags);
 	}
+	gtt->bound = true;
 }
 
 /*
-- 
2.43.0



