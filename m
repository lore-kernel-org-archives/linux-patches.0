Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2312AE72;
	Tue, 29 Apr 2025 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950336; cv=none; b=OnMzXZu1ddKyU5SFKcBNbxuvdcPZ7l36is9jKE04d9GsSIVi2ES8RPd9WH/BSpDNUkjM5uLC86pWtmveZTM+7vSEh3VsGnUmkTQEh9lQRN0XzYgQuxGsV4uvLI6cs5CbMwCgr8PwOoiZxPTDLLlHOMNTzz0gYt/sjTmlWTeULy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950336; c=relaxed/simple;
	bh=SnLGy9aOOPmr1qBZbPE0k9I2zKAuf4sMwBISMVMxjGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dl3Fuvutpxus3VBIDT+lCsfgsP9K1pHQsUW5rB5EXL2TJNBO4BTs/1SyR2+MdAYvOV0m6n3Uqc0lXYC2mKmrdVjvM7xaP2O/iyxU1b9IXZanjcgQiaWMY73Vo7BDysyjHzI1rpRnlOf6hfcVeb8narnpdJhR4ObSZuEIQ5vjJZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhIsmM54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhIsmM54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF374C4CEE3;
	Tue, 29 Apr 2025 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950336;
	bh=SnLGy9aOOPmr1qBZbPE0k9I2zKAuf4sMwBISMVMxjGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhIsmM54FSXC6j7ub/3Cf08tbT9GfsFRR9QgasOH9nz0IEG+aM/NYnb6dYGNKztRW
	 YXeGkNf+ex7K3b/TU1DCsgUJxepFfIGRKF8FODnbnek1sFl6nlicPJh+6kVVrEEHf7
	 ApUWXCBMZs+Z20h5dkk9h4QenRMnycI/3WmnnPeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/204] pds_core: handle unsupported PDS_CORE_CMD_FW_CONTROL result
Date: Tue, 29 Apr 2025 18:42:30 +0200
Message-ID: <20250429161101.966552360@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 2567daad69cd1107fc0ec29b1615f110d7cf7385 ]

If the FW doesn't support the PDS_CORE_CMD_FW_CONTROL command
the driver might at the least print garbage and at the worst
crash when the user runs the "devlink dev info" devlink command.

This happens because the stack variable fw_list is not 0
initialized which results in fw_list.num_fw_slots being a
garbage value from the stack.  Then the driver tries to access
fw_list.fw_names[i] with i >= ARRAY_SIZE and runs off the end
of the array.

Fix this by initializing the fw_list and by not failing
completely if the devcmd fails because other useful information
is printed via devlink dev info even if the devcmd fails.

Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250421174606.3892-3-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 971d4278280d6..0032e8e351811 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -101,7 +101,7 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
 		.fw_control.oper = PDS_CORE_FW_GET_LIST,
 	};
-	struct pds_core_fw_list_info fw_list;
+	struct pds_core_fw_list_info fw_list = {};
 	struct pdsc *pdsc = devlink_priv(dl);
 	union pds_core_dev_comp comp;
 	char buf[32];
@@ -114,8 +114,6 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (!err)
 		memcpy_fromio(&fw_list, pdsc->cmd_regs->data, sizeof(fw_list));
 	mutex_unlock(&pdsc->devcmd_lock);
-	if (err && err != -EIO)
-		return err;
 
 	listlen = min(fw_list.num_fw_slots, ARRAY_SIZE(fw_list.fw_names));
 	for (i = 0; i < listlen; i++) {
-- 
2.39.5



