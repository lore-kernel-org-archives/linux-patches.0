Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E15F14883B;
	Thu, 13 Jun 2024 12:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280195; cv=none; b=MxD9e8DIeGPe6eVQhecNjh6BKAUYOJr4JeiEGYGvJFSv41mvu9IvJBVq8mBYVX5wWEcqlXPwvbsUPwxqer8wB7MM5eW2PzF8klCwURH24I//ZpT3wvatBbt4MZBwcJjM2X7ABzgKHMoZ0pdvg2h+LF0RZ4LMz+k1WwDdFk3ZYCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280195; c=relaxed/simple;
	bh=kBy+ogLECFs68oV845dNlF55n5ui9/w2s9SUr+Jo13w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/06AXNSd0Ivtcq9fJ8LrxMZEm9pNXJEwiYxESwywZkvBXOM0PsVnItlxbgHajKbNjzqWsj3acjZULpQObdgDC/Dly287JAguaQ4eJ3+YNGUO8EKmKXS+jcad4p3iqW7CHYRW7bh3bUBhJJ2ThalifxKd1dxJy5Q/V1aszO+UIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOT4Y96o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOT4Y96o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD0DC2BBFC;
	Thu, 13 Jun 2024 12:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280195;
	bh=kBy+ogLECFs68oV845dNlF55n5ui9/w2s9SUr+Jo13w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOT4Y96oFbKr2HZ+kLjeM8awF3m04FY7alHUy7c3LarIncVln05Yu0asZFV+3xGYs
	 V7vhTRO6tQ/0LIi1NXRdUyyqzg+bD9aeKFxeiRwiEc7IhDNKPeOoekjzIQz7rEglJV
	 H1zob5bRt93NQ67o0/qbECaIdRHhw+nYePR/B8UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 174/202] drm/amdgpu: add error handle to avoid out-of-bounds
Date: Thu, 13 Jun 2024 13:34:32 +0200
Message-ID: <20240613113234.456549136@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bob.zhou@amd.com>

commit 8b2faf1a4f3b6c748c0da36cda865a226534d520 upstream.

if the sdma_v4_0_irq_id_to_seq return -EINVAL, the process should
be stop to avoid out-of-bounds read, so directly return -EINVAL.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Le Ma <le.ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2007,6 +2007,9 @@ static int sdma_v4_0_process_trap_irq(st
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);
+	if (instance < 0)
+		return instance;
+
 	switch (entry->ring_id) {
 	case 0:
 		amdgpu_fence_process(&adev->sdma.instance[instance].ring);


