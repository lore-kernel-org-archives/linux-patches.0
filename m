Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D1D14A08E;
	Thu,  5 Sep 2024 09:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529654; cv=none; b=ErBh3Bt9Jba+Rkt6iVxIZ3CzD09X/IVaC6B5rBURU6hacoIMh+q86WDjmQWPco8PgANOH99wl/VlhohwZPhMappW6KUg6XGk+3pxPqVaLEbSiCT68F4ncj7+A7g8cDOReGQ7tiffl5jb5pLmXvyEKqiy4MAVR/V5ezePAborbx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529654; c=relaxed/simple;
	bh=JlgxnX8ADpoKvUUCtt9j0l+A4K/QUv3GrfpFBAM0vlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rF4v7JuimGjvvToNIAVdkrNxZGWT0LUqQeR+rcVXOh4XsFs8MSDfXEyODBCfcMx1Oy+pCumHgOTqYj5WZoAYA/H2CoSX9WIEuBQLEcdmXcHz4F4NXUwgDaQrFBF2V7vGKiwjQK1b2N/lx3D8iNtDz8vjb0NQixYHsYMW5VeePpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8wPkdSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8wPkdSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A3EC4CEC3;
	Thu,  5 Sep 2024 09:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529654;
	bh=JlgxnX8ADpoKvUUCtt9j0l+A4K/QUv3GrfpFBAM0vlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8wPkdStNcolnU1RUZJK05bdub4l1N0nweerZjGDToSAgy63GWHPgb+IdOs7JN4cv
	 zeOQ7StwsjzGSQwGJIt96KKdTtzWdqDDOiOu9LVWozoIMXN3cBpsiqY1koCaCOiIOI
	 ck5lq9qAfdU8hEfmQ3lcvr3rMxZEqZfNc4jeEwNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 102/184] drm/amdgpu/vcn: remove irq disabling in vcn 5 suspend
Date: Thu,  5 Sep 2024 11:40:15 +0200
Message-ID: <20240905093736.219228613@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

[ Upstream commit 10fe1a79cd1bff3048e13120e93c02f8ecd05e9d ]

We do not directly enable/disable VCN IRQ in vcn 5.0.0.
And we do not handle the IRQ state as well. So the calls to
disable IRQ and set state are removed. This effectively gets
rid of the warining of
      "WARN_ON(!amdgpu_irq_enabled(adev, src, type))"
in amdgpu_irq_put().

Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
index fbd3f7a582c1..55465b8a3df6 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -229,8 +229,6 @@ static int vcn_v5_0_0_hw_fini(void *handle)
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		if (adev->vcn.harvest_config & (1 << i))
 			continue;
-
-		amdgpu_irq_put(adev, &adev->vcn.inst[i].irq, 0);
 	}
 
 	return 0;
@@ -1232,22 +1230,6 @@ static int vcn_v5_0_0_set_powergating_state(void *handle, enum amd_powergating_s
 	return ret;
 }
 
-/**
- * vcn_v5_0_0_set_interrupt_state - set VCN block interrupt state
- *
- * @adev: amdgpu_device pointer
- * @source: interrupt sources
- * @type: interrupt types
- * @state: interrupt states
- *
- * Set VCN block interrupt state
- */
-static int vcn_v5_0_0_set_interrupt_state(struct amdgpu_device *adev, struct amdgpu_irq_src *source,
-	unsigned type, enum amdgpu_interrupt_state state)
-{
-	return 0;
-}
-
 /**
  * vcn_v5_0_0_process_interrupt - process VCN block interrupt
  *
@@ -1293,7 +1275,6 @@ static int vcn_v5_0_0_process_interrupt(struct amdgpu_device *adev, struct amdgp
 }
 
 static const struct amdgpu_irq_src_funcs vcn_v5_0_0_irq_funcs = {
-	.set = vcn_v5_0_0_set_interrupt_state,
 	.process = vcn_v5_0_0_process_interrupt,
 };
 
-- 
2.43.0



