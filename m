Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C3D194A45;
	Tue, 27 May 2025 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364642; cv=none; b=KsK7a5oqwuYDhV0RkkBP1yREPSBWnU/7sOHErENFKvijb3iWT85/bvXQWzMvFc63enywYkKJ0GOBLIVGjGDHHWp9wxLlCtodhqz3ndsX2oX/vE4+l4aK6rgJjtSeF+OPSuWC4QAQx9HJ/Fb4uAVg4pubh8Ap2le/hYPgpa659wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364642; c=relaxed/simple;
	bh=mIqJ8aIQS5/0mWGbYx7cm3IZIRuGH9wA3PJtpFcMhOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc/QLdvcRo6qwwc7ieivQqWTSyCqgB9y1fzqx8SnytUdKJTISSawGvxFT8OMbz4FdMHa5hQP4jaQ5gG7lST2OGWR+yJjVemQFve5V51DrW0hyZ2ddL+rqnF/KvJrUfNZROApptFLHsO1CydKR2EluupLOtyOm7q1+UISjEZ40nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXQRXmac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXQRXmac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A81C4CEE9;
	Tue, 27 May 2025 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364641;
	bh=mIqJ8aIQS5/0mWGbYx7cm3IZIRuGH9wA3PJtpFcMhOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXQRXmacQwmM/mJkSejyH1WCXVKqzd9zqNDEZ96BzQgcXiqM7byBS12LxQ0gLni+X
	 EPZ6k4iM5T/sC0Ag7klorPj/QAd31t9tLX1i/QxzqBTn1TpdA5LRpt9Ok5a0nOttc2
	 N4rHKZZTXZSN4Vl7iJ5YOwyP0BE66JLZRjM9ICiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Flora Cui <flora.cui@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/626] drm/amdgpu: release xcp_mgr on exit
Date: Tue, 27 May 2025 18:20:14 +0200
Message-ID: <20250527162449.946748666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Flora Cui <flora.cui@amd.com>

[ Upstream commit b5aaa82e2b12feaaa6958f7fa0917ddcc03c24ee ]

Free on driver cleanup.

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Flora Cui <flora.cui@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 081c0e45779fc..ca0411c9500e7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4677,6 +4677,9 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	kfree(adev->fru_info);
 	adev->fru_info = NULL;
 
+	kfree(adev->xcp_mgr);
+	adev->xcp_mgr = NULL;
+
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
 	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-- 
2.39.5



