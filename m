Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976521E04A6;
	Wed,  6 Nov 2024 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898420; cv=none; b=AwlfdF1BY2XXj25F4emqZQmexZB3ZPs7BTxSg3cvIYS53V60wGfVAZxrR5ruNr3+bbaWIup1xXZeMCvO3fIcv6NVO15ITP83xUXurBlchRnXo/lsLN5BsoP6b8hzRGm2osPmU8Js/2BJ9keG0Lys08F3qE8Ch/wwNCjH4nzLwMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898420; c=relaxed/simple;
	bh=Jr1HD/EmXCZWn9nTa50OtWzV9DSsv03wKFo975lgZPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyFH+rK/qH5fHZz28YkBELZkpA4Qi/jxFisvOWdwpl8SPNa/Ijx1vd/dDC0fZmbRS6OyWyZpLnQz0HYCACjQds4/Yb3o2vJnWCpmtgdR7MP+Yi0prMaImyh9ufKmSnz9QfoNhoAFrFWr2ZHau6dPyMQWmMrneC5Z694YpmvPMlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGYFMlEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGYFMlEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F109C4CECD;
	Wed,  6 Nov 2024 13:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898420;
	bh=Jr1HD/EmXCZWn9nTa50OtWzV9DSsv03wKFo975lgZPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGYFMlEOqZAzJolWLq8jj4dL80zGuCB8BGEUlwTXZLdfALfE4FyCWnIO4wW01+Czn
	 Yrv0e8qO9Ndmo2Pt6P46fSi4KzQLfng8W9jgRh2wqHwBHNmivwjbDD/BdP3KUs5bUU
	 pYI48RRU+RfrjfR0qf1+wOw9l3HCR+kg3fseYCeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.4 196/462] ice: Adjust over allocation of memory in ice_sched_add_root_node() and ice_sched_add_node()
Date: Wed,  6 Nov 2024 13:01:29 +0100
Message-ID: <20241106120336.356785183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 62fdaf9e8056e9a9e6fe63aa9c816ec2122d60c6 ]

In ice_sched_add_root_node() and ice_sched_add_node() there are calls to
devm_kcalloc() in order to allocate memory for array of pointers to
'ice_sched_node' structure. But incorrect types are used as sizeof()
arguments in these calls (structures instead of pointers) which leads to
over allocation of memory.

Adjust over allocation of memory by correcting types in devm_kcalloc()
sizeof() arguments.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2fde9653a608f..d1c0ccee879bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -27,9 +27,8 @@ ice_sched_add_root_node(struct ice_port_info *pi,
 	if (!root)
 		return ICE_ERR_NO_MEMORY;
 
-	/* coverity[suspicious_sizeof] */
 	root->children = devm_kcalloc(ice_hw_to_dev(hw), hw->max_children[0],
-				      sizeof(*root), GFP_KERNEL);
+				      sizeof(*root->children), GFP_KERNEL);
 	if (!root->children) {
 		devm_kfree(ice_hw_to_dev(hw), root);
 		return ICE_ERR_NO_MEMORY;
@@ -181,10 +180,9 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 	if (!node)
 		return ICE_ERR_NO_MEMORY;
 	if (hw->max_children[layer]) {
-		/* coverity[suspicious_sizeof] */
 		node->children = devm_kcalloc(ice_hw_to_dev(hw),
 					      hw->max_children[layer],
-					      sizeof(*node), GFP_KERNEL);
+					      sizeof(*node->children), GFP_KERNEL);
 		if (!node->children) {
 			devm_kfree(ice_hw_to_dev(hw), node);
 			return ICE_ERR_NO_MEMORY;
-- 
2.43.0



