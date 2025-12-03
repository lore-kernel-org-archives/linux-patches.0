Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F9D350D64;
	Wed,  3 Dec 2025 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780942; cv=none; b=g8t/06/gE7EcM/slEQA7DJ7M+cpzwRTr6fKz22CWKYUAtDOoQcgrDVhS7MC+zKRJAGIK0BUj+sNdj3AYPJsJjVOuqAYJBXUoiUmOllPfvzF09gNA0y9Bswx7UqpPmFSL9C0lWrDSNDe0Gf8/ywlcS5eAZ2GUfv4pcfQ7wiK7i+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780942; c=relaxed/simple;
	bh=AM/LryI3A8h4nyd8qw1LyxvW3xYw0e78l8zimXeLtu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTo3tOU2e5nHeTYS8NUqAlkfJRU63vLTDK1Fhhx+cfD6mSefJ/IF8rW4SsFc8C8/tDBBJhpUxkNG41W9Xiy3wi8Bh2GQCmE3SG0I7Q/HUaJXPkx+zUsIzgfq80Cudyt9tJFp7jRR+WdT3qsRYjbHOG+9FeTpbowi583o6bWwtq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFw6S0La; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFw6S0La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FF5C4CEF5;
	Wed,  3 Dec 2025 16:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780941;
	bh=AM/LryI3A8h4nyd8qw1LyxvW3xYw0e78l8zimXeLtu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFw6S0LakIrS7soOg8/3b7eGxFJLJObgab7ZAIXLngRBQSS3DvYKkX7QfZCftwUAf
	 QkvEzfdl44hz3rdmrG0WUfWCYzvunTj1kLHuKCqa04rzr92tx6+5j7XjEcTMZCiQHL
	 2SIn52o6q3d3Kl+N+zPhVeGZxu+sLDoChWQuNx7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Shaoyun liu <Shaoyun.liu@amd.com>
Subject: [PATCH 6.12 105/132] drm/amd/amdgpu: reserve vm invalidation engine for uni_mes
Date: Wed,  3 Dec 2025 16:29:44 +0100
Message-ID: <20251203152347.176274270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chen <michael.chen@amd.com>

commit 971fb57429df5aa4e6efc796f7841e0d10b1e83c upstream.

Reserve vm invalidation engine 6 when uni_mes enabled. It
is used in processing tlb flush request from host.

Signed-off-by: Michael Chen <michael.chen@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Shaoyun liu <Shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 873373739b9b150720ea2c5390b4e904a4d21505)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -580,6 +580,9 @@ int amdgpu_gmc_allocate_vm_inv_eng(struc
 		/* reserve engine 5 for firmware */
 		if (adev->enable_mes)
 			vm_inv_engs[i] &= ~(1 << 5);
+		/* reserve engine 6 for uni mes */
+		if (adev->enable_uni_mes)
+			vm_inv_engs[i] &= ~(1 << 6);
 		/* reserve mmhub engine 3 for firmware */
 		if (adev->enable_umsch_mm)
 			vm_inv_engs[i] &= ~(1 << 3);


