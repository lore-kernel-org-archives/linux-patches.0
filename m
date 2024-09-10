Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F5E18FC72;
	Tue, 10 Sep 2024 10:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964771; cv=none; b=rNg/ZhErgIG8kVVadxvaa0Pn6I4jVx5G1hrzJmo6GtdSV6CavL7fo2mwVe2gi5szMSjKiZ293a315Y8/fpYa5315rOivZA7naHwAPs1BPkxh3V5fJjblHilAHlfzHzEFf0EfzpsJFET1ZWam4oEFtAS6nrsL6tWEUQ0ZTIYtxjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964771; c=relaxed/simple;
	bh=HFlEvld/HOTd63HLtAfUJCZdbQDXfHfevNEvvZA2xMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQlzPybg1MGbxmd3Voe6BnISGciKLDjmcle3/lU9C4TRI58mu1/+zTDG9mZeEOWuw8S4QAWtN0ffCxZIKmfV7ZIzB8s4bc06rnnKjG3VRjttP19irQoIAhWuuBwidqEtfjfdGX/t64B2L+CtLkCn2niynSZUh80ygqhpUJNMrNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDbCB8oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDbCB8oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B678DC4CEC6;
	Tue, 10 Sep 2024 10:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964771;
	bh=HFlEvld/HOTd63HLtAfUJCZdbQDXfHfevNEvvZA2xMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDbCB8oeo2v+52mx4BuwyNk/8KuQrhVO6XXwElkkY38vqG4tUmkh6IfQLRp8HHmCm
	 qkdeknxf7Y4Vws1nXdwUB9DpYWFFhqZ6imHudacsHYqej/hxpg86KWUDLRIBc8Qs4Z
	 dZu9+q7zpGd2aPD6MarY3VjGDGSUJoMUQ9HwxIw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/186] drm/amdgpu: fix mc_data out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:32:00 +0200
Message-ID: <20240910092555.648561399@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 51dfc0a4d609fe700750a62f41447f01b8c9ea50 ]

Clear warning that read mc_data[i-1] may out-of-bounds.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 469352e2d6ec..436d436b2ea2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1626,6 +1626,8 @@ int amdgpu_atombios_init_mc_reg_table(struct amdgpu_device *adev,
 										(u32)le32_to_cpu(*((u32 *)reg_data + j));
 									j++;
 								} else if ((reg_table->mc_reg_address[i].pre_reg_data & LOW_NIBBLE_MASK) == DATA_EQU_PREV) {
+									if (i == 0)
+										continue;
 									reg_table->mc_reg_table_entry[num_ranges].mc_data[i] =
 										reg_table->mc_reg_table_entry[num_ranges].mc_data[i - 1];
 								}
-- 
2.43.0



