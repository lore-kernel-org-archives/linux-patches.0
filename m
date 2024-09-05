Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4012D194A64;
	Thu,  5 Sep 2024 09:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530189; cv=none; b=f87HHZGQQw/VawVabvHT2IdX1DUTzS7G4t8c/jz3fX2+t0PFdJwger4LEeHkJtxrKbOp30Vf0rTtB2S5CyKQRm+EXAewpTJYGA9nKVa9Fu3coWam6Xsz3YXHO+UMDq5Gi5FH+Pm/sZqwKL1ELBywP+v4UFG/10F2TxRlb5zXD6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530189; c=relaxed/simple;
	bh=424TuQucpXk/x3goSt8fFRVVWFc+hIquZfkpDXxTaHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eafL2cYz/b5UmQZ56fmeoW3BmJsu3Ao0+vsIbslSgKxvjPd3wKabQqK6BHr4ISCwAWgPuE0s1cfMClVbl0AW1woZfKPNHyMvXKVdpcVV1BtMhg3hcMyrCTO3ePBEP27pl4vrYFqi+fAcFpROp3COR8cEapRFY6AYN/TwIS6gkts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFAQuZfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFAQuZfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48B2C4CEC3;
	Thu,  5 Sep 2024 09:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530189;
	bh=424TuQucpXk/x3goSt8fFRVVWFc+hIquZfkpDXxTaHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFAQuZfPYkebouWywq7ZkWb7oxOv3XZzZl/EP/dKXMqOAPIOW719LFrSGiJ6GakVb
	 39Hy4sop/7GlC0pzy9JoZEeNPzdGg/ZraCrNkqxy6Tn9KCrCVrZ1cAjgdLrCZuKO0h
	 ohX8B79d1b0tJSox307w+9m7hZ1lSCymp62ORyCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/132] drm/amdgpu: fix the waring dereferencing hive
Date: Thu,  5 Sep 2024 11:41:08 +0200
Message-ID: <20240905093725.400789861@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 1940708ccf5aff76de4e0b399f99267c93a89193 ]

Check the amdgpu_hive_info *hive that maybe is NULL.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 429ef212c1f2..a4f9015345cc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1336,6 +1336,9 @@ static void psp_xgmi_reflect_topology_info(struct psp_context *psp,
 	uint8_t dst_num_links = node_info.num_links;
 
 	hive = amdgpu_get_xgmi_hive(psp->adev);
+	if (WARN_ON(!hive))
+		return;
+
 	list_for_each_entry(mirror_adev, &hive->device_list, gmc.xgmi.head) {
 		struct psp_xgmi_topology_info *mirror_top_info;
 		int j;
-- 
2.43.0



