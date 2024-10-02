Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885FD1C9B91;
	Wed,  2 Oct 2024 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876724; cv=none; b=C6ihXXu3KoONUXzqmkFkb1BrDued1uKGmiytwgtRpJuxzdatzmVaCQyyawoWGvI3a4eeDmzSVVvAfTb8ZdbnLUk7BQYb3dCortkVm+1LvQe4iGfMHxRztVjyiOxqB+idl0QVp6XsPq7pkUARli4e/ERTIjl5G5TiglmYOGJCYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876724; c=relaxed/simple;
	bh=27EdFsYUJ7YkjIHtr/B4Zv+A/w3WZPvABUQ2f13W2qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXOxp2DdSzdUdigi5iEn0T9jx8NZOFTrKEyAnnJAabadiGebNPXIxKGXECpQVXQrteAU5QoNYb7YicFmuW1IoLenUKIl8hplyFz7GVZ/MDORgr05siGCguvHtZM9Gs86Vzh0ZtBT2MUCGgoXNZ3RX0hkfBLL3IRu94+ATuwg9RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWdxa9GO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWdxa9GO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B468AC4CEC2;
	Wed,  2 Oct 2024 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876724;
	bh=27EdFsYUJ7YkjIHtr/B4Zv+A/w3WZPvABUQ2f13W2qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWdxa9GO4QC28RS6xEyAx5JlED67m21CN1w6IOIaDN346si/wINFIkwhju6qmF6pC
	 NO58XRYpL7Zsmz7P4NgPHETGbGC/NkCZynTFfrwJwrfPdAeA/EqQUd2GS8vOwbUOUT
	 VLseOlTMUq+C+5LFd+KSaUxlnMibMzxE1XIV01Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekant Somasekharan <sreekant.somasekharan@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 542/695] drm/amdkfd: Add SDMA queue quantum support for GFX12
Date: Wed,  2 Oct 2024 14:59:00 +0200
Message-ID: <20241002125844.134463247@linuxfoundation.org>
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

From: Sreekant Somasekharan <sreekant.somasekharan@amd.com>

commit d52ac79053a2f3eba04c1e7b56334df84d1d289f upstream.

program SDMAx_QUEUEx_SCHEDULE_CNTL for context switch due to
quantum in KFD for GFX12.

Signed-off-by: Sreekant Somasekharan <sreekant.somasekharan@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -341,6 +341,10 @@ static void update_mqd_sdma(struct mqd_m
 	m->sdmax_rlcx_doorbell_offset =
 		q->doorbell_off << SDMA0_QUEUE0_DOORBELL_OFFSET__OFFSET__SHIFT;
 
+	m->sdmax_rlcx_sched_cntl = (amdgpu_sdma_phase_quantum
+		<< SDMA0_QUEUE0_SCHEDULE_CNTL__CONTEXT_QUANTUM__SHIFT)
+		 & SDMA0_QUEUE0_SCHEDULE_CNTL__CONTEXT_QUANTUM_MASK;
+
 	m->sdma_engine_id = q->sdma_engine_id;
 	m->sdma_queue_id = q->sdma_queue_id;
 


