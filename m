Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF4A17335C;
	Wed,  3 Jul 2024 11:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004953; cv=none; b=GRGQF+4PcseHUxKuuFySIbwPv1cauFjB/wDKnFLCK8gVe7dvTfdd5mXAfVMWasQrYGu4bxlWKBeI3RhBKTIocMZGoI2kgruqPDra31cy27wobBKemCC2ijuU2XkSX4aSX+evJ8gLq0tgE8A4Aw12ASZ5YJgFBVU9U0gixv4n3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004953; c=relaxed/simple;
	bh=CyT0TI0z3mGwONgpRtzfYdj2zGIorbhct3c1+h/dyCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxPk80MLJYMWgZIpWvWJeHa5ca0EnV0WxOyLgfKNs7s/o3FmAYgNTUKQtm1gA+FSBrut1TMg0vWn1D+RDieN++SN+DPqugwlgsO3T6P/vznbkRiRJpBIReSTbB3MFWNNx9oLia9Nufojt0WDZxLt4TiaQ7ESHwKutxduibWpIHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0h1Znbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0h1Znbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16953C2BD10;
	Wed,  3 Jul 2024 11:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004953;
	bh=CyT0TI0z3mGwONgpRtzfYdj2zGIorbhct3c1+h/dyCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0h1Znbkbog+mHvFrncb143UVF0Pn8h7D3eDI3J3CEfk+ioK8jr7wTeGHSpVWJb8e
	 QgrnsMRilUGtNvfroYwGWHBuw3MjDzy/ZyjTIEID5nsNg7awlnu0+D/qImMQoSZ24O
	 6VsBLqkp5V95D826Px09cGkkJkKqCq/2Vz1RVsNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/290] drm/amdgpu: fix UBSAN warning in kv_dpm.c
Date: Wed,  3 Jul 2024 12:39:52 +0200
Message-ID: <20240703102912.130526447@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f0d576f840153392d04b2d52cf3adab8f62e8cb6 ]

Adds bounds check for sumo_vid_mapping_entry.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3392
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
index 6eb6f05c11367..56e15f5bc8225 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
@@ -163,6 +163,8 @@ static void sumo_construct_vid_mapping_table(struct amdgpu_device *adev,
 
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++) {
 		if (table[i].ulSupportedSCLK != 0) {
+			if (table[i].usVoltageIndex >= SUMO_MAX_NUMBER_VOLTAGES)
+				continue;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_7bit =
 				table[i].usVoltageID;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_2bit =
-- 
2.43.0



