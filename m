Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7590C1B85D7;
	Mon, 14 Oct 2024 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917568; cv=none; b=QjAwgSbBXdvA845Wt/1VHubQRonhX3GNeKXU2sWlnfZofSvxlvwdnf4XApAH12PovbNyNhcIVuAT8JWFpBDN3wKx63+7pIAIGU6frfikFPfMXFOETVg5/GqzO5t1kqdZlfofi2gdGhpwUWcmJVS94AeJl+vkPqx9zNx9ipTdCbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917568; c=relaxed/simple;
	bh=CIiFeIYVAPiaxw0j3YN4WUVjF36dgaeFJoIVhVSJ0vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhAN0+7sIeAvoY+xApJAaPihbj81B3dXqatXH4us8fG9eUP3flp4HqA4GvUOldBjRkFoZka+vrtzUgI8TRaKAPSA2Me024S74eIvPx6XN3lE3O1XxaNzP15yuxPqU1aMfE6BpY0Xfykb8IJ6xskphRH+tRTQumfXutZHePwu0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSF6CTYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSF6CTYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF09C4CECF;
	Mon, 14 Oct 2024 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917568;
	bh=CIiFeIYVAPiaxw0j3YN4WUVjF36dgaeFJoIVhVSJ0vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSF6CTYE7Za92TROT1psp0zhRMsOqnwemf50umEvVHB3qZtYjS+Xe+UUqZxFeMiCy
	 IkutdKgVeWHR/v3bXujCuw5a5Lb1oIuHK81iE1/6bg2kZRxiN2tPQdtLaQUipG1dpx
	 CEYUbYibXxB5+TFCc0INlMbxjFmMCZtPyP1UD918=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/798] firmware: arm_scmi: Fix double free in OPTEE transport
Date: Mon, 14 Oct 2024 16:10:24 +0200
Message-ID: <20241014141220.689551537@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit e98dba934b2fc587eafb83f47ad64d9053b18ae0 ]

Channels can be shared between protocols, avoid freeing the same channel
descriptors twice when unloading the stack.

Fixes: 5f90f189a052 ("firmware: arm_scmi: Add optee transport")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Peng Fan <peng.fan@nxp.com>  #i.MX95 19x19 EVK
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Message-Id: <20240812173340.3912830-2-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/optee.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/arm_scmi/optee.c b/drivers/firmware/arm_scmi/optee.c
index 2a7aeab40e543..f5f6ec83d3e1f 100644
--- a/drivers/firmware/arm_scmi/optee.c
+++ b/drivers/firmware/arm_scmi/optee.c
@@ -467,6 +467,13 @@ static int scmi_optee_chan_free(int id, void *p, void *data)
 	struct scmi_chan_info *cinfo = p;
 	struct scmi_optee_channel *channel = cinfo->transport_info;
 
+	/*
+	 * Different protocols might share the same chan info, so a previous
+	 * call might have already freed the structure.
+	 */
+	if (!channel)
+		return 0;
+
 	mutex_lock(&scmi_optee_private->mu);
 	list_del(&channel->link);
 	mutex_unlock(&scmi_optee_private->mu);
-- 
2.43.0



