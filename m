Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D173E3446B3;
	Tue, 11 Nov 2025 01:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825259; cv=none; b=HnaSIhZg5HTxQ9LVgL2li8bRZ/1sM5vD9LvOUdohUWLoRXjPIyhHScrpBskprhoYsczZFZ6UiXuz4V/MZVXPk4b5QFgjcU7VU3xdpNVoWQr7MGtGLaySfPooPlAX/K4N091RWOFthWYSf95ArbKH4fntwE3UzqdJBzjr8uixegE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825259; c=relaxed/simple;
	bh=R9ewcabJaCle14q40T8gOgSk29vs2Ldp9M7gMXTzeTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBCWvZ2pOclzmkk6ddTuxS1gwmsW+MjwmnQTjlhHiQNUbRzsEbawKDXY2Ixq89o7VLgO6qmq/eOIKcYshEMNxDBs5ifrGD8eOIHnyyc+YqwD0tTghXHCN28XCg9eDeMsDFN7/64R8GFDgPuMqZKYcegIPfVkOl1qwmEeeu+HFgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEF8gKkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEF8gKkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F50C4CEF5;
	Tue, 11 Nov 2025 01:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825259;
	bh=R9ewcabJaCle14q40T8gOgSk29vs2Ldp9M7gMXTzeTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEF8gKkbuSzUWyu/2pX46L1DWdx1EIpvPytAnBTWX9/+IBOM1u3IjQdf6rWSBwmBW
	 I+gtoGkOd5ICz31CcqBv+qi6pB0VRyRihWzitw11lQFAg8XOKq93XmoR+g5fqrvAGr
	 hrYenmsaWEnJWCQkUnpS6Kt6mr1jEn2fa+uGLw3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 711/849] clk: clocking-wizard: Fix output clock register offset for Versal platforms
Date: Tue, 11 Nov 2025 09:44:41 +0900
Message-ID: <20251111004553.627132443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit 7c2e86f7b5af93d0e78c16e4359318fe7797671d ]

The output clock register offset used in clk_wzrd_register_output_clocks
was incorrectly referencing 0x3C instead of 0x38, which caused
misconfiguration of output dividers on Versal platforms.

Correcting the off-by-one error ensures proper configuration of output
clocks.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
index 0295a13a811cf..f209a02e82725 100644
--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -1108,7 +1108,7 @@ static int clk_wzrd_register_output_clocks(struct device *dev, int nr_outputs)
 						(dev,
 						 clkout_name, clk_name, 0,
 						 clk_wzrd->base,
-						 (WZRD_CLK_CFG_REG(is_versal, 3) + i * 8),
+						 (WZRD_CLK_CFG_REG(is_versal, 2) + i * 8),
 						 WZRD_CLKOUT_DIVIDE_SHIFT,
 						 WZRD_CLKOUT_DIVIDE_WIDTH,
 						 CLK_DIVIDER_ONE_BASED |
-- 
2.51.0



