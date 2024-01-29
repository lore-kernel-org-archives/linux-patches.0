Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16C6158D71;
	Mon, 29 Jan 2024 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548316; cv=none; b=hiBgyG+2QiATOa8N22lzGiaowQLCLYZdvuQPdN+g/8xd9sDGm6IzfapjTUoh5aC8mDJfi0Ljhv7ZbtOe6NTapDhFcpzNoW4kyI1YWab2NOSfbt3B0M9ROnrcUjND6O9MimA1uaHnVQjEq0qcfTLGDkynRaS9FhTrHrL9sTxXnps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548316; c=relaxed/simple;
	bh=9MRfjZ2YpF3DK9yNYn+lT177zjKRqKSVP1lo152t/y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0FLOnVr4bAlAbSfwNLpWzHSAmkQuAsHVbQCibEdetqjKboiS1/zPLer9uhu1y+UPJyVuRDPZBy0+MFbYFaDDfnPQoLh/7ysa87b8/Fxr6eXlnEh5HRVdtmrOlyVO4WLOKK4CrEIp/KRrAnQ40877Mtjjf6Qr2KgWEXx0bM8IgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfQGgPuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfQGgPuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994E7C433C7;
	Mon, 29 Jan 2024 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548316;
	bh=9MRfjZ2YpF3DK9yNYn+lT177zjKRqKSVP1lo152t/y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfQGgPuU6OdsmBfktEg3OlpAM/jkweznfz9icjuU5NXBdPjLRlpYQPdTBa9mTR43/
	 0ZNu/l3E+91muasZrkFgOQqPF5mOxJ7Gtr1GrSVu0rUu1aK903WYcGNwtNaMlkWeZm
	 3Is6cT9a3lMGQ3Zjvr2rg4sLXKH5UqcPZrRcXRIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 320/346] firmware: arm_scmi: Fix the clock protocol version for v3.2
Date: Mon, 29 Jan 2024 09:05:51 -0800
Message-ID: <20240129170025.888411804@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 27600c96e2ffa6c1b2cb378ddc75c6620c628d04 ]

The clock protocol version as per the SCMI v3.2 specification is 0x30000.
Enable the v3.0 clock protocol features only when clock protocol version
equals 0x30000.

The previous beta version of the spec had this value set to 0x20001 and
th same value trickled down from the initial development. The version
update were missed in the driver.

Fixes: e49e314a2cf7 ("firmware: arm_scmi: Add clock v3.2 CONFIG_SET support")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240109150106.2066739-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/clock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 42b81c181d68..96b4f0694fed 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -951,8 +951,7 @@ static int scmi_clock_protocol_init(const struct scmi_protocol_handle *ph)
 			scmi_clock_describe_rates_get(ph, clkid, clk);
 	}
 
-	if (PROTOCOL_REV_MAJOR(version) >= 0x2 &&
-	    PROTOCOL_REV_MINOR(version) >= 0x1) {
+	if (PROTOCOL_REV_MAJOR(version) >= 0x3) {
 		cinfo->clock_config_set = scmi_clock_config_set_v2;
 		cinfo->clock_config_get = scmi_clock_config_get_v2;
 	} else {
-- 
2.43.0



