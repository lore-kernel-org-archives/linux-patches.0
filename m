Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91C7207E14;
	Tue,  8 Apr 2025 11:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110831; cv=none; b=g7+DDYiIHon1Obqm5OWL8Hb6w/rRDcBGMgaEbbZwbzJVBGASWb81M3YXUHk/1OsOJDBqvAFf7QOfPXtqGduqtm2EvMRcRHtIQbplkM10pdHvpcpa1pYsOhjZPTSm+1hXjNlqKE0ddWvLt5XHWQ0vskX/ivAWgmtvukYEXurNCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110831; c=relaxed/simple;
	bh=6ee6aY0whtvJwVRSXcjvaaQReurjPfUyuJ7MEjc/WUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNsJrshvxZrWNptbsQfZYzbYpbTtgniWQcKxys3K2mtjO81yjVV2QXbQxRg8/E9/NzYku452MaNoS5n+yI7ixD9cGa6VZqaD81WU7ZQvkoqak0cxTSceeK/tph8KEAE+JTMdLPHpmgjD7sxibDZheExa6zgqVCGpsZR8JeSZyfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvV54j6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvV54j6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACE6C4CEE5;
	Tue,  8 Apr 2025 11:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110830;
	bh=6ee6aY0whtvJwVRSXcjvaaQReurjPfUyuJ7MEjc/WUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvV54j6w6LS0POpNbgo8kgLvPMyhYsAUkSaUyJGbOs/NqQH02rpO9hri8EC3WvK6o
	 9KTjtYhLlmBV+6Fxw8CLAu2e5bYZgiQKo8DtaJ6hP5ixGeFCyf9yAEhbwJufz+7a8e
	 mpYi3qZ7JilYxmW4iFJio8YrlXO5p1vzfGilTl10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Brandeburg <jbrandeburg@cloudflare.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.14 208/731] ice: fix reservation of resources for RDMA when disabled
Date: Tue,  8 Apr 2025 12:41:45 +0200
Message-ID: <20250408104919.120425374@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Brandeburg <jbrandeburg@cloudflare.com>

[ Upstream commit 7fd71f317288d5150d353ce9d65b1e2abf99a8e2 ]

If the CONFIG_INFINIBAND_IRDMA symbol is not enabled as a module or a
built-in, then don't let the driver reserve resources for RDMA. The result
of this change is a large savings in resources for older kernels, and a
cleaner driver configuration for the IRDMA=n case for old and new kernels.

Implement this by avoiding enabling the RDMA capability when scanning
hardware capabilities.

Note: Loading the out-of-tree irdma driver in connection to the in-kernel
ice driver, is not supported, and should not be attempted, especially when
disabling IRDMA in the kernel config.

Fixes: d25a0fc41c1f ("ice: Initialize RDMA support")
Signed-off-by: Jesse Brandeburg <jbrandeburg@cloudflare.com>
Acked-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 7a2a2e8da8fab..1e801300310e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2271,7 +2271,8 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
 			  caps->nvm_unified_update);
 		break;
 	case ICE_AQC_CAPS_RDMA:
-		caps->rdma = (number == 1);
+		if (IS_ENABLED(CONFIG_INFINIBAND_IRDMA))
+			caps->rdma = (number == 1);
 		ice_debug(hw, ICE_DBG_INIT, "%s: rdma = %d\n", prefix, caps->rdma);
 		break;
 	case ICE_AQC_CAPS_MAX_MTU:
-- 
2.39.5



