Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621689;
	b=Xn2ljZXheTH5dZMqQT6GtMKFMdiL2AloTP3q5cKHK/1AtnECXyB0m/PP4eHCchJYx5xn
	 CWUHjZTC+6J7ZTn3sALOuBcrSCpMUUEK4WJuaM6SD+V1ZiVKJeIRN4ug4TNar1AMxoItm
	 PXuuTP32w3GIKgixS7ZSQFsh3so2sf56KaaoAgdQgOaD5UFtuufmIFBa1um0UUCp6JWsX
	 IniPXqXxm8sQqId4FB+tjp0qK3Sj5gixQGJYilevXzniHUSBuY3f6ELi1SWN6vv1TDF3J
	 6US+8cxJUyo+UWQfMlSN2uwuRiL5mg69x+14XdhgnwSq4zELLDR1Mn+5ekKCbsq8bkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bz3MQ6fsV21uPAc32QdktIQzjJtfNsN8G60grm5Ttic=;
	b=Y5GBiKDjVCEJCeR/2jhQfK3V8E8dNopER3xvUHFTaxvjjXr3kFVpOpV7pwgApem/3Tob
	 z5Cer9D49y6BefWUsdf8VWuYxmDfGyTUj0iLUxA7ikxRJshaCxcSpXyTD4vRRBp4dlsof
	 rEaIbh9n0P2+t1N45/f+MoeJkoZNx+soNQXu8a+ZYrgYMKJXu8e9kGO3BMBVobREd7Q2I
	 1nGBwHkfkIiULMiq3KPaYV3lQhIFhiOkHMIJifgLA1fWIfqtowk90Ifbx0kSNaZxhb0Ik
	 s7JHgXqspUjnd3Sr45pifpHlCiuXlBnone0LiMnd78eYM3CpGR6yq4k+AzGdsdZr6xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ucIdDra/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA4F606A332;
	Wed, 25 Nov 2026 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ucIdDra/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C337A1F000C0;
	Wed, 25 Nov 2026 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621689;
	bh=bz3MQ6fsV21uPAc32QdktIQzjJtfNsN8G60grm5Ttic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucIdDra/0M5HdvkXcBluUUq1SyMDVR+BhYxU90yoeOb3CmcqsrMw1VEMzP8BIA/jD
	 XGGUA3IE0IqR9JIBJotIRNEZchnZkjmONathZshfbxoiBNXiJbujkJfaj1EgY3hP51
	 0cDAxTMF5mNO6KXQ3aEKoeMXIZxrth+azl+0pJVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Blomquist <nblomquist@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 260/990] drm/amd/pm: track BACO state in the SMU v11 ArmD3 sequence
Date: Wed, 25 Nov 2026 15:27:07 +0100
Message-ID: <20261125143828.181982717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a26ec190925733dd205507493e936e59dbcd2b19 ]

On Navi1x/Sienna Cichlid with runtime PM, when the audio function is
enabled, BACO entry and exit are delegated to PMFW by sending
SMU_MSG_ArmD3 instead of going through smu_v11_0_baco_set_state().
Unlike the v13/v14/v15 helpers, smu_v11_0_baco_set_armd3_sequence()
does not update smu_baco->state, so the driver keeps reporting
SMU_BACO_STATE_EXIT while the ASIC is armed for / sitting in BACO.

At runtime resume amdgpu_device_baco_exit() checks
amdgpu_device_supports_baco(), which ends up in
smu_v11_0_get_bamaco_support().  Since the state never reads ENTER, the
"already in BACO" shortcut is skipped and the live BACO feature bit is
consulted instead.  PMFW clears that bit once ArmD3(BACO) is armed, so
the check reports "supported but not enabled", the exit fails with
-ENOTSUPP and the ULPS ArmD3 message is never sent.  The runtime resume
caller ignores the error, and a later secondary bus reset leaves the
device unreachable.  This shows up on a Navi 23 being handed from amdgpu
to vfio-pci:

  baco_enter: in_runpm=1 audio_enabled=1 armd3=1 baco_state=1 ret=0
  bamaco: state=1 ... feat supported=1 enabled=0 in_runpm=1
  baco_exit: supports=0 ...
  runtime resume: baco_exit ret=-524

Update smu_baco->state in the helper, mirroring the v13 implementation,
so the capability check short-circuits while in BACO.

Reported-by: Nathan Blomquist <nblomquist@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/6076
Tested-by: Nathan Blomquist <nblomquist@gmail.com>
Fixes: 13d75eadfa1a ("drm/amd/pm: correct the runpm handling for BACO supported ASIC")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20261103141457.2558235-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d515b2694eab5b35533c7fb7af5bddff53ff60d3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c    | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index 48bf000f12e5c..42a4ba9965081 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1559,7 +1559,25 @@ int smu_v11_0_set_azalia_d3_pme(struct smu_context *smu)
 int smu_v11_0_baco_set_armd3_sequence(struct smu_context *smu,
 				      enum smu_baco_seq baco_seq)
 {
-	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_ArmD3, baco_seq, NULL);
+	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	int ret;
+
+	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_ArmD3, baco_seq, NULL);
+	if (ret)
+		return ret;
+
+	/*
+	 * PMFW owns the BACO transition once armed, so keep the driver's view
+	 * in sync.  Otherwise smu_v11_0_get_bamaco_support() falls back to the
+	 * live BACO feature bit, which PMFW clears when armed, and the runtime
+	 * resume wrongly concludes BACO is unsupported and skips the exit.
+	 */
+	if (baco_seq == BACO_SEQ_BAMACO || baco_seq == BACO_SEQ_BACO)
+		smu_baco->state = SMU_BACO_STATE_ENTER;
+	else
+		smu_baco->state = SMU_BACO_STATE_EXIT;
+
+	return 0;
 }
 
 int smu_v11_0_get_bamaco_support(struct smu_context *smu)
-- 
2.53.0



