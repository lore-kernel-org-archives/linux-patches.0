Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F12F2472A6;
	Tue, 11 Nov 2025 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825212; cv=none; b=b214eE9J6bPnTM/mV57riJP13Idwosh1jjAClw0+WTKlFGew8ae3X88HBTtWvxMIq1Cd/8J4BYl94X4JjN89XfeEh901M+KxqqCTIVkLziZ1t1svSiIKSiS6gQxb40IxdnqySkJhgHfKneC+vwyHkjzMcLPZtXapz5iyrIwtoNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825212; c=relaxed/simple;
	bh=s1OtRQEnmoPbGBMT1KbarnsgBxcE2dyPdtk8ksFG8BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFwldDn9wW4KHCdsKzAH127D+WiZq3uIG61vpqY3c/uU0uEtaOLj5VVienv7jiouL5xmse4mLRGHzTGu3mO/1mt5Hp8xh63MTfvYre8xOssUghDBoz76LcNQiGX5mgp/OS8WCSjymfpr2LjbKe0AJk3r0nvk28oS44vC8RVD5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms0zYPJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms0zYPJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B6DC116B1;
	Tue, 11 Nov 2025 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825212;
	bh=s1OtRQEnmoPbGBMT1KbarnsgBxcE2dyPdtk8ksFG8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ms0zYPJBUQFam6n4kVrTt2hEOKrteZJ0sxiAeTV3eEiCVfyih0XX/AMWZ0spiarFp
	 776vxFJ2rOqGaoaaN/slK+JvqnLumS60wvZniOyew5tW4Yhseli9vbd+Oqx6R2qGwE
	 KcxLWrUXRYMh+HnlisUWhB+/u5LxB3VVHKdIdF6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 706/849] clk: at91: clk-master: Add check for divide by 3
Date: Tue, 11 Nov 2025 09:44:36 +0900
Message-ID: <20251111004553.503888364@linuxfoundation.org>
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

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit e0237f5635727d64635ec6665e1de9f4cacce35c ]

A potential divider for the master clock is div/3. The register
configuration for div/3 is MASTER_PRES_MAX. The current bit shifting
method does not work for this case. Checking for MASTER_PRES_MAX will
ensure the correct decimal value is stored in the system.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-master.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index 7a544e429d34e..d5ea2069ec83a 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -580,6 +580,9 @@ clk_sama7g5_master_recalc_rate(struct clk_hw *hw,
 {
 	struct clk_master *master = to_clk_master(hw);
 
+	if (master->div == MASTER_PRES_MAX)
+		return DIV_ROUND_CLOSEST_ULL(parent_rate, 3);
+
 	return DIV_ROUND_CLOSEST_ULL(parent_rate, (1 << master->div));
 }
 
-- 
2.51.0



