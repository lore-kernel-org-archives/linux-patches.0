Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76945248191;
	Tue, 29 Apr 2025 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945859; cv=none; b=DLqzLSoNsAT6U1yvbH6lY4BHxQUvw0eNHKP8HOn70bwN4rSRsz4t5N7smWjJzyQJzT4Yl3zLQssQe5Cqp71OGnXXy7olgsANAPKXzdxSEVSHS3n2dwYp+y7vh0CJQjfmaDwLmp8fAf7OOF7+2ZNDD6TXKJcbUK3H527kKuHZw+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945859; c=relaxed/simple;
	bh=rIeM5bXhGHBHVLESof5aBFBl9+I91DV+NHfEge0WAYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIeekNbPCmkdoKHMFSCFST0I7ITVibYvY8qCVW59PhXe7Uj2jSEtnfYecIyPErvReV2mI6ZA60C3dHetFoJS8eKPPdolwqyjRXqTI5nWAVcUZQ0nzX/Bd7piEpy7TwQZkKmdVljyBJSKoeiY0CgcEqmS6c/Uam2TurWj1L2kRTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/y3/DH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/y3/DH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA32C4CEE3;
	Tue, 29 Apr 2025 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945859;
	bh=rIeM5bXhGHBHVLESof5aBFBl9+I91DV+NHfEge0WAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/y3/DH4Xw511q9Bv9iB3RCvbSv+EBbak1EgWv3p5YSKTAP/UNV62XvA0WMonH5bA
	 4Se5ExFJ51Gxo+ju3cuypEoIP+ATsSbnbdiCfQgPLqCDgxn3e/hu0jbQ4hMrGZhRmw
	 4OEqGUApsze/XSo/MFt9jqazTNPRe6Q7p9aeT2+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 073/311] pds_core: Remove unnecessary check in pds_client_adminq_cmd()
Date: Tue, 29 Apr 2025 18:38:30 +0200
Message-ID: <20250429161124.031726501@linuxfoundation.org>
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

[ Upstream commit f9559d818205a4a0b9cd87181ef46e101ea11157 ]

When the pds_core driver was first created there were some race
conditions around using the adminq, especially for client drivers.
To reduce the possibility of a race condition there's a check
against pf->state in pds_client_adminq_cmd(). This is problematic
for a couple of reasons:

1. The PDSC_S_INITING_DRIVER bit is set during probe, but not
   cleared until after everything in probe is complete, which
   includes creating the auxiliary devices. For pds_fwctl this
   means it can't make any adminq commands until after pds_core's
   probe is complete even though the adminq is fully up by the
   time pds_fwctl's auxiliary device is created.

2. The race conditions around using the adminq have been fixed
   and this path is already protected against client drivers
   calling pds_client_adminq_cmd() if the adminq isn't ready,
   i.e. see pdsc_adminq_post() -> pdsc_adminq_inc_if_up().

Fix this by removing the pf->state check in pds_client_adminq_cmd()
because invalid accesses to pds_core's adminq is already handled by
pdsc_adminq_post()->pdsc_adminq_inc_if_up().

Fixes: 10659034c622 ("pds_core: add the aux client API")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250421174606.3892-4-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 2babea1109917..b76a9b7e0aed6 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -107,9 +107,6 @@ int pds_client_adminq_cmd(struct pds_auxiliary_dev *padev,
 	dev_dbg(pf->dev, "%s: %s opcode %d\n",
 		__func__, dev_name(&padev->aux_dev.dev), req->opcode);
 
-	if (pf->state)
-		return -ENXIO;
-
 	/* Wrap the client's request */
 	cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
 	cmd.client_request.client_id = cpu_to_le16(padev->client_id);
-- 
2.39.5



