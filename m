Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7341D545;
	Thu, 23 May 2024 13:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470177; cv=none; b=SGgwV+s/yTMX8X/9nQvAlcyRD4afnP6vVz+MQJs5ztmGBsgJqGNJoZiDX9js6fiL2z0jTTj5LoGwKq98MhdheO3MabyyXJ8fauK5tnGwnisElqO0i19AanVI9R4jXmhr+Mfas52l26JIdcv/f6ZLrwuTlgN7shgJYS8xprvPbl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470177; c=relaxed/simple;
	bh=Iy9aaJxGASA/V/entutPoRrDyHk78sgPfHhI6HqR4KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nsOuwebN3hbpnYjhsKNz2lxy2dkPuAkVeDqjwRjAXFHE/jC3rVYfxnem/smhSDmx2zIlYbiP5m+1u+VUbn2vMijriUPynImC4z75K/jqqBb0f8n7c6CnIKCT4iC8jgngvhN63JRGY3Oi0XzdL41YYBPblfQe6X+DWeHmdh7rVQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w++PidWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w++PidWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99E5C3277B;
	Thu, 23 May 2024 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470177;
	bh=Iy9aaJxGASA/V/entutPoRrDyHk78sgPfHhI6HqR4KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w++PidWmCI3xaqZFHXktkk+ppmIYlc36DDvI2+es8LI9oZFtZqSsjAACyXKfShgTF
	 ePBzdFP+SbyNOqtuuT3kB/9Kchb5zbCCGsq7PeFuhQB6EAA7ApoomCeFXqwT7Wn5qW
	 mF1fJlFMeW4oSBmAfVZwpMv65+ERvoYAoA9JIVK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 5.10 12/15] drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()
Date: Thu, 23 May 2024 15:12:54 +0200
Message-ID: <20240523130326.920997628@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit b8d55a90fd55b767c25687747e2b24abd1ef8680 upstream.

Return invalid error code -EINVAL for invalid block id.

Fixes the below:

drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1183 amdgpu_ras_query_error_status_helper() error: we previously assumed 'info' could be null (see line 1176)

Suggested-by: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Ajay: applied AMDGPU_RAS_BLOCK_COUNT condition to amdgpu_ras_error_query()
       as amdgpu_ras_query_error_status_helper() not present in v5.10, v5.4
       amdgpu_ras_query_error_status_helper() was introduced in 8cc0f5669eb6]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -765,6 +765,9 @@ int amdgpu_ras_error_query(struct amdgpu
 	if (!obj)
 		return -EINVAL;
 
+	if (!info || info->head.block == AMDGPU_RAS_BLOCK_COUNT)
+		return -EINVAL;
+
 	switch (info->head.block) {
 	case AMDGPU_RAS_BLOCK__UMC:
 		if (adev->umc.funcs->query_ras_error_count)


