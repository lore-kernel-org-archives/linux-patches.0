Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1CB1D1E70;
	Wed,  2 Oct 2024 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877572; cv=none; b=tukCZTgv+9CW0yGHue179zrVuDNQi5S56LBrIFxdxgQhq+0oaSIBGYs0hBkP3BLiRWqWteq3weRMj0HRZixWz7cACxE2rZU7IDH4sauuVSC3g9EA+0hSxvVN5oUokXQvubY3bx+MLLtLPC2/u6QHe90W3k2LxpZyxvgIY93LjUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877572; c=relaxed/simple;
	bh=9Lx/tEWDQjylIE8JXTFB510CgXePII6FvN8/qwW1TYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llpqFJi51vxpWSegsQXzVfkejBQoT+YG8JZVcbN0zy8XB5bM+4D3kATpGuGdSsiBzopytViC4LKKcc+QO6ozcHwuQJGPDCsUwCy7XmbHmtezR6etXdKnc+0jf1B1sPqqFPkKxHb9Fs9jH8ZiWfehfv96nqQWfAP+4uJ1DQknJHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pMIEo3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pMIEo3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0179CC4CECD;
	Wed,  2 Oct 2024 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877572;
	bh=9Lx/tEWDQjylIE8JXTFB510CgXePII6FvN8/qwW1TYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pMIEo3V++/rUJO2xLd8cbltHSsLKZ/YsaS2/9ap4ChDEDkJnykED9g840pwxjGbG
	 bzBt4IrDPR1SkDxN17BMGMjimxbAXKOMDVW/o7R3kk/6MzSViL3u6tBtTYYqGxB/6/
	 Efm96m/nFUvEx7+dwF8Jsx2CHYDeIeWue95RhZTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 120/634] firmware: arm_scmi: Fix double free in OPTEE transport
Date: Wed,  2 Oct 2024 14:53:40 +0200
Message-ID: <20241002125815.848344766@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



