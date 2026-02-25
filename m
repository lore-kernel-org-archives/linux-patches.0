Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E60309DC4;
	Wed, 25 Feb 2026 06:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002659; cv=none; b=kRClovS/pHTkNGTworWdCucfSVhT/VNCnGpAM4mqxp3hgy0Q/O/x2kgFU/hjluqclk2EcW7aZq9qISHwiSoKZg8OClajVV3T6C/D5OO5TTiGBVKIYR6J8jmtfyzl5unp1BK4YK6MmzdyNRk+d4IovXdO2MOGcsiOfsUodsco1wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002659; c=relaxed/simple;
	bh=1RCPb46i4XrQrHMBUPlb/VrKEdZN7a+RttApHL0GVDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJq1Xktelz5FdCQdY2lIffd/QcZgdS/dYdz+t124ysH6p3eCTRdnI+iMNyME2KGxVJmxeGDh+zVaY6/hTxG4SpF53WmWB/6jtNdQ49Tr4OGWR6vbYvr/Ntu6xZZwDOjgPOFkHw5EQnRrEraTn7/0QNW+wTcekA4srJp/Q2VjJhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3+lTAPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3+lTAPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01780C116D0;
	Wed, 25 Feb 2026 06:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002659;
	bh=1RCPb46i4XrQrHMBUPlb/VrKEdZN7a+RttApHL0GVDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3+lTAPs3KOD+dC8Py/RjoYv+nbwJjIN0ClS7vhoYodpieWMCu8cdf4IWK13Luzkp
	 J3Uwd8+eer9kw1MbXocirAfrHKe8r0+YKwwaL0ivHslcL/ta/85prcdb4WZBlz9mVn
	 06h8DkT75Otlk+2IMuce31CFxA/hrp7bsNvhs6Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@mleia.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 437/641] clk: nxp: lpc32xx: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:43 -0800
Message-ID: <20260225012359.123630609@linuxfoundation.org>
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



