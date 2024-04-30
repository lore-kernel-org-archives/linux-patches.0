Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633B217592;
	Tue, 30 Apr 2024 11:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475931; cv=none; b=qU90SE/KIKW60LDyfTabTjWnxqy7jOoL6C1E3ugKAGFG40IUgIO0hjNvPV+qB1ga9GGZHXVxm2m14Vr1QR3mgt0iOtpUWXZ+V/T3XM+Wd8/KArTCI9srw8JO2qWJbCTzKmZZ+DBL2cdChr2+xAT/xKejanXysAsNn07lpSz8feg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475931; c=relaxed/simple;
	bh=Hzz5iBI/lnSqJzghNsZmxecc7Cd7DBwthdcGzN8N7NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtBtGUOjg3eKUHKdQ8NQBdJ1D9qk/HQzEcTaNMN2HGm8XO6kQBkWMrR+b2lImBANsZTqlquAVzGKOTvpC4BANSf2fWJ6HSfD5oINZNAuTtfuEhKjfRIGYgZHK6dU8k6N+DQQ9K7QdMtUIMmZnxKgFl/rT+te5Jsi/w/BBSyDtSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKke6I8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKke6I8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6F3C2BBFC;
	Tue, 30 Apr 2024 11:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475930;
	bh=Hzz5iBI/lnSqJzghNsZmxecc7Cd7DBwthdcGzN8N7NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKke6I8VtFyYxo4APoz8Eu3YiK7eYnl21mnOQecF2Pawng0AvaEUpxOX3hoXqwE/q
	 GZLf2KtIzkLbX65qTA5NuzlqyuKvb7y+ykOOCgESz87v7rWZakwYQ+o7k0dCXbVFr/
	 cbvL2WqCUP4xZ0FAraVKCWd5GY7F009uBDuoF270=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 61/80] drm/amdgpu: Fix leak when GPU memory allocation fails
Date: Tue, 30 Apr 2024 12:40:33 +0200
Message-ID: <20240430103045.220114699@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1502,6 +1502,7 @@ err_node_allow:
 err_bo_create:
 	unreserve_mem_limit(adev, size, alloc_domain, !!sg);
 err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
 		drm_gem_object_put(gobj);


