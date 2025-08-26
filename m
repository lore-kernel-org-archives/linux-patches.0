Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1674729D28A;
	Tue, 26 Aug 2025 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214954; cv=none; b=L5wCjpHBESRTfeOlMT6eLO8nakTX0+0CcjkMXVLSTaIiXzw6CRAec4m7FC2hNkgmDnnH4dHYnLM2dLZLZ1uAT269HhHRihfN02tRkHZUKKrrd0ycsQkYT8BuN7Krs49omje0NWTDpBDq1AsK11xJcpgeok8SMKnFG6NW5l3v0Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214954; c=relaxed/simple;
	bh=M/ubwPFUn8dgtHByD94TG7DbCGJH/x8lbP/KaS87JI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCbI0qxXubaZmXfH2qescp2Qd/LN4C4O8CmzyweuavxcztCb3k5Yr798g8R0hc6SAiY02Hmh9ZPAUAkXeZIxadp3h3Ijn0JGQI6jyFUJaqRUf3+9oF5gB4ve9ZCQ2zBr2PVYToReN7Mix9/PpJo5HF2HYLHf8mW+0KXtemfHTdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fu3mX4iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fu3mX4iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA34C4CEF1;
	Tue, 26 Aug 2025 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214954;
	bh=M/ubwPFUn8dgtHByD94TG7DbCGJH/x8lbP/KaS87JI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fu3mX4iYYnJamU3mRTPtGfuKqubKPV+aClf017nH3wIlC2TUCk74lW2UWrrgFpS5B
	 0c+oiGFegeezbQ+dexOS5tA/zZDiaViJaHBgG2pSEpETF+4aJRyWIn9uAv6c7/S3DF
	 9BELxrLtHVA2ZPtid3EhM08H3BR/4UpciPRKMxcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 333/482] drm/amd: Restore cached power limit during resume
Date: Tue, 26 Aug 2025 13:09:46 +0200
Message-ID: <20250826110939.049320484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit ed4efe426a49729952b3dc05d20e33b94409bdd1 upstream.

The power limit will be cached in smu->current_power_limit but
if the ASIC goes into S3 this value won't be restored.

Restore the value during SMU resume.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250725031222.3015095-2-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 26a609e053a6fc494403e95403bc6a2470383bec)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1738,6 +1738,12 @@ static int smu_resume(void *handle)
 
 	adev->pm.dpm_enabled = true;
 
+	if (smu->current_power_limit) {
+		ret = smu_set_power_limit(smu, smu->current_power_limit);
+		if (ret && ret != -EOPNOTSUPP)
+			return ret;
+	}
+
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;


