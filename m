Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54012CD99;
	Tue, 30 Apr 2024 10:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474510; cv=none; b=gM8KA1WTqcwa7K+D7PjoO5wXzOGFdnStCiyyF9AxowteB9wK6uYvvLpLXud2nNaffOAXp+5Xwri5AoIUEq8fFgDaGWcvBZatoWgOX5DFCoLG6hOwKRzOLF3yJyikFrne/HFamhRTKj265Rzb2hgRwkfxrlVWOdUOk3zui20g6sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474510; c=relaxed/simple;
	bh=9kQxTwDpKyBlkoMxTKSkbDTEX68bKsMw3WxVKV4s5bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt1HrWS0jdflbPzkn75D00XyfgZfKnOhx5TD5NDtTi9bugwUASC+/VLuX/8Zs7U77wsQvYxtQBCzI8emxgnzXpSWuMwNjTPTSzk0nIDrTI44Q8UIozOk8YOQKTgDAZW6yRqKVUioUD5sQvIrVpSqWF7PXut4v/TnSvCbfLTO8DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jD3gMfWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jD3gMfWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA3BC2BBFC;
	Tue, 30 Apr 2024 10:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474510;
	bh=9kQxTwDpKyBlkoMxTKSkbDTEX68bKsMw3WxVKV4s5bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD3gMfWjDHqIKtL5EdCmEygLxftUznFkX0U33BzVHobrAzytix01L+sCfRNzsJUOi
	 B2OVWbNw++DsLIoSA1+AlnY25sF7KoRkbaki0v6i8FK538X08bzbdLq2kZdT9d1kcx
	 +q42a/64567p5+c5lckIsJKw+YzZgCFqsn/gCxKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 178/228] drm/amdgpu: Fix leak when GPU memory allocation fails
Date: Tue, 30 Apr 2024 12:39:16 +0200
Message-ID: <20240430103108.940551902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1851,6 +1851,7 @@ err_node_allow:
 err_bo_create:
 	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags, xcp_id);
 err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
 		drm_gem_object_put(gobj);


