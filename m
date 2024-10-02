Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07B61D042F;
	Wed,  2 Oct 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876747; cv=none; b=E9uDyp6eMxSjrfcvXR50ue0TOH6H73PDuZpDnH6ex/IRikfBiLoC0Ioe2RR7SgDDrhhMGtzK6vsIHto31YHbPiO6UTHztJ3MMGDEBDtDu8oKmgFDhUFoQu+6doPW+YDfBi0YBVc6HSXZ7Y5gEjpDjNPYcWcjs0PA9WRTsL4P4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876747; c=relaxed/simple;
	bh=QQPGNlIUbsLW4WJA7MO+2EfPB76zYc9baqGnERxdTYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kurMBTtNSqdNZrToiv9Pz5LAaDYZFqTRGipS+Z2nMR7OX6QZNOSo0eKMRuDCL6DMAUv5LQUzUSMX5QNJ9lcgTgIyvDG5KWmF3vm2s9ZynSeUJxqH4vGdOYr5M9LNLS+ENVetlOfd932CeDE7z6+8wo5DL2Z1XWeHlDtpJ1T0tjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zvqPipa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zvqPipa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FF7C4CEC2;
	Wed,  2 Oct 2024 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876747;
	bh=QQPGNlIUbsLW4WJA7MO+2EfPB76zYc9baqGnERxdTYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zvqPipap7bhRtbCsgV/lSlfal2EounVTT5frEe3L0sAHiNPElQI7beyA4WTfb2dC
	 ispgXdrEfX6ZGK//3+jy/ZmQr0HZc7k/8LK1vrka+VPyRncYbVJ8HHS3etSeKSKORP
	 ZcynxUSpD7QmQP4BvSuOZ3+orXBYHWH/IlW7dniI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 549/695] drm/amdgpu/mes12: switch SET_SHADER_DEBUGGER pkt to mes schq pipe
Date: Wed,  2 Oct 2024 14:59:07 +0200
Message-ID: <20241002125844.419466307@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Jack Xiao <Jack.Xiao@amd.com>

commit 3c75518cf27aa5a7e22e1f8f33339ded3779079b upstream.

The SET_SHADER_DEBUGGER packet must work with the added
hardware queue, switch the packet submitting to mes schq pipe.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -453,6 +453,11 @@ static int mes_v12_0_misc_op(struct amdg
 	union MESAPI__MISC misc_pkt;
 	int pipe;
 
+	if (mes->adev->enable_uni_mes)
+		pipe = AMDGPU_MES_KIQ_PIPE;
+	else
+		pipe = AMDGPU_MES_SCHED_PIPE;
+
 	memset(&misc_pkt, 0, sizeof(misc_pkt));
 
 	misc_pkt.header.type = MES_API_TYPE_SCHEDULER;
@@ -487,6 +492,7 @@ static int mes_v12_0_misc_op(struct amdg
 		misc_pkt.wait_reg_mem.reg_offset2 = input->wrm_reg.reg1;
 		break;
 	case MES_MISC_OP_SET_SHADER_DEBUGGER:
+		pipe = AMDGPU_MES_SCHED_PIPE;
 		misc_pkt.opcode = MESAPI_MISC__SET_SHADER_DEBUGGER;
 		misc_pkt.set_shader_debugger.process_context_addr =
 				input->set_shader_debugger.process_context_addr;
@@ -504,11 +510,6 @@ static int mes_v12_0_misc_op(struct amdg
 		return -EINVAL;
 	}
 
-	if (mes->adev->enable_uni_mes)
-		pipe = AMDGPU_MES_KIQ_PIPE;
-	else
-		pipe = AMDGPU_MES_SCHED_PIPE;
-
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&misc_pkt, sizeof(misc_pkt),
 			offsetof(union MESAPI__MISC, api_status));


