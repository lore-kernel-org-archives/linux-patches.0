Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6636630EF97;
	Wed, 25 Feb 2026 06:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002664; cv=none; b=IcTqPSGsZPxu/w0mJQBRCdYg5o8gANWlAckCW1XtN1DJ1AGlHBglRN8TpVwmpnKCrpafOnQXekasfFeU8TzYpP/VfWMR2pMtsSmy7qD0BoD6vUzSMmooNuvr8GxMxRMwH3wmn303kks+5zBMLY7psg+5ODG0Cfhq9KQlFIK9Gn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002664; c=relaxed/simple;
	bh=asVjkajU7e7DUBMVY2y0yYFtiFdZXrthDNs93Hl2N+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxbiCZIAlyM9gxT0lFas5u3Wdp9Zesoo2Myx0SyJIF3XvPYX71E2L8U3DHVw6EvxLNfMcjVxDgYdCDHi7v4FiMmvrwf4+FzsGQrqjQVN+a+TEwchSC2bKtknWlnKJjXZC5UlgX9J5/43TjDKHH1ddKUynaCJohcliOykHvgsCx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r045LiyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r045LiyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7C2C19422;
	Wed, 25 Feb 2026 06:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002664;
	bh=asVjkajU7e7DUBMVY2y0yYFtiFdZXrthDNs93Hl2N+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r045LiyWbB9jCy9Q1Klh7G7wg1HQcCwzs9DmXGl7kwMaMU4v0Ip28Hg1jA83Ydky8
	 AIwYc6tuYo9mAGC8dfxbooN1YSkb6zgn4hL6Q9l8AEsfWpZa8iAYm5flzXHCwhI7CT
	 DftQ4EEd7rx28tmUZxmzQXCq21FSG0M6hjdElacg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 444/641] clk: zynqmp: divider: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:50 -0800
Message-ID: <20260225012359.283465288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 30a807808c69a1907001ffb79289237a2ee97cfa ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 0f9cf96a01fd ("clk: zynqmp: divider: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/divider.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/zynqmp/divider.c b/drivers/clk/zynqmp/divider.c
index c824eeacd8ebd..de6f478d527d8 100644
--- a/drivers/clk/zynqmp/divider.c
+++ b/drivers/clk/zynqmp/divider.c
@@ -151,8 +151,9 @@ static int zynqmp_clk_divider_determine_rate(struct clk_hw *hw,
 
 	width = fls(divider->max_div);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       NULL, width, divider->flags);
+	ret = divider_determine_rate(hw, req, NULL, width, divider->flags);
+	if (ret != 0)
+		return ret;
 
 	if (divider->is_frac && (clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT) &&
 	    (req->rate % req->best_parent_rate))
-- 
2.51.0



