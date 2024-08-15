Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40727DA7D;
	Thu, 15 Aug 2024 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730342; cv=none; b=qSZuhFqbiyRXCeA2R2AuFpZWHV8kFiQo0IM4VPuyxqKoM3cr++NggsKuDUGDt7ub56iSzUOrV/MSMnYNSlLmNONDsIGeGv7/+JDnJgcBVyk+/CJBvu41YCekdV4gpWOETUdcqSEFeIbi3mOIWgaQ13N38XiG8t2CUZIVtRMjikE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730342; c=relaxed/simple;
	bh=bAYZO7+OPur4CXdzLQRsozM5PQl4T6w8Mzva3rLJMQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+U+dV3sEB+TsjsVMKEayiPI1SnkugFMI2S6qLCKWbAHZnVegJ2VzUj92uf07wHn4mHxkjaGUgUaErHl9O3uMezV3mtGKux/Bm7LZS/dTxaW9kll4AjuDiru5NZlJGRiUEHg34nlYxrV5O9TZtSDyW7zI/xPjX+uRLYIPyw0ECc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wUmH3/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wUmH3/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C23C32786;
	Thu, 15 Aug 2024 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730342;
	bh=bAYZO7+OPur4CXdzLQRsozM5PQl4T6w8Mzva3rLJMQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wUmH3/TNdW9kC+AR38R690AuIROHPN3l+hYDML/SPI7D5eZGsLbmTafQX6JDYVzw
	 uaKxFkEz/wEH2S38E9dEmv6AhKVT3by8fJevEeMttwrDETEafJmygvHgRoglTSsi/Z
	 61tHU9+rpLf2Bw/kXJgrBBHOS9qiPq+NkkTAHo7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/484] drm/amdgpu: Fix the null pointer dereference to ras_manager
Date: Thu, 15 Aug 2024 15:23:57 +0200
Message-ID: <20240815131956.085753457@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 4c11d30c95576937c6c35e6f29884761f2dddb43 ]

Check ras_manager before using it

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index c963b87014b69..92a4f07858785 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1509,12 +1509,15 @@ static void amdgpu_ras_interrupt_process_handler(struct work_struct *work)
 int amdgpu_ras_interrupt_dispatch(struct amdgpu_device *adev,
 		struct ras_dispatch_if *info)
 {
-	struct ras_manager *obj = amdgpu_ras_find_obj(adev, &info->head);
-	struct ras_ih_data *data = &obj->ih_data;
+	struct ras_manager *obj;
+	struct ras_ih_data *data;
 
+	obj = amdgpu_ras_find_obj(adev, &info->head);
 	if (!obj)
 		return -EINVAL;
 
+	data = &obj->ih_data;
+
 	if (data->inuse == 0)
 		return 0;
 
-- 
2.43.0



