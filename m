Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1AE45BF7;
	Wed, 15 Nov 2023 22:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK/SVaFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1908CC433C7;
	Wed, 15 Nov 2023 22:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085781;
	bh=uL1Nt0PUkwLKCwgxHRA3279Rm8L3ueA5oqk+cS6d/G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mK/SVaFIdAzgl6WQf21STSKky5I0CsngDV3AcAoZYvee8fpnhdqa8765hhyHQNE1M
	 31PsLhmfzVjz1tirMB+O8aZy3K+c+X+ZSiEpJ9SQnW0MptkcTF5UP9MMRL0WCFt3DB
	 0IADMZup4zaDkUE9maw6l0wN0/fDbiVwy1EIfvao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/119] clk: scmi: Free scmi_clk allocated when the clocks with invalid info are skipped
Date: Wed, 15 Nov 2023 17:00:40 -0500
Message-ID: <20231115220134.183355202@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 3537a75e73f3420614a358d0c8b390ea483cc87d ]

Add the missing devm_kfree() when we skip the clocks with invalid or
missing information from the firmware.

Cc: Cristian Marussi <cristian.marussi@arm.com>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org
Fixes: 6d6a1d82eaef ("clk: add support for clocks provided by SCMI")
Link: https://lore.kernel.org/r/20231004193600.66232-1-sudeep.holla@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-scmi.c b/drivers/clk/clk-scmi.c
index e3cdb4a282fea..d68de3773eb10 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -170,6 +170,7 @@ static int scmi_clocks_probe(struct scmi_device *sdev)
 		sclk->info = handle->clk_ops->info_get(handle, idx);
 		if (!sclk->info) {
 			dev_dbg(dev, "invalid clock info for idx %d\n", idx);
+			devm_kfree(dev, sclk);
 			continue;
 		}
 
-- 
2.42.0



