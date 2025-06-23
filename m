Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44674315A;
	Mon, 23 Jun 2025 21:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714938; cv=none; b=h2WzW8ryWEGHDEKY7rLhZTx3OIVJcPBPDhR7p1qeUSnsQ5TFt3ECHXcDFPdI+MckWwW1+FU614OG5dTtGM8FMS5CwCggitWQylEFOOCGmu0vXzhuviFZ2k5wPxG/cyj3DW7lGMlBp5dsei+zrQMEUB8F3oKiImH9Tt1NEHCUcRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714938; c=relaxed/simple;
	bh=piSKYISZLy3LkDHnAjsSKejnS55llDyPE5ExYFawhyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8LOCeAbW5CB7X4YXZjsUitndiahpqhuGbYlM2x+LnW/WFfOs5Xzjw5nSTJEni0c6sUPkKTLRYgAmGCUVMuMOo1eIeRypLpJGriq/lu+KGCqJsfSXMTxUWYThWs2HyYKOiJDdQU+8w2hOF+2VuvTSBCPOZdlTJklspGHAX+ZW6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFOQBQyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFOQBQyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DDAC4CEEA;
	Mon, 23 Jun 2025 21:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714938;
	bh=piSKYISZLy3LkDHnAjsSKejnS55llDyPE5ExYFawhyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFOQBQyoiN9PjhLzdal2ayy9BfHXzPabfWmRz4MQVa7+WECj/NNRMMOSoQAXdSjTW
	 A42Rwvvt4CaTyPxzrChlrWo2B+zf7ZlGr/gbYNF2L2RkRZ6uiWJB+qs66QbFYU/rQl
	 6XGBKncuIurSNs39pBrIxXhPFSXEpVPsUpTSDtVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/355] drm/amdkfd: Set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB
Date: Mon, 23 Jun 2025 15:07:23 +0200
Message-ID: <20250623130634.024258721@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amber Lin <Amber.Lin@amd.com>

[ Upstream commit ab9fcc6362e0699fc1150aa1d8503c40fce2c1e1 ]

When submitting MQD to CP, set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB bit so
it'll allow SDMA preemption if there is a massive command buffer of
long-running SDMA commands.

Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index dadeb2013fd9a..dc468dfce391e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -396,6 +396,10 @@ static void update_mqd_sdma(struct mqd_manager *mm, void *mqd,
 	m->sdma_engine_id = q->sdma_engine_id;
 	m->sdma_queue_id = q->sdma_queue_id;
 	m->sdmax_rlcx_dummy_reg = SDMA_RLC_DUMMY_DEFAULT;
+	/* Allow context switch so we don't cross-process starve with a massive
+	 * command buffer of long-running SDMA commands
+	 */
+	m->sdmax_rlcx_ib_cntl |= SDMA0_GFX_IB_CNTL__SWITCH_INSIDE_IB_MASK;
 
 	q->is_active = QUEUE_IS_ACTIVE(*q);
 }
-- 
2.39.5



