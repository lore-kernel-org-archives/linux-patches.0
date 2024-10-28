Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC1218DF8B;
	Mon, 28 Oct 2024 06:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096950; cv=none; b=aXfGFgaCtbNsyrmfnnDyUSVC06VmrpnVnQ70j8N0rMCkRb/Ld8QoU6syWFr49dRqePDpauTYN3T90dwXGNKWSTMZ7vGR5s49OJkK03sFQxnrLu7kBm6OirZ6sKbsdPzOxC4G+Rj3oro61HojpaDegPmBMeXTT/qXrtv9xqPgEtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096950; c=relaxed/simple;
	bh=FTH6Bn7+VXYA00lKJLay2rIDHSeXqgSFcqPTBp5um5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSXUHIHz4yG34IUaQSAhksBwHUdoy8ZpMfmt1oU0i1kcjv3R69gef6WnJsEQVcgiGB4vmY3XpU9J6TlP0xpHhJwhm5DEweQCvFKTq7tepbd+S39NwEVg0MLUBnPNuKY2MEx6USz39gqySqgwBQnZgdlfpuAFt3RZZbSiD+RBdNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA8cbObr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA8cbObr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1163C4CEC3;
	Mon, 28 Oct 2024 06:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096949;
	bh=FTH6Bn7+VXYA00lKJLay2rIDHSeXqgSFcqPTBp5um5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SA8cbObrOCN10/e2xprhi1VkNZVRnRQl/yDLnnYkzTXWPSZrDUQ1+TIVbYb/V+tmB
	 zJzrElC/I2V29yc3kMwwnwneUulNVWJSSu84V86OSJD9rWjMcXdVcNtsTGYMDJJo91
	 dbP03opUfygKvePcitDugLU4e3eTRckcrxDe72VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rashleigh <peter@rashleigh.ca>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 57/80] net: dsa: mv88e6xxx: Fix error when setting port policy on mv88e6393x
Date: Mon, 28 Oct 2024 07:25:37 +0100
Message-ID: <20241028062254.200884273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Rashleigh <peter@rashleigh.ca>

[ Upstream commit 12bc14949c4a7272b509af0f1022a0deeb215fd8 ]

mv88e6393x_port_set_policy doesn't correctly shift the ptr value when
converting the policy format between the old and new styles, so the
target register ends up with the ptr being written over the data bits.

Shift the pointer to align with the format expected by
mv88e6393x_port_policy_write().

Fixes: 6584b26020fc ("net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst")
Signed-off-by: Peter Rashleigh <peter@rashleigh.ca>
Reviewed-by: Simon Horman <horms@kernel.org>
Message-ID: <20241016040822.3917-1-peter@rashleigh.ca>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index ab41619a809b3..c94f2de6401cd 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1699,6 +1699,7 @@ int mv88e6393x_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 	ptr = shift / 8;
 	shift %= 8;
 	mask >>= ptr * 8;
+	ptr <<= 8;
 
 	err = mv88e6393x_port_policy_read(chip, port, ptr, &reg);
 	if (err)
-- 
2.43.0



