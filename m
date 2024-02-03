Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D86524B4;
	Sat,  3 Feb 2024 04:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933906; cv=none; b=unCs+ZkGIIXkBGVV30XC/+DfiEEhsRf+VY5Zg/yBTo9ARWdPasGh0nXfymGd4Jly5wWmrEcdqsOQsQzCcBt04ZteRb6YyJ2JYXWsHhN4/IWE6SgwC7KllTsr1w4LGMh9+P9S/U9Jvxrv9uwVZm3rHCdIRezIABR8emkwEgJtINw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933906; c=relaxed/simple;
	bh=/fpA3/vZRIzHT2ZDFYp1XgZSEavAL3AhLAIHWZyuwkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUMG7LvUki2S8QaIB1aqUog/oT7pWhx7xqndHF8aSzomNfs2geiKqraYMX9CrZxGxllZ17aRwfTqYs5OEFWyyqj/PhUe8pVXqCysF19QzYPCPXh/OcK+GPZCRG4WL5IdoeOWkQN8tRBCBZ59hh3mYrV7kc2Fg59VXSMqKIRIPWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqwzABnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqwzABnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBE7C433C7;
	Sat,  3 Feb 2024 04:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933906;
	bh=/fpA3/vZRIzHT2ZDFYp1XgZSEavAL3AhLAIHWZyuwkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqwzABnSCTK4sa7M2VYui93QRGGt5uicdHT96eiD1HatHtuSaxMZkrcQdWrq4gXW8
	 G5i//O6eE/ZNa6wEwj07zwkOhaCuA/LeurjIAxtqejVtHD3GxdPJ9a0xZN0+wDCuKW
	 DnGe1q2tcrPEAnGllsvxOD5RGVHqbASnYrzbVPzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 228/353] drm/amdgpu: Let KFD sync with VM fences
Date: Fri,  2 Feb 2024 20:05:46 -0800
Message-ID: <20240203035410.884484894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit ec9ba4821fa52b5efdbc4cdf0a77497990655231 ]

Change the rules for amdgpu_sync_resv to let KFD synchronize with VM
fences on page table reservations. This fixes intermittent memory
corruption after evictions when using amdgpu_vm_handle_moved to update
page tables for VM mappings managed through render nodes.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index dcd8c066bc1f..1b013a44ca99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -191,7 +191,8 @@ static bool amdgpu_sync_test_fence(struct amdgpu_device *adev,
 
 	/* Never sync to VM updates either. */
 	if (fence_owner == AMDGPU_FENCE_OWNER_VM &&
-	    owner != AMDGPU_FENCE_OWNER_UNDEFINED)
+	    owner != AMDGPU_FENCE_OWNER_UNDEFINED &&
+	    owner != AMDGPU_FENCE_OWNER_KFD)
 		return false;
 
 	/* Ignore fences depending on the sync mode */
-- 
2.43.0



