Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F033981;
	Tue,  8 Oct 2024 12:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389724; cv=none; b=uG1AbOBrWCq2pQxCjUhAVKEhg3IvkCkQEbJIZUx49KB0fH8sgoqt9S64Bpe6QEv8/Uj7FiQ6YSh4nfHueyU+FQWxdiXS0Nx8YJzq3ywiWY6hfl6mg5AyQG/ZzZNVpe5YE4yDSNCRCfJf8LPZ8cnfofcVFAJy9C+yi/cOtL1xkCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389724; c=relaxed/simple;
	bh=TIWkxu9czr4K/LR81D2F+fdq8UHhVJm5/g9mRxxwLWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHwCAHw6RhPNy/h0bs/8s+OOqf4GHJN5AGcpBVqgRYKXgLd+SaeDNLJilVWxU2TBJjPW1UoH7BqrnM5+lrn4qjaMn2vbi16q8l20kN829ixp/zJsi1Mo4IY/Gb0J+EM2kSpOnytVMXbeLZGv1YlS3p5PoIE4Ct0Jhjzymmc7qRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxftOe6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxftOe6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D73C4CEC7;
	Tue,  8 Oct 2024 12:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389724;
	bh=TIWkxu9czr4K/LR81D2F+fdq8UHhVJm5/g9mRxxwLWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxftOe6iKbNp+Ygn+FWNEee4PHHV/MK/ojPtzcJAJv7xctS1zwzvVWdmBYsGfzNSc
	 6ISSO7DbVWXlA5l5JPYwMhgwuRbI7pRrjriSjNBewrSDPmI+WR8zIAZh4E8cKMdJ6z
	 Dl/JqKWqeovbtiKinsHziCtjx12n5X8poU4uO9qc=
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
Subject: [PATCH 6.10 077/482] ice: Adjust over allocation of memory in ice_sched_add_root_node() and ice_sched_add_node()
Date: Tue,  8 Oct 2024 14:02:20 +0200
Message-ID: <20241008115651.335685455@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ecf8f5d602921..6ca13c5dcb14e 100644
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
@@ -186,10 +185,9 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
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



