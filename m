Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7141311CB6
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F8C433CA;
	Wed, 20 Sep 2023 12:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213368;
	bh=2oBxsyESmxgjchCMy7d9QG5smXbYDKJ1xUOYyBL7Sp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElrBSDMda9tVJBYUCJyhyq7ru6rnblAMesGH3Jg/mUDjLjwu0+xd5WFrVoxeIyvZV
	 lRy5OMXr3nzZCp64WqAWOyJsFDrR53IeBSam0pATQZBSk8boNYH1V6DFuK5a9v2psY
	 oQ0ccOMLsIpiJdVFvfoKt8CQeDtuxRaljsUIiLI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/367] serial: tegra: handle clk prepare error in tegra_uart_hw_init()
Date: Wed, 20 Sep 2023 13:29:23 +0200
Message-ID: <20230920112903.449357219@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 5abd01145d0cc6cd1b7c2fe6ee0b9ea0fa13671e ]

In tegra_uart_hw_init(), the return value of clk_prepare_enable() should
be checked since it might fail.

Fixes: e9ea096dd225 ("serial: tegra: add serial driver")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Link: https://lore.kernel.org/r/20230817105406.228674-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 7930f2a81b4c1..2b5d26df5fcfc 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1000,7 +1000,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	tup->ier_shadow = 0;
 	tup->current_baud = 0;
 
-	clk_prepare_enable(tup->uart_clk);
+	ret = clk_prepare_enable(tup->uart_clk);
+	if (ret) {
+		dev_err(tup->uport.dev, "could not enable clk\n");
+		return ret;
+	}
 
 	/* Reset the UART controller to clear all previous status.*/
 	reset_control_assert(tup->rst);
-- 
2.40.1



