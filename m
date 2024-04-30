Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD2F12C462;
	Tue, 30 Apr 2024 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475066; cv=none; b=gw03/QpLUCgiHLvvVtL8xxFa0oeyyyGvOthpyvytbuMHj765lolvczspHkNea3LYV2CV5WBQz9cjcbvIbfw6nrdOkBNRSqPHcINsMtLU35EctrymBTuidY/pArs5ewBD0LCVHFVhDBeRBmAj0thBXSiB4NFXGGIVl6zZE69RkSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475066; c=relaxed/simple;
	bh=ExyWy5Q0RMHwZ79HBO7v8BB3F8OsG6fTxBLgDXqOJ+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8lQ/WhaEU+xH8s5MsrjCwnys4fJWLqKTaZ59HBo9CcTFy1IKwnsekz6PpBuZ0Ey4JsRq8oMIdgJ4Isnf+8uUBTQGbJDm2cOqbnffC+Yn4I906sTrYqabONxInfXxh365jfLiLtIiWUq+3hjC0ZCZLdauJChF7riGKRE7gIK+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlGt5a/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlGt5a/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554A0C2BBFC;
	Tue, 30 Apr 2024 11:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475065;
	bh=ExyWy5Q0RMHwZ79HBO7v8BB3F8OsG6fTxBLgDXqOJ+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlGt5a/Wp5ldK+Lmbf/MHzX+nGqJnBj8gwiom/gcS7ZKOhDhhAA8edIDvSd8PPVQv
	 p0bkEoF3A0iw8N3PSvkLrPGbfysa+DqCYl1wNxzlbE7ifj3MtlSrVm2sTBjr+5lMf8
	 Xio9JuqMUSTvPwVOqi//DcI/E6N1Tp2tjRQAC5eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 120/138] drm/amdgpu: Fix leak when GPU memory allocation fails
Date: Tue, 30 Apr 2024 12:40:05 +0200
Message-ID: <20240430103052.938491270@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

commit 25e9227c6afd200bed6774c866980b8e36d033af upstream.

Free the sync object if the memory allocation fails for any
reason.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1259,6 +1259,7 @@ allocate_init_user_pages_failed:
 err_bo_create:
 	unreserve_mem_limit(adev, size, alloc_domain, !!sg);
 err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
 	mutex_destroy(&(*mem)->lock);
 	kfree(*mem);
 err:


