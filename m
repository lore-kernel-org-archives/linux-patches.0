Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC90165F08;
	Tue,  8 Oct 2024 12:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390054; cv=none; b=Hba5J3ghtLpzuCSkOGQ5LsCjho2sMWgQk+Zfo6AB4JIYCt5U7bgWpwwM/zjX3QYR1cEzRqOd5fkp7ie06XUEKiN5knP5vOUcmw2+6/tB/GZ+Mi2DauH4RYtHvt+BU/ZZrdmp6J1jqpNidlOw09R5xXDhz4WszE947ZkUIgWX17w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390054; c=relaxed/simple;
	bh=UOtSLWpmkz17EmWORPRH1QpKlWs5lysYCAAGCNnV6lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Na/h8vB3WpPYRaoWaxSk2xDLk2QaBG7BHc3vs/ipRPJXC4UcinhjjCTj86GY3zmZjPgl72MKe2wzHPlDCtcm7wVyJ67+2WTI0KE91rx2KY4+ztSIUZ54WNNJ2hMGe25oVz7bQX3/Wf5TTijCYg8La6ficXgJTsAK9gwwbsr/ocY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7fo/yhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7fo/yhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37E8C4CECC;
	Tue,  8 Oct 2024 12:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390054;
	bh=UOtSLWpmkz17EmWORPRH1QpKlWs5lysYCAAGCNnV6lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7fo/yhE61qnlpBEVb04BobjLpCLJHDs3pDT22uY7xcmx8Y4c5Ot9Ag0lBSwMDcvl
	 xQPhEFIFlsF8BlQjwMbWYzUzowQ+BvUTVHnJQGahs8D/LZ/aWcwiB+Y53FSPoSO/H8
	 uF91C+jzyIRl0GfBPtfoUdvMSyNV8f9He/IoUroc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 176/482] drm/amdgpu: disallow multiple BO_HANDLES chunks in one submit
Date: Tue,  8 Oct 2024 14:03:59 +0200
Message-ID: <20241008115655.231719529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit fec5f8e8c6bcf83ed7a392801d7b44c5ecfc1e82 ]

Before this commit, only submits with both a BO_HANDLES chunk and a
'bo_list_handle' would be rejected (by amdgpu_cs_parser_bos).

But if UMD sent multiple BO_HANDLES, what would happen is:
* only the last one would be really used
* all the others would leak memory as amdgpu_cs_p1_bo_handles would
  overwrite the previous p->bo_list value

This commit rejects submissions with multiple BO_HANDLES chunks to
match the implementation of the parser.

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 6dfdff58bffd1..78b3c067fea7e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -263,6 +263,10 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 			if (size < sizeof(struct drm_amdgpu_bo_list_in))
 				goto free_partial_kdata;
 
+			/* Only a single BO list is allowed to simplify handling. */
+			if (p->bo_list)
+				ret = -EINVAL;
+
 			ret = amdgpu_cs_p1_bo_handles(p, p->chunks[i].kdata);
 			if (ret)
 				goto free_partial_kdata;
-- 
2.43.0



