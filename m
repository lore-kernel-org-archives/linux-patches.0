Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007EB1D014A;
	Wed,  2 Oct 2024 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875539; cv=none; b=hOxhd0vk06BhEF1v2ohrw1gjJ5jmFOUJtF4Q97UMcjyqc+ttVnnu0BcwwjOYPG79BvXHsiDHJa1Y2ji6zhHkD9lR41CEDsOY7jnnTUe4dzb7pMMLzZGxuS5SXtpkvAQlmsKQnmiNkWZh08lZpum21Y98HguvdVx8k5WUlyx6/4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875539; c=relaxed/simple;
	bh=CXaxs7Msd3gLpBsPDcDCcGOzFXA16s1muTFEiwpA6cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVPEWkIOIJ5u1rSBQ0ywz5VkCoQvG5myIrcjvIWsQ2ViQQj6GAQYGQZher41RgAIFmAVSBNxywno8wiCadpCfBEObfCCmvvYVcgtwN7yF6s/Cdqzgb+a39mHv2xt00OcVDSfZZOjIYrjkSflpB9sPghtrm2ybehLbqZPhdeNvjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ+YH5KR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ+YH5KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F216C4CEC5;
	Wed,  2 Oct 2024 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875538;
	bh=CXaxs7Msd3gLpBsPDcDCcGOzFXA16s1muTFEiwpA6cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ+YH5KRhDQdd3EAicw1L0MydMq6Le+vaHyrgrk56R1fspABhYzQsRt1v9iHIevgu
	 M9GtsdypJOXy6psvepa63L+jYgwv43UajYsSr0Gf96qfj8dwUx8K4rBhpM1op+9AFX
	 n86klIN+wHW+aJUJLbNzLfMogTdgfJZVpSrRkMEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 136/695] firmware: arm_scmi: Fix double free in OPTEE transport
Date: Wed,  2 Oct 2024 14:52:14 +0200
Message-ID: <20241002125827.915238137@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4e7944b91e385..0c8908d3b1d67 100644
--- a/drivers/firmware/arm_scmi/optee.c
+++ b/drivers/firmware/arm_scmi/optee.c
@@ -473,6 +473,13 @@ static int scmi_optee_chan_free(int id, void *p, void *data)
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



