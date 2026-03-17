Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C083EAC6F;
	Tue, 17 Mar 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766326; cv=none; b=RlvVm7p1tpC+uMk62O6/q81p28HMCNpHrTxTl8inO1UufY8j7knX99G6jM5fkyNhiy6pu5xHmoR2de/5EcluKnXFYh58IuRaiCmjV2OM7BlAV5TCs8z0RS6Wm6suKtFvufHDlI91WJ6pykX95GmrypjW3WC/ki4nOP0cbVpDpis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766326; c=relaxed/simple;
	bh=1h69ogrC1pkQ9ZF9z5qU1HYd7FLQIFnZ2s+zOfA0xtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJinLJAz9AS2hJZjCKSICLnl41Zg60lNhFWG5AsBSvrRFwRkVIuKppUk2s11uLVv3H/J9pB99rwTU8B/r/Vsa51ERCOpeNND7qqw5X/aqZIkWAwewq27qjHjKvZlqye+eM6f1qh+jgf+sXTEFQzkVL2ntFFzKYyzKMqdCK0ou4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McFLPJcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McFLPJcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDB9C4CEF7;
	Tue, 17 Mar 2026 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766326;
	bh=1h69ogrC1pkQ9ZF9z5qU1HYd7FLQIFnZ2s+zOfA0xtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McFLPJcl/vj8BfqlzQfeFuGfi3QxjxsMmKH0UEET5uu7laWq5+V2JGc8t4nBcTMgW
	 egBYWFQUDW1XfsX5yUlWI430cf0nDMSHlXGM2+2WhMl7oPFUTuixXvm0zG+zIIlPZS
	 n8PHeHH80VILTeYFprkHMEF2TVIBl/FVwieNx3rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 219/378] drm/amdgpu: add upper bound check on user inputs in wait ioctl
Date: Tue, 17 Mar 2026 17:32:56 +0100
Message-ID: <20260317163015.069374785@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit 64ac7c09fc44985ec9bb6a9db740899fa40ca613 upstream.

Huge input values in amdgpu_userq_wait_ioctl can lead to a OOM and
could be exploited.

So check these input value against AMDGPU_USERQ_MAX_HANDLES
which is big enough value for genuine use cases and could
potentially avoid OOM.

v2: squash in Srini's fix

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fcec012c664247531aed3e662f4280ff804d1476)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -668,6 +668,11 @@ int amdgpu_userq_wait_ioctl(struct drm_d
 	if (!amdgpu_userq_enabled(dev))
 		return -ENOTSUPP;
 
+	if (wait_info->num_syncobj_handles > AMDGPU_USERQ_MAX_HANDLES ||
+	    wait_info->num_bo_write_handles > AMDGPU_USERQ_MAX_HANDLES ||
+	    wait_info->num_bo_read_handles > AMDGPU_USERQ_MAX_HANDLES)
+		return -EINVAL;
+
 	num_read_bo_handles = wait_info->num_bo_read_handles;
 	bo_handles_read = memdup_user(u64_to_user_ptr(wait_info->bo_read_handles),
 				      size_mul(sizeof(u32), num_read_bo_handles));


