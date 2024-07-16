Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB38719E7F7;
	Tue, 16 Jul 2024 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144563; cv=none; b=RArzBcjl3UpuuEnFCV+btoRDhHMaxNg8WorY7pKv/xbGupl5xiBCrTwyHEL+s+l+EUzysrOk7klsRQ+0bkCHK+8IcsCuKVmVhfx7RSMa4sogiRgQHzvFhv2/lK6aeqVMC8s2gaHs7tEk/22hU3SdidNm0BQSjdkapKkoUayxQD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144563; c=relaxed/simple;
	bh=25ZxkvNoUJ3m+CJ5jCTFXHyc+tNdK+nBQXy09YZXcr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hys3VfwbcFo7UgtPg2f0gbXsw00KAlhy4zT7cjceF+97teja0FkcVkRgXMaLttjcCHrgqSg83D0kU5Js+bjjkglTcYQic800Yd1GPzpENfmcnvPOwj+kxVn/rgnwarg9WNDSlOq538Awno1ognM5hhqy2fcBbk0GuGYDbiiNlWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cd1WrYN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cd1WrYN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62862C116B1;
	Tue, 16 Jul 2024 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144563;
	bh=25ZxkvNoUJ3m+CJ5jCTFXHyc+tNdK+nBQXy09YZXcr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cd1WrYN6ZhAugt1RFdICv+c3IJAWHLKhYMhL+INoyyveqafJteBCy6VBtOlfHVVf0
	 tpKFTllOjnt1rb7DpfCK8ygRBeVWP5rm6/Ey5jE8ji9nAmSlbs8RcyRXQSBNRxQq99
	 DOjFhiwln87F3rM5BVaPm2tBE6n/S+37kII2YmVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/108] drm/amdgpu: Initialize timestamp for some legacy SOCs
Date: Tue, 16 Jul 2024 17:30:22 +0200
Message-ID: <20240716152746.278935745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 2e55bcf3d742a4946d862b86e39e75a95cc6f1c0 ]

Initialize the interrupt timestamp for some legacy SOCs
to fix the coverity issue "Uninitialized scalar variable"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 582055136cdbf..87dcbaf540e8c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -413,6 +413,14 @@ void amdgpu_irq_dispatch(struct amdgpu_device *adev,
 	int r;
 
 	entry.iv_entry = (const uint32_t *)&ih->ring[ring_index];
+
+	/*
+	 * timestamp is not supported on some legacy SOCs (cik, cz, iceland,
+	 * si and tonga), so initialize timestamp and timestamp_src to 0
+	 */
+	entry.timestamp = 0;
+	entry.timestamp_src = 0;
+
 	amdgpu_ih_decode_iv(adev, &entry);
 
 	trace_amdgpu_iv(ih - &adev->irq.ih, &entry);
-- 
2.43.0



