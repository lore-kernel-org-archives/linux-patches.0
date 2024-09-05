Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7A318D65E;
	Thu,  5 Sep 2024 09:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530202; cv=none; b=T4yYC3R7DcGRv31CN/oNWuBCGmnPmkyu4dKQ9gSOIgmGtz9FqkM0Xj+joaKdH2/Kli02JVBANL2Ssc1M95Gc+4pudRQFLyp6DTyL1k8UB/R7/lmj48cEIy48j8PbgOI7CCbijDhgJ5FlBGIFxDGvdqlBmOE1cDSAgVy/wg9CHqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530202; c=relaxed/simple;
	bh=Tzg7GCgchOrTiCTMgu1eV/gCn+ukljqAS1ljV3b/ABE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQGeKE81HMk6xnbZ+LJKVJ1py5DoQBekFXHwSk+as2gu8zK1/X1wA/f8SH4U+NlV1txQdWk6W2KbGopAYkTXSqQP3IW6Jt1yPMW7VoWUuDmPoqRx/OJRr0jI4dWdHD9Wbqrs3b1gBjbUrjzFdmgcJKMKSk7wsWNGriymfI80swQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zn6j9Jiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zn6j9Jiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DFFC4CEC7;
	Thu,  5 Sep 2024 09:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530201;
	bh=Tzg7GCgchOrTiCTMgu1eV/gCn+ukljqAS1ljV3b/ABE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zn6j9JivPUDnot0k+JXHY9FIkWpimblGQQGs5fVYbfzanNkQNr42EqUeL2DgQc+8U
	 3imTpE7bAK7hHhSP9QepoAcL41Br/rCu8UqesHC7LjHyTPlSFK13yE8OGY+mcyCYJo
	 7UoJAMqATMLnks8rJ+sH94jdx8W+PpNZcRyjadG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/132] drm/amd/pm: check negtive return for table entries
Date: Thu,  5 Sep 2024 11:41:12 +0200
Message-ID: <20240905093725.556020308@linuxfoundation.org>
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

[ Upstream commit f76059fe14395b37ba8d997eb0381b1b9e80a939 ]

Function hwmgr->hwmgr_func->get_num_of_pp_table_entries(hwmgr) returns a negative number

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
index f4bd8e9357e2..18f00038d844 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
@@ -30,9 +30,8 @@ int psm_init_power_state_table(struct pp_hwmgr *hwmgr)
 {
 	int result;
 	unsigned int i;
-	unsigned int table_entries;
 	struct pp_power_state *state;
-	int size;
+	int size, table_entries;
 
 	if (hwmgr->hwmgr_func->get_num_of_pp_table_entries == NULL)
 		return 0;
@@ -40,15 +39,19 @@ int psm_init_power_state_table(struct pp_hwmgr *hwmgr)
 	if (hwmgr->hwmgr_func->get_power_state_size == NULL)
 		return 0;
 
-	hwmgr->num_ps = table_entries = hwmgr->hwmgr_func->get_num_of_pp_table_entries(hwmgr);
+	table_entries = hwmgr->hwmgr_func->get_num_of_pp_table_entries(hwmgr);
 
-	hwmgr->ps_size = size = hwmgr->hwmgr_func->get_power_state_size(hwmgr) +
+	size = hwmgr->hwmgr_func->get_power_state_size(hwmgr) +
 					  sizeof(struct pp_power_state);
 
-	if (table_entries == 0 || size == 0) {
+	if (table_entries <= 0 || size == 0) {
 		pr_warn("Please check whether power state management is supported on this asic\n");
+		hwmgr->num_ps = 0;
+		hwmgr->ps_size = 0;
 		return 0;
 	}
+	hwmgr->num_ps = table_entries;
+	hwmgr->ps_size = size;
 
 	hwmgr->ps = kcalloc(table_entries, size, GFP_KERNEL);
 	if (hwmgr->ps == NULL)
-- 
2.43.0



