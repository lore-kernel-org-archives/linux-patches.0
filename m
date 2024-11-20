Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB4F1BC9EC;
	Wed, 20 Nov 2024 13:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107676; cv=none; b=B8JJcbZUnqPxIChLkrrd+wUjEadf5tBKl/OUMQA9FYJHIcXFpzwpshDV6mOOfjEQDOZ4ty7Po1TiNIxn+ClZFiP2+rzZ4znif8SRqj+V8yepg20i/Vtj6f7oxG7Hzwkj+KB7S1Hh0mSV1/agyAB9kPz6eNkn//DcMlNHfLmNJSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107676; c=relaxed/simple;
	bh=UySQMx9QgOCOdws/V4Yrrhvx4NYlJyCkXdrLrIu5hgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfR0Y/+JMIl5uchgdB1vDp5v4ryA6B8px8J6oeUMNe2PWOpbA276kbHtqkmJ+dcn7AQLmJG5CBsbdAPj4JmQsirMKsQDW2J79jgCQJ3EwhsgGx+ni5OjThzzTeIwiFODGiaf/Uam1+deq3vK6wgiVrk4ZxFuDx/UIDuPg78fI0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmVkG4Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmVkG4Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2255EC4CED1;
	Wed, 20 Nov 2024 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107676;
	bh=UySQMx9QgOCOdws/V4Yrrhvx4NYlJyCkXdrLrIu5hgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmVkG4Zu65+Yr/4SF+N1pMDO82W8OMjwVP3/ssssCLCcschZwIlBKckyxCwjf31kM
	 DbqApwr9kFeVW4jFWFHgAX65Ate67GEAX+SGDWXU2L8m1KfO2HuQ7hIuKO9CYshzou
	 /03kKASe4nTzYB0uAN0CQRv2Ek9OnI7+PmDkoZR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 33/73] drm/amd: Fix initialization mistake for NBIO 7.7.0
Date: Wed, 20 Nov 2024 13:58:19 +0100
Message-ID: <20241120125810.405675396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

commit 7013a8268d311fded6c7a6528fc1de82668e75f6 upstream.

There is a strapping issue on NBIO 7.7.0 that can lead to spurious PME
events while in the D0 state.

Co-developed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20241112161142.28974-1-mario.limonciello@amd.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 447a54a0f79c9a409ceaa17804bdd2e0206397b9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c
@@ -247,6 +247,12 @@ static void nbio_v7_7_init_registers(str
 	if (def != data)
 		WREG32_SOC15(NBIO, 0, regBIF0_PCIE_MST_CTRL_3, data);
 
+	switch (adev->ip_versions[NBIO_HWIP][0]) {
+	case IP_VERSION(7, 7, 0):
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF5_STRAP4) & ~BIT(23);
+		WREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF5_STRAP4, data);
+		break;
+	}
 }
 
 static void nbio_v7_7_update_medium_grain_clock_gating(struct amdgpu_device *adev,


