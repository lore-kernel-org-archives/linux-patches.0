Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE26338918;
	Tue, 11 Nov 2025 01:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824982; cv=none; b=ALRohPENgGoWiAppIZfDTBQpfkl7sw6xOqCZ0hzZGpE0IGAblcHFIRsxqzSi4kBt6LbDPpFGeuwBGZFaMxsO6H9Aq2Puk2vicMvbzbFfcv3Ag+yvX0DXXkrpOQU+O5lPXLEzneh4l5bYbA4d77aa7+lXOc4b0sJHKdWhacInuIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824982; c=relaxed/simple;
	bh=CjT+1JViGiUP+u1xfkG/FuqB7965MlYP1nDpT11sZRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYoj3lVn1QiBrBp9Fk/r8uiHgBYykDR37keBWolGyNVaqwDjWxri2WK+6LdyA/KgkpOcG9QoPxXYrjvkYkp3NgT3AfrWcddhPS1miqs32kpPB2LoVOZc2lXxeMH1CRGi6qWJHKUF7dShpk/+GIHzyKsbgz/NLZ8IhDiUKsQAB/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0Bu/nap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0Bu/nap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBE0C113D0;
	Tue, 11 Nov 2025 01:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824982;
	bh=CjT+1JViGiUP+u1xfkG/FuqB7965MlYP1nDpT11sZRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0Bu/napF3hykmU8Euj4k3D2NMetC5iJnctFYprNkr1DPCRre45gby0G8hzOlrmLt
	 O6Nt7GYTsqLX54RLqlwyY3kdHe1XQQcRY6lXTb46wICgpjFHLU18rUFDv49POODbzT
	 Zuw/ztKBhKN+YO/AeF/HfhAIMsyBi/fkkJuiV1NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 562/565] drm/amdgpu: Fix unintended error log in VCN5_0_0
Date: Tue, 11 Nov 2025 09:46:58 +0900
Message-ID: <20251111004539.660581356@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

commit 46b0e6b9d749cfa891e6969d6565be1131c53aa2 upstream.

The error log is supposed to be gaurded under if failure condition.

Fixes: faab5ea08367 ("drm/amdgpu: Check vcn sram load return value")
Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -721,9 +721,10 @@ static int vcn_v5_0_0_start_dpg_mode(str
 
 	if (indirect) {
 		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
-		dev_err(adev->dev, "%s: vcn sram load failed %d\n", __func__, ret);
-		if (ret)
+		if (ret) {
+			dev_err(adev->dev, "%s: vcn sram load failed %d\n", __func__, ret);
 			return ret;
+		}
 	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_enc[0];


