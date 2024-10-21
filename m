Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1E23A1CD;
	Mon, 21 Oct 2024 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506626; cv=none; b=Vwva7i3BjBWcsxKp0EjFdlYtsAqWZrctyx/+nVii6CjKZGl8KwdPnVj2Z1QE0CkFp7e+8XYYJVb+2CSqw3LJCaXRaGWPX0OXd9EgtdJx5RYaR13U/MpTG5G2jIm/kvo98tQ9i0/1K+iYy5Fq/ElLb+HiPxvMCB/yhYeR0y8t5zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506626; c=relaxed/simple;
	bh=q4FgNO3b0bZIZDEknfVFPfdyh+Or3FOFW4TbAI+tS5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGp3rlU051zk3xPG/cuQzEz7vwCbuJB5ck8qWbE/B+yKUbKCEm7qkGFvJEg82P4xA1cUMLuT8Ah9d4+y5w3M0xsLmB3BqFJPFBm54WxiTl9qO/wSjEqQ3HLB261SfnoaejgquT5gbat4ne1ichPExhzGn6sNLxO7ObYwvjMEyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtyWnSMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtyWnSMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF6DC4CEC3;
	Mon, 21 Oct 2024 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506625;
	bh=q4FgNO3b0bZIZDEknfVFPfdyh+Or3FOFW4TbAI+tS5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtyWnSMSzgzrzehd3l9dIN+adXuyYID2wVQrp5wnIbEz7Dfu+jiPKyI8enUZg7tOf
	 I3LDEMaI9k+l9IdMPnKfO2zragT5YxjWeyIJDTybs3aVROt0/28IN7LoxWlZdmvWoc
	 wK1i8sOk0XNwflCOsTAsvGVeu1xAOJ0qSUbBR6/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Jack Xiao <Jack.Xiao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 066/135] drm/amdgpu/mes: fix issue of writing to the same log buffer from 2 MES pipes
Date: Mon, 21 Oct 2024 12:23:42 +0200
Message-ID: <20241021102301.914543317@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chen <michael.chen@amd.com>

commit 7760d7f93c764625fedca176891238675fd06d62 upstream.

With Unified MES enabled in gfx12, need separate event log buffer for the
2 MES pipes to avoid data overwrite.

Signed-off-by: Michael Chen <michael.chen@amd.com>
Reviewed-by: Jack Xiao <Jack.Xiao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 144df260f3daab42c4611021f929b3342de516e5)
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -595,7 +595,7 @@ static int mes_v12_0_set_hw_resources(st
 
 	if (amdgpu_mes_log_enable) {
 		mes_set_hw_res_pkt.enable_mes_event_int_logging = 1;
-		mes_set_hw_res_pkt.event_intr_history_gpu_mc_ptr = mes->event_log_gpu_addr;
+		mes_set_hw_res_pkt.event_intr_history_gpu_mc_ptr = mes->event_log_gpu_addr + pipe * AMDGPU_MES_LOG_BUFFER_SIZE;
 	}
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
@@ -1270,7 +1270,7 @@ static int mes_v12_0_sw_init(void *handl
 	adev->mes.kiq_hw_fini = &mes_v12_0_kiq_hw_fini;
 	adev->mes.enable_legacy_queue_map = true;
 
-	adev->mes.event_log_size = AMDGPU_MES_LOG_BUFFER_SIZE;
+	adev->mes.event_log_size = adev->enable_uni_mes ? (AMDGPU_MAX_MES_PIPES * AMDGPU_MES_LOG_BUFFER_SIZE) : AMDGPU_MES_LOG_BUFFER_SIZE;
 
 	r = amdgpu_mes_init(adev);
 	if (r)


