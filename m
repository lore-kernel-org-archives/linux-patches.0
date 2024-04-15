Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307207A705;
	Mon, 15 Apr 2024 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191885; cv=none; b=LQkvrgD92PlXhTFD+87tEh4nBr1dBhxXT8R3S7NxNljjdgWzoc4vjN1Le3USs47Feju9iWrusfVtuHyp2azdVneJb3RTCTTCiccmQSkZlVQcIFJjAqNfi77NRl6vZUSi3ZcpejZyTHzDlTxRvwkevb1jNPcxr5w/1+SkGQVLvvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191885; c=relaxed/simple;
	bh=i2eErfuDS5RyHLjf8RFIp1vxGMFcFcOBlbfwwS5S7zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2FHNOajxlz1G+xZaUKoNHQDSWLdhTrF3ASPOIbz1sChepEjqzZaQheDJe52l6sDT6NzrTAqHMM8kp2+01Y9VTyAkrq5WcwGlkzYaZQbuB88uhba8HFvK6rC9zoK62uTkqRaZHlfXaZDxiRX5JsPoHNHSA4GGyDWNRzOr0DQs7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJbDcWV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJbDcWV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC88C113CC;
	Mon, 15 Apr 2024 14:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191885;
	bh=i2eErfuDS5RyHLjf8RFIp1vxGMFcFcOBlbfwwS5S7zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJbDcWV+mdACEq3k9ySKAANdELt2GIC/9uv1MRkzUyviGUeB34r8QADVeNJ+N3+OK
	 ZpGciUV6hktewi34eaDv9aEatR60ZjBgmPytTHHpSpwkUs5udJ2bMhBMhS2dwVwNAB
	 4FOQB+ZnrETg8Xn4NK1+xcGRNgmiwYp5YIVpXqOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>
Subject: [PATCH 6.6 117/122] drm/amdgpu: Reset dGPU if suspend got aborted
Date: Mon, 15 Apr 2024 16:21:22 +0200
Message-ID: <20240415141956.880442939@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 8b2be55f4d6c1099d7f629b0ed7535a5be788c83 upstream.

For SOC21 ASICs, there is an issue in re-enabling PM features if a
suspend got aborted. In such cases, reset the device during resume
phase. This is a workaround till a proper solution is finalized.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -804,10 +804,35 @@ static int soc21_common_suspend(void *ha
 	return soc21_common_hw_fini(adev);
 }
 
+static bool soc21_need_reset_on_resume(struct amdgpu_device *adev)
+{
+	u32 sol_reg1, sol_reg2;
+
+	/* Will reset for the following suspend abort cases.
+	 * 1) Only reset dGPU side.
+	 * 2) S3 suspend got aborted and TOS is active.
+	 */
+	if (!(adev->flags & AMD_IS_APU) && adev->in_s3 &&
+	    !adev->suspend_complete) {
+		sol_reg1 = RREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_81);
+		msleep(100);
+		sol_reg2 = RREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_81);
+
+		return (sol_reg1 != sol_reg2);
+	}
+
+	return false;
+}
+
 static int soc21_common_resume(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	if (soc21_need_reset_on_resume(adev)) {
+		dev_info(adev->dev, "S3 suspend aborted, resetting...");
+		soc21_asic_reset(adev);
+	}
+
 	return soc21_common_hw_init(adev);
 }
 


