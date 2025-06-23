Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF464253924;
	Mon, 23 Jun 2025 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685323; cv=none; b=AwtQy7xAYJFO+mHHTqz5WUEbRR0aLIiuMjJtXdmGDuNVSKFc17Zcd1HwlUwrG7m1j8jpPO8wzrwvCYO/2FOJSCD7rBJ/JTWHcVJjfKZ45fReUhqjuPRQHou5E8/TEyxqR12TrTLxbD5lpd05OFyZ4OIvayz5fSxti4hU5y5cGk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685323; c=relaxed/simple;
	bh=06bTdQqHvNqJnDFNQxI+9fekzU63qYu9W7o7BCT0znI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlvrk4Ta52X9off5sBE0MnrGwmsrXDhWymm3sK6c05HHlCxOeI1UAeHAtSzgsPkgaOaKJIESg/4G/9BxGRw7vxrFNBLoGBsvSJvngs47mIkkhewcL+m1vQ6fLyM0yYeHZh5weC/rCcvpMvcDrpVchmNzNDHq4gEQnWyL068lriE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmxy1AqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmxy1AqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535ADC4CEEA;
	Mon, 23 Jun 2025 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685323;
	bh=06bTdQqHvNqJnDFNQxI+9fekzU63qYu9W7o7BCT0znI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmxy1AqKYDcdTrEHlzWZvRguPgulObtufuwk0ozIYDIyQS+OCnFbiM+uy64FhYp/o
	 6fatgc6QoALo8rIlWVA6M0+fl5xXGK5bm5I9P00kcRc1W6cSKOL4wNyMZw8bJm8c/U
	 XmswZB1xOePLwvSfotnbY4SmSgO3cFh39FXe0YVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/411] drm/amd/pp: Fix potential NULL pointer dereference in atomctrl_initialize_mc_reg_table
Date: Mon, 23 Jun 2025 15:02:51 +0200
Message-ID: <20250623130633.814156668@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 820116a39f96bdc7d426c33a804b52f53700a919 ]

The function atomctrl_initialize_mc_reg_table() and
atomctrl_initialize_mc_reg_table_v2_2() does not check the return
value of smu_atom_get_data_table(). If smu_atom_get_data_table()
fails to retrieve vram_info, it returns NULL which is later
dereferenced.

Fixes: b3892e2bb519 ("drm/amd/pp: Use atombios api directly in powerplay (v2)")
Fixes: 5f92b48cf62c ("drm/amd/pm: add mc register table initialization")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 1fbd23922082a..7e37354a03411 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -144,6 +144,10 @@ int atomctrl_initialize_mc_reg_table(
 	vram_info = (ATOM_VRAM_INFO_HEADER_V2_1 *)
 		smu_atom_get_data_table(hwmgr->adev,
 				GetIndexIntoMasterTable(DATA, VRAM_Info), &size, &frev, &crev);
+	if (!vram_info) {
+		pr_err("Could not retrieve the VramInfo table!");
+		return -EINVAL;
+	}
 
 	if (module_index >= vram_info->ucNumOfVRAMModule) {
 		pr_err("Invalid VramInfo table.");
@@ -181,6 +185,10 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 	vram_info = (ATOM_VRAM_INFO_HEADER_V2_2 *)
 		smu_atom_get_data_table(hwmgr->adev,
 				GetIndexIntoMasterTable(DATA, VRAM_Info), &size, &frev, &crev);
+	if (!vram_info) {
+		pr_err("Could not retrieve the VramInfo table!");
+		return -EINVAL;
+	}
 
 	if (module_index >= vram_info->ucNumOfVRAMModule) {
 		pr_err("Invalid VramInfo table.");
-- 
2.39.5



