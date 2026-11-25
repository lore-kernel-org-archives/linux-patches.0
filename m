Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624494;
	b=w2McMKYko9yHFOCSZyoc20ZQRpFUe4O1KMvZ8DACAFWMBCGFC7i83qDjl/+4LzHuIZdD
	 tBEyrbv+kCvVI5jL6/GULDmN8nlDtVU6TJd9QjjHOFvtjxBIkPKINlqC9xDz58vrL+A1A
	 yKQa5t7PBGOaCv2xTg8ulOhVqxjhy6bQEe8BPs5UHpqcvhiS2Nvmnd5fVbmrGgIGSaMA/
	 1eG2ClYj/mYOF7A86vmzhoap7Nfg1lzQrDFw4kb234v/z9RWqwDwNt4+woix/8GJSWdEh
	 Opb/u96T89rY0TBBSOpwM3w1BLifgOg4XMHE8QiD2riWcI8pryf72I1GNgdO4bIdhVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQsFRiNiJOeoMpS843qKBxZZpuOtErEhhkskINVtApA=;
	b=uTo+gxu1+yYtBOVg794CNcTNWEFvbIvM/ID52UjddEBl5AkiQAJaxHnmkodCSDIVmLeP
	 BAEHgw9GYJoTyGDYlg4+Xm/uyuJECcf5Ly9lDfcLf2dE6TYd0HUmUwvU8OC/I01Jqfpzb
	 Mlvx4f4kbuY68zabHP0RdVMa2BBe7zjv89ttwBTvaX8F+5WKdjxgA7RNrelqWkPh3kYgz
	 YZa/Zlu1u3vO62aJR1GfjMn0SPyKO9cmAMEhP+GLaEtcilru/In7LrEmKbxcTmAAZ1yb8
	 NXy2HYRwtgiHXXDrLMCAcRmAluxsN6cUo7Lh+fEw/8rvR8zPcYldhTghqJE2KaqlNoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXWpXX72;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EECE606A33C;
	Wed, 25 Nov 2026 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXWpXX72
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5F1F000D0;
	Wed, 25 Nov 2026 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624493;
	bh=zQsFRiNiJOeoMpS843qKBxZZpuOtErEhhkskINVtApA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXWpXX72yPEI9fHGA9vg3BCz5tPavn30vEEQzl5eUR6bvRwlBoKJifFaTDusac62Y
	 gKViw0TN8DSAuXYEmeivnbSDViWkYPSEctEZqHn5orjVxEl9NxcwDX/Uo828hM0AtV
	 W+Khkkb3yoIcjPHw7SGSPw7kjHJYoU5AVq38zlS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Blomquist <nblomquist@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/816] drm/amd/pm: track BACO state in the SMU v11 ArmD3 sequence
Date: Wed, 25 Nov 2026 15:29:18 +0100
Message-ID: <20261125143854.061947483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7fda517245247..54ab8eb006a86 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1549,7 +1549,25 @@ int smu_v11_0_set_azalia_d3_pme(struct smu_context *smu)
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



