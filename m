Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A2F1494DB;
	Thu,  5 Sep 2024 10:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530542; cv=none; b=KAgcx2PxMK2vOJCVJrHraVWl6QR1Z2Ttq6qXzPha4o4z77hE3lTnrpD35kswxBq0OyCdQXDl/1PAp6iyhKhZLb+su9bqHN3AwV921wbhFk05audJ5m9z0bhp0fbqWfkhSdtRPepn5olaQUsy2INGxUd94lrqNWT/Z4c0b7nFd0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530542; c=relaxed/simple;
	bh=F37Xf0Q2VPC8QyzRB8Ys3AVqpruJOZzToYl/wtLybkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFQns/CQFgNL2+oQHHni5iMQ6KgGvGOjTf3993sNSjOgs7b2GnbuOX4eRsV9y6aWDnD47/CTYA8JtJiAZlwViJRYR+GZUgeibS76Eutm2KR/+9VJP3XlVFVYK8tUgjaVgXDCbQE8JPtix1/T36BSZXj5xvlJu/B5lEb8XDjpqv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNlGlpEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNlGlpEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B065C4CEC3;
	Thu,  5 Sep 2024 10:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530541;
	bh=F37Xf0Q2VPC8QyzRB8Ys3AVqpruJOZzToYl/wtLybkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNlGlpEfWWe9KbOg2vYvTSwczH/5cmJQIWuAYnvsuSTRx/j7Tu3lpU4ISiqwhCvQN
	 VD8LV/jz+DpJaC9i8OgvpTLLTUR9sRXSIzy7Tbdj2nzKXLJZasGjuUjuFPXxnG3OEt
	 EbHCyi2Xr5mEYuaSWbiWaD1+xUmXqBvwoguUrDX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/101] drm/amdgpu: fix ucode out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:41:27 +0200
Message-ID: <20240905093718.289772991@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 8944acd0f9db33e17f387fdc75d33bb473d7936f ]

Clear warning that read ucode[] may out-of-bounds.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
index f1a050379190..682de88cf91f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
@@ -213,6 +213,9 @@ static int amdgpu_cgs_get_firmware_info(struct cgs_device *cgs_device,
 		struct amdgpu_firmware_info *ucode;
 
 		id = fw_type_convert(cgs_device, type);
+		if (id >= AMDGPU_UCODE_ID_MAXIMUM)
+			return -EINVAL;
+
 		ucode = &adev->firmware.ucode[id];
 		if (ucode->fw == NULL)
 			return -EINVAL;
-- 
2.43.0



