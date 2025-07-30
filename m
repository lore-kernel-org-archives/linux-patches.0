Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C01294A12;
	Wed, 30 Jul 2025 09:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869354; cv=none; b=dIjHnW1KKP+NTlA4QzkdF+z1R2U+YPG+XQ452yRvJo6YRI2DWuX4v4IZxMHOA/5I9hrCAY9gkVYLw+aDntHofONEY+5/ud4XbQSCjqDiypGi32O2lqreyGCniu/hH7EyO77z4LY5zG6ahmIwvEwBG2upAxOS1b+Tp5mjyzGgz0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869354; c=relaxed/simple;
	bh=dEM8FzCzd1z0Xrp+HDpuV6R3MQX8j/YrIZ/n9oMnVso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWYDvDP0buBI6LFbdTV1oe1Esm6JLHr7SA/u8e/VXvgGmzjrt3cnRhmgVCBVtFo6mom7x1FHlVQmtHrTtLBlzt9xgGwwmg2v+7QE3a67c1v3eDqe5lqdsPv07TIm67Zn6k8tilr0o9uToNhFynRm8vecP+OyxuMZpBYnmkltuWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CywHWB1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CywHWB1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912C0C4CEF9;
	Wed, 30 Jul 2025 09:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869354;
	bh=dEM8FzCzd1z0Xrp+HDpuV6R3MQX8j/YrIZ/n9oMnVso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CywHWB1gPdBr9a29nVSbRZ2gJjCzb7GzauLEmzvFHS5Kr3uculNbM/Eh9hnz37H/6
	 aOxbQsFIAdZTpEwRIzxBKq3QfYK3c4Q408E1E/XapLnfcUIdDb12vF79WoamoEY9Rm
	 YNuLdaMOpr3ED9qyNX8tgPWR1a4fXceMSYtP+Qpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.15 70/92] ice: Fix a null pointer dereference in ice_copy_and_init_pkg()
Date: Wed, 30 Jul 2025 11:36:18 +0200
Message-ID: <20250730093233.453787774@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 4ff12d82dac119b4b99b5a78b5af3bf2474c0a36 upstream.

Add check for the return value of devm_kmemdup()
to prevent potential null pointer dereference.

Fixes: c76488109616 ("ice: Implement Dynamic Device Personalization (DDP) download")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -2301,6 +2301,8 @@ enum ice_ddp_state ice_copy_and_init_pkg
 		return ICE_DDP_PKG_ERR;
 
 	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+	if (!buf_copy)
+		return ICE_DDP_PKG_ERR;
 
 	state = ice_init_pkg(hw, buf_copy, len);
 	if (!ice_is_init_pkg_successful(state)) {


