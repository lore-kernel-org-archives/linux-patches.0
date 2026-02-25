Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD341FE45D;
	Wed, 25 Feb 2026 01:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983426; cv=none; b=rZT65/LLeMsYabXTEVpIHMLjK3sp3n6lKS3bFTX9iyrodPwIrPTU8k1lUZNvjdqrhm1Q3Hc9DgSgvByZNspcv7pPVfIRFZc6p2MrnYDdRV4Ul4Cw6/0qSDmluSJy8eXFpyYKg/YxCrCUT9lEYsldVQSPcTfj4d2KPK8+o6Z6waw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983426; c=relaxed/simple;
	bh=GtS44dLixCMip/VIQIW7Wbow3DAcL2DEbWpCqjRxO+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbi1yvQ2hMoE+JsxuwrPILo41R8bw0jPW9REHj3F6n3YGWwZQT0QTg+CV5MaaQGnvuxfNVXhy+8LXk76e+DEK1P0SUb0kt/V/lQfyMdL5NrqnJahVeW/s/CAaRjlMgs5Dr7lmFBgG401F0mjEUEPzxPVZG9DqOs8JPe1j2IXe2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ii4lM/H4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ii4lM/H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C215EC116D0;
	Wed, 25 Feb 2026 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983425;
	bh=GtS44dLixCMip/VIQIW7Wbow3DAcL2DEbWpCqjRxO+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ii4lM/H4eblbJomcC4rg8YK6dw16tYTsLjr4r2S9Ku98ze/Xpb7ORHK1dZ5jlN5XV
	 c9m7cv3N/119IRDEQRQidsgpux3DWmZY7sBaDP4RPWM1gw8MrZtOTcLSylo54cmlHn
	 a2S8UopgL5FP3NDmQeCHKXSRer8JqVn5vHBBKJyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@mleia.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 546/781] clk: nxp: lpc32xx: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:20:55 -0800
Message-ID: <20260225012413.189569134@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit af943663ccc266e6346e5645b13c0fca71d24395 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 0879768df240 ("clk: nxp: lpc32xx: convert from round_rate() to determine_rate()")
Tested-by: Vladimir Zapolskiy <vz@mleia.com>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nxp/clk-lpc32xx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/nxp/clk-lpc32xx.c b/drivers/clk/nxp/clk-lpc32xx.c
index 23f980cf6a2b5..ae2fa5341a2e4 100644
--- a/drivers/clk/nxp/clk-lpc32xx.c
+++ b/drivers/clk/nxp/clk-lpc32xx.c
@@ -975,10 +975,8 @@ static int clk_divider_determine_rate(struct clk_hw *hw,
 		return 0;
 	}
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       divider->table, divider->width, divider->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, divider->table, divider->width,
+				      divider->flags);
 }
 
 static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



