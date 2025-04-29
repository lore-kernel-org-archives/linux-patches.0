Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA10253938;
	Tue, 29 Apr 2025 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945856; cv=none; b=IAsnNbMOnqj8D6REnor0Sznj0pu/mKk5GrhnykcH4HFxz8q6dTYe39fzyQDf46O9/URfODWC+OR7G8MjbTxA5SF3zTl85YY9Kz73/yFoT1uxQ6r/1ATSsciHPs1iGP3YzJBmGYyEbFGF9rerRt6ukkvmsbXTg+bBu3m0ZX2gHwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945856; c=relaxed/simple;
	bh=8rNC/WaKacdN9hPDHDJq3lzYWr+C3QBSZ9hdBnbFZo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZx0w0c7WXuoyIa9h8Z3l1Emz5CqieXVcLe8Mwmpij0nmP4MgkQkjnH6Gd2aqpIt4PcCaS95IXgv0DOpSOs4lIzEgYnC2IWoYyQp5co56htPqhhU3x63mo6q+yeYk/3eEFvpGp322xRC98Rl7Iganc1NUeQSCm8cZaB8FXoC8c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKePMgnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKePMgnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D13C4CEE3;
	Tue, 29 Apr 2025 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945856;
	bh=8rNC/WaKacdN9hPDHDJq3lzYWr+C3QBSZ9hdBnbFZo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKePMgnCVvMPM/ohNLlNUspPQTtEO300OO5gZmvEy3Bt1WBCvhOuJTiejFjhmlvs0
	 pa4dVzQ/jRIrXHo3ck45Z65CcTIV77kctjqlOnRka439sPtT0zJ/Fwn302nnkKBLsv
	 flZ1sTnyuKNoUexbcy3nwRYmWky3/70JGst1/g9I=
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
Subject: [PATCH 6.14 072/311] pds_core: handle unsupported PDS_CORE_CMD_FW_CONTROL result
Date: Tue, 29 Apr 2025 18:38:29 +0200
Message-ID: <20250429161123.992084562@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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
index 44971e71991ff..ca23cde385e67 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -102,7 +102,7 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
 		.fw_control.oper = PDS_CORE_FW_GET_LIST,
 	};
-	struct pds_core_fw_list_info fw_list;
+	struct pds_core_fw_list_info fw_list = {};
 	struct pdsc *pdsc = devlink_priv(dl);
 	union pds_core_dev_comp comp;
 	char buf[32];
@@ -115,8 +115,6 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (!err)
 		memcpy_fromio(&fw_list, pdsc->cmd_regs->data, sizeof(fw_list));
 	mutex_unlock(&pdsc->devcmd_lock);
-	if (err && err != -EIO)
-		return err;
 
 	listlen = min(fw_list.num_fw_slots, ARRAY_SIZE(fw_list.fw_names));
 	for (i = 0; i < listlen; i++) {
-- 
2.39.5



