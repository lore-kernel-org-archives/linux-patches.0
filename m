Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300182BF3E2;
	Tue, 10 Mar 2026 11:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141193; cv=none; b=YDeMETuoNgyCJPw7hULJIXNb6TAgum3tdf30DW+xZ1iKTRXuVbMsa+YgNBh4PS1a3IXillqaF+SmxC5vAHrypJjneTB7bypaE0w4xOt37ZatV5McMFGy4vczKqahkFbnX4VFgexcgi5OFWQWHWLFLfh1aZu12+sYLefjC7mbLHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141193; c=relaxed/simple;
	bh=Qu3+qJvt8SxFKgSmk769dccTv/CVJTmWQMCtf02emdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCob2quWBohW4CzUFPWHQhKFhfRDwNDwpTze9fY5+hR5pHCbchQQnSW5wnnFXelwxs+mVGUio8Kxx2P/DvnQ6YorExxSbggaCFQVxsPDNRoXZH2rKHP1OIzIuCRQNZdo5II1wPCgIQ16M3WeMqsbv7D19lZhAZiF7tRe1rSO0M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhgDyBJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhgDyBJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3419BC19423;
	Tue, 10 Mar 2026 11:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141193;
	bh=Qu3+qJvt8SxFKgSmk769dccTv/CVJTmWQMCtf02emdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhgDyBJq4K022z3dp3Bbl0AwvVFtjbkzO4u8zrcHEORU+MDZRz/pIRWCPpA7yLi+f
	 HobGxuHgLasKQlJdUPZet1JQysSbTKEZIuxaQEBKQ6ExXZ41N2rVK1V7jnXcG2m6Nj
	 LZt+MlKA/bX5CHuJ+EX55g2gWK0r0qgy9EfcbjyzvlpjacW6i+r6oDZBMe+8pcbFB3
	 5VhTmj7tmCacO1FIxZqWmpL3G//uNnV/Tp/vB1dLtMFbGv/v/+KOi0MzGlBSZGM7kx
	 Ki69qnV5Dq60SczqW/wnAVCPYonDgpmIpYtOOUBQOuGxOUOPxSwN9w5z6E21A0wWf9
	 L+AD0yUbYuPsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sreedevi Joshi <sreedevi.joshi@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 194/311] idpf: Fix flow rule delete failure due to invalid validation
Date: Tue, 10 Mar 2026 07:04:01 -0400
Message-ID: <318e8eb197c15c0d2f68a7af51409351dc51eeb6.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sreedevi Joshi <sreedevi.joshi@intel.com>

[ Upstream commit 2c31557336a8e4d209ed8d4513cef2c0f15e7ef4 ]

When deleting a flow rule using "ethtool -N <dev> delete <location>",
idpf_sideband_action_ena() incorrectly validates fsp->ring_cookie even
though ethtool doesn't populate this field for delete operations. The
uninitialized ring_cookie may randomly match RX_CLS_FLOW_DISC or
RX_CLS_FLOW_WAKE, causing validation to fail and preventing legitimate
rule deletions. Remove the unnecessary sideband action enable check and
ring_cookie validation during delete operations since action validation
is not required when removing existing rules.

Fixes: ada3e24b84a0 ("idpf: add flow steering support")
Signed-off-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index 2efa3c08aba5c..49cefb973f4da 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -307,9 +307,6 @@ static int idpf_del_flow_steer(struct net_device *netdev,
 	vport_config = vport->adapter->vport_config[np->vport_idx];
 	user_config = &vport_config->user_config;
 
-	if (!idpf_sideband_action_ena(vport, fsp))
-		return -EOPNOTSUPP;
-
 	rule = kzalloc(struct_size(rule, rule_info, 1), GFP_KERNEL);
 	if (!rule)
 		return -ENOMEM;
-- 
2.51.0

