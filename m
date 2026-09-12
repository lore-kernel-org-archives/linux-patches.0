Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09FE3D9DC0;
	Sat, 12 Sep 2026 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214198; cv=none; b=mp8TcPf3GGj6+Ld5PqkP9damB6Axcqmyj30nY2gxVJAb8eBu/tormBiOzogTB3TtH0NtjTi8VKtiSVnP6AuEuVcmiWykozVFUnFs47zLbsVvp5swNSIMIsxt2RXyPKxxWGkV0+2gTI7tUkWfpMth5IxJJhRNdWWdQt55xdxQ9a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214198; c=relaxed/simple;
	bh=/Lo36JCQ87687iaANU+a7kVpKv2MT/usJ5enVh88UVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv+yK9sFgb76J8M/+tid62erhUHuQf2b0PddF2pnqBCKaOws283fXkZISfM+WG4+xi2Pw1un1y3FYDwVC7QYZnd5k5TBNvd36GclfaHgUfOCnNyl2MkwUfXNjrYA7ldrkdpReYPdpDi+WdXc/I7aza/7xIBOJuYefzJc8GpcyGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whhcO2su; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whhcO2su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B581F000FF;
	Sat, 12 Sep 2026 11:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214197;
	bh=jgpp8QEkW6Y9+7SOaSNEik138fkwch/KT7slRc1khMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whhcO2suubs0CFnjDYnz0L7MQGZUXsyFDWs0xN7m5ZJcjlEXICM1RXeADawrtYEx2
	 j6PMt5Tt3jEqIvrZaJ6oLDmroQ5LWcokx+PUui6mAVvLnFRjjmgCkLRncIPHpgW1S1
	 ZyLuYaFmHdilj2nTZSqU8w78rvtW2fUHcgsdrFzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0277/1376] drm/amdgpu: Skip accessing psp rum time db for APUs
Date: Sat, 12 Sep 2026 08:45:03 +0200
Message-ID: <20260912065613.719534536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>

commit a26301203a196a991527f7b1ab884d4dd0e7c95e upstream.

Psp runtime DB is for dGPUs only.

Signed-off-by: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dce8195027f146467c9378efb2bb1b0859cb735e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -358,6 +358,12 @@ static bool psp_get_runtime_db_entry(str
 	bool ret = false;
 	int i;
 
+	/*
+	 * Runtime DB is for dGPUs only.
+	 */
+	if (adev->flags & AMD_IS_APU)
+		return false;
+
 	if (amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 6) ||
 	    amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 14))
 		return false;


