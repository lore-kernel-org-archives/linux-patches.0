Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B807D389116;
	Tue, 10 Mar 2026 11:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141244; cv=none; b=MDwMraQnGMTLw40c7uiTrCWgApmeFKEXwrntEo5rHILTon94Fq1WfQ67fXgd4FvOwUedXDXotlgE7lvuQzdrJF+2D2PH+rGn+wf+ESeRo7JNONq2Nbnhf5PXL7/Q4w2lZsnuVKXHdu7nKCRqovaUJgeLXue/KvKY6jgGbScvpz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141244; c=relaxed/simple;
	bh=qOuyokyHXQ3dYd8oIacCWeNuFw9iZo7CAmd+529TBt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odRLrs4z9MxeQLABNpyZ3ndZr9deYCOftrgsdT/SJVJ8bsnylexbaDJO9eeLuWqhIhBu+0vhtjvssw5/6QF4a4XDWIzuzDEmWJJX6R0bPTPMgemFVU9cezlYmbHOcqIs5opDKeVjKgKCpzf6YK0ur9TcCfoVl2EBV6//q6Bir/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ev3ArdvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ev3ArdvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84DEC2BC86;
	Tue, 10 Mar 2026 11:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141244;
	bh=qOuyokyHXQ3dYd8oIacCWeNuFw9iZo7CAmd+529TBt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ev3ArdvOEqErihOHiDiQnWlFQ9NAbcZxne5lEv/GHur6M3Nj25AeaWPAlx7pNroc5
	 cl2l8oE/0Rs+VGajvbHRbJ6bw0gH8GKx+WLVw59/wXdj7UI9P3+W211VcPKuriSLcM
	 gN0kEe+Zr5SaszRC6JsHYC3/0gBzJ1qLVRujygyvR360dPUnE1PJChkNp1KmN+tpa1
	 19eTXwyYU+N9eorOlU1S0YCFf1H2vEUZB9WXndNlZd+KQTbYk77KAPrZVdvuHhceKO
	 ANzdXdFxBbYAQk6KpAnurgd5Jp2qcyWKy4/vfCf71U/Q3ariibMGzW2pjzT+I+BvYe
	 Y8oSe5KAg6ckA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 247/311] ice: fix adding AQ LLDP filter for VF
Date: Tue, 10 Mar 2026 07:04:54 -0400
Message-ID: <4b44c18a2a8b495665c70069be3f457257a9f465.1773140655.git.sashal@kernel.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit eef33aa44935d001747ca97703c08dd6f9031162 ]

The referenced commit came from a misunderstanding of the FW LLDP filter
AQ (Admin Queue) command due to the error in the internal documentation.
Contrary to the assumptions in the original commit, VFs can be added and
deleted from this filter without any problems. Introduced dev_info message
proved to be useful, so reverting the whole commit does not make sense.

Without this fix, trusted VFs do not receive LLDP traffic, if there is an
AQ LLDP filter on PF. When trusted VF attempts to add an LLDP multicast
MAC address, the following message can be seen in dmesg on host:

ice 0000:33:00.0: Failed to add Rx LLDP rule on VSI 20 error: -95

Revert checking VSI type when adding LLDP filter through AQ.

Fixes: 4d5a1c4e6d49 ("ice: do not add LLDP-specific filter if not necessary")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 785bf5cc1b25e..a400bf4f239aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -6429,7 +6429,7 @@ int ice_lldp_fltr_add_remove(struct ice_hw *hw, struct ice_vsi *vsi, bool add)
 	struct ice_aqc_lldp_filter_ctrl *cmd;
 	struct libie_aq_desc desc;
 
-	if (vsi->type != ICE_VSI_PF || !ice_fw_supports_lldp_fltr_ctrl(hw))
+	if (!ice_fw_supports_lldp_fltr_ctrl(hw))
 		return -EOPNOTSUPP;
 
 	cmd = libie_aq_raw(&desc);
-- 
2.51.0

