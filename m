Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC77190496;
	Tue, 10 Sep 2024 10:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963374; cv=none; b=CuOgygnkVBzk7K8qWNQJX8i3objKFfCv0yA/w/fV+VjFaMLUxuH7iYe+H1RQxp09Gv6LBVSdJIOFnVnpSU1PoWmdPgfUoxOMovQfYzyTHPwQjFZV1piTP7lJqKhPzZWVxcYwK3XvIDZP8XtsY6fFc1Tt5IwU3AKGeJ+xLD4tDtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963374; c=relaxed/simple;
	bh=39JI3mMMPy0a7bcRnd5alLDb4Z6julHtggfCNt8xLio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUroXTF7NOKo4o8JC+PGMldNboNyq5w+EZzEkR19/NxHjXW+RxiabZXDibkbIROt5c+K1KjkCEPmo9v+SmuCCLi813aU5PYfXRf1Lgxc1AFL6eJHp5OO6+byA4DY+JWGvRSzD4BFdNSGuo0vc+fgXjsg6mdNU4St7IeMP8Ajc/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Med8SHfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Med8SHfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD0C4CEC3;
	Tue, 10 Sep 2024 10:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963374;
	bh=39JI3mMMPy0a7bcRnd5alLDb4Z6julHtggfCNt8xLio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Med8SHfns/U29NqfmaeGwA0c1/5n7qYxcQRQpuJ5oV4M0sJY1U/1b9U8yDIQdsGBH
	 xyiUtiQCtERamnSm3D54pHOWSVK4qPmC9otqxIRT+qVZa43q3z1kb79hCv7xG2fctP
	 ckBUOM6EfSb9mmBRIKzZU66fZpeVsnqMLQGkH1RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/214] drm/amd/pm: check negtive return for table entries
Date: Tue, 10 Sep 2024 11:30:58 +0200
Message-ID: <20240910092600.244572448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1d829402cd2e..59b18395983a 100644
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



