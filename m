Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1948746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53433C433C8;
	Sun, 17 Sep 2023 20:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982584;
	bh=KiF0vdXcKyKAGlhm7J3ssHcG4xzpvbeQ/7J5d2RfNf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkZmc6qoZ8DNalmDdRYJGwlparO8Cjg7ktV+y9uo6W7fhZC11+U2nDvaFjj+NkGl7
	 vqB7w0seeHr8DEpGhvv8ydxfAB9uddewRAW5u6/ubeVNY9ZQXU7IxtQcZrAA+NalgV
	 GJWL3Nw/1B/Si+bYmF3+3je0aX6NblnlD/Rq1e0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/511] serial: tegra: handle clk prepare error in tegra_uart_hw_init()
Date: Sun, 17 Sep 2023 21:12:00 +0200
Message-ID: <20230917191120.914704626@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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
index 25f34f86a0852..52d5c72227e79 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -999,7 +999,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
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



