Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5868013A25F;
	Tue,  9 Jul 2024 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523959; cv=none; b=BiUxokne3lpCQabt9oBk3xANMbW4i8FZkbi0hGFVH0mKFaZIxPhnV3rNKq5mxhUJm+O/Kv62Dhx7m0+fvqSVBcpaV8hBppiMoXVZV/PqLQgO16FHlj+FFOn+r90Woj21plJt3rMLxLD2lYt3WbqxurSsUGRbxJ4usXTZlfWWvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523959; c=relaxed/simple;
	bh=6bQc5dyxX33HP/o1jzZODN1T6x98Sol7T9SfLPhSVPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiIWshbxQFyiuRGu+2dxtHuKkrqRD8OlP67NMeWjrViDsEzlnjZ+zPW/AkHbf5MXkFxufnGgHcFFDhKz2TdC6e6lPP5JE5KqvA79WGZPA52vegF43KXRgxpTTJT2i2uvzcZd1nBdkBGOzL3bfDvXhV+v7AVKnM8an6GGxlKBgo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtMXZDNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtMXZDNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D329BC3277B;
	Tue,  9 Jul 2024 11:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523959;
	bh=6bQc5dyxX33HP/o1jzZODN1T6x98Sol7T9SfLPhSVPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtMXZDNyw5RmTfOkUrvz7QaWz/tlZXeoEsyB06MxcyQDP5e/1tL4tp9Xl3AWF9Sw2
	 Th/MpTjvUbDdvZFUhnKVhvDOihzH/w1gS7kAIwZpL1lkA8xMVt9KKGj7YsdSVQSfoN
	 rscQbIjWyPgUEM8Jc4K0UTTLhKrL7TS3IwrQLzx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 025/197] drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc
Date: Tue,  9 Jul 2024 13:07:59 +0200
Message-ID: <20240709110709.891542764@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 88a9a467c548d0b3c7761b4fd54a68e70f9c0944 ]

Initialize the size before calling amdgpu_vce_cs_reloc, such as case 0x03000001.
V2: To really improve the handling we would actually
   need to have a separate value of 0xffffffff.(Christian)

Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
index 59acf424a078f..968ca2c84ef7e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -743,7 +743,8 @@ int amdgpu_vce_ring_parse_cs(struct amdgpu_cs_parser *p,
 	uint32_t created = 0;
 	uint32_t allocated = 0;
 	uint32_t tmp, handle = 0;
-	uint32_t *size = &tmp;
+	uint32_t dummy = 0xffffffff;
+	uint32_t *size = &dummy;
 	unsigned int idx;
 	int i, r = 0;
 
-- 
2.43.0



