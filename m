Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5491D1E8B;
	Wed,  2 Oct 2024 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879480; cv=none; b=TU0zFTIoSdBVdG6BYxyCkyrbw66wZL3SFYuJxmfAFw6O1XZD+if7Q/WxuMXJSMy5UfbQ32Wq0rpjNFZjjCJcKyRSV3Dt6dirRFsl0CF9IYimS5m4FMFOudH0TXwx+ZsYFzJmFlZ9tZypK/db2GTec9xeHB0d6qrypkahwP6ZQkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879480; c=relaxed/simple;
	bh=o9NAXaFUdV+CSOBWxfDe0WTt7HtIGt1FVLACXes4EVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWIilOseWcGaT64j2kY0h3TCI/tBk+yoc2o7NdMS0loSQGXdQPZb7YuuyHcRRBBa2eyNlc2kZ8w3PAhyNUJcC7/cz/3rYMDVedJ1qSF6d3DaDyfyzNDKFfnUoj5z9/kgQuoFOv0G0mJpOT5J44fji0wTyyIRsPn7Z31bFmGnaz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeBk4Vmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeBk4Vmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95B0C4CEC2;
	Wed,  2 Oct 2024 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879480;
	bh=o9NAXaFUdV+CSOBWxfDe0WTt7HtIGt1FVLACXes4EVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeBk4Vmv30HTdFM0nANVBQj8JnO3icts994GXup52oD5YuyeKGyGHqGj69S7agsBu
	 mO1yiwO0/LSlnEpkMasVxA16J/mPSPRuWhofBX1aVH0HOBZFY3S9GkmBL1gWS/rRGS
	 62JlRLRChxNHwrlV4PuCD7nC6ZGP5dzUo9LY+EPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/538] firmware: arm_scmi: Fix double free in OPTEE transport
Date: Wed,  2 Oct 2024 14:55:31 +0200
Message-ID: <20241002125755.859749465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e123de6e8c67a..aa02392265d32 100644
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



