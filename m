Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFE011729
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA59DC433C8;
	Mon, 11 Sep 2023 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442628;
	bh=boT2HVZxHG0ytp3hw7BYdEDOZMwUXwknab0r4TUn8Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcXnLARzEUu3Ss55GKIgwlDtEvUN9EoLT1Wkr+MzWaEFZmuPvw0PAkPiAS+MeJwoI
	 90ZOIyq5gUzdMZAoR6gCjnBTXvfhF/k3JvvFJ1rf0hliUDlbcplEVl++W4949PdiVM
	 EwluJyDj2u6WQHMbtIMwPUuZGNlzuQXVfwrQnzBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 064/737] drm/amdgpu: Match against exact bootloader status
Date: Mon, 11 Sep 2023 15:38:43 +0200
Message-ID: <20230911134652.296029604@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit d3de41ee5febe5c2d9989fe9810bce2bb54a3a8e ]

On PSP v13.x ASICs, boot loader will set only the MSB to 1 and clear the
least significant bits for any command submission. Hence match against
the exact register value, otherwise a register value of all 0xFFs also
could falsely indicate that boot loader is ready. Also, from PSP v13.0.6
and newer, bits[7:0] will be used to indicate command error status.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index caee76ab71105..92f2ee412908d 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -136,14 +136,15 @@ static int psp_v13_0_wait_for_bootloader(struct psp_context *psp)
 	int ret;
 	int retry_loop;
 
+	/* Wait for bootloader to signify that it is ready having bit 31 of
+	 * C2PMSG_35 set to 1. All other bits are expected to be cleared.
+	 * If there is an error in processing command, bits[7:0] will be set.
+	 * This is applicable for PSP v13.0.6 and newer.
+	 */
 	for (retry_loop = 0; retry_loop < 10; retry_loop++) {
-		/* Wait for bootloader to signify that is
-		    ready having bit 31 of C2PMSG_35 set to 1 */
-		ret = psp_wait_for(psp,
-				   SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_35),
-				   0x80000000,
-				   0x80000000,
-				   false);
+		ret = psp_wait_for(
+			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_35),
+			0x80000000, 0xffffffff, false);
 
 		if (ret == 0)
 			return 0;
-- 
2.40.1



