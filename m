Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B721A76A5;
	Mon, 14 Oct 2024 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918772; cv=none; b=amVpC8mAWYFfIji2DMmmKZH6J+bK3+f7KlmZ6pB3CT+PXcAsrlqwqZy3ElobObQ0T1cc3cyTlio++eUQ/vU5cRzHsCkm2i05LADrXs2WiB5ADXufCocqQFDGFcue0xUf44g6IoejmaTr856LBzlIYylyeP77dYUuakpnF6tTGJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918772; c=relaxed/simple;
	bh=3ZzDsvGtWC0qcuy/xFet1m/olpNocxdXx13f2z7ciZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB9OEPy03YGpwnwt6/CKDRRIoI+BlpD0J+Gp0Zozf/scMCezL8iYi9TOiKrvzLniUQ/DWeUKC3ofzHjYI2fOAzgRbKusc4fYdql0FXaulFZb37azTUeZ+JQHuaFrCFW38783PcVuE3Pn13q7BNgds0ob2vxU5DqkueOMtQSFviU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpxojQ+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpxojQ+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09D1C4CEC3;
	Mon, 14 Oct 2024 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918772;
	bh=3ZzDsvGtWC0qcuy/xFet1m/olpNocxdXx13f2z7ciZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpxojQ+sVvgdGMPnKiMEWHty4jpHLafCPXSUk03N6SNc1E/g7E2g3JQLsjBBlBYwW
	 PKDiPeJxNsvSndxBrEc7F+wmuVhgvbLxbqHV9GGxU7dNATv7oQik1ClyKA4mK65oyY
	 ujAbpC6/ZHmr42iewT0LHzhRKvX3aih8JzBmzQJY=
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
Subject: [PATCH 6.1 419/798] ice: Adjust over allocation of memory in ice_sched_add_root_node() and ice_sched_add_node()
Date: Mon, 14 Oct 2024 16:16:13 +0200
Message-ID: <20241014141234.408947725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 849b6c7f0506b..b07bd0c059f75 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -28,9 +28,8 @@ ice_sched_add_root_node(struct ice_port_info *pi,
 	if (!root)
 		return -ENOMEM;
 
-	/* coverity[suspicious_sizeof] */
 	root->children = devm_kcalloc(ice_hw_to_dev(hw), hw->max_children[0],
-				      sizeof(*root), GFP_KERNEL);
+				      sizeof(*root->children), GFP_KERNEL);
 	if (!root->children) {
 		devm_kfree(ice_hw_to_dev(hw), root);
 		return -ENOMEM;
@@ -181,10 +180,9 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 	if (!node)
 		return -ENOMEM;
 	if (hw->max_children[layer]) {
-		/* coverity[suspicious_sizeof] */
 		node->children = devm_kcalloc(ice_hw_to_dev(hw),
 					      hw->max_children[layer],
-					      sizeof(*node), GFP_KERNEL);
+					      sizeof(*node->children), GFP_KERNEL);
 		if (!node->children) {
 			devm_kfree(ice_hw_to_dev(hw), node);
 			return -ENOMEM;
-- 
2.43.0



