Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED2F1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07386C433BC;
	Tue, 25 Jul 2023 11:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283002;
	bh=3+l8gCB1fZL2NOurtB5a3UyITugweaUZtL95SnWkToY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkP4j3n+HrVJZCVeQowPgCt22Q290CXk0W6JoPyRmFwYyVtyTvBEnqSAjs5mT/ADn
	 eCoqvw9oQ/0QbEJyZCB8CUftx7/8TMxjCi23XhcinQVzgsiO7OjOuYNEPr2ONAQbhC
	 UHATldawCP84agRgKhCbTV7godDEFNU7rS1dpA/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Tobias Waldekranz <tobias@waldekranz.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/183] dsa: mv88e6xxx: Do a final check before timing out
Date: Tue, 25 Jul 2023 12:45:32 +0200
Message-ID: <20230725104511.676000013@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 95ce158b6c93b28842b54b42ad1cb221b9844062 ]

I get sporadic timeouts from the driver when using the
MV88E6352. Reading the status again after the loop fixes the
problem: the operation is successful but goes undetected.

Some added prints show things like this:

[   58.356209] mv88e6085 mdio_mux-0.1:00: Timeout while waiting
    for switch, addr 1b reg 0b, mask 8000, val 0000, data c000
[   58.367487] mv88e6085 mdio_mux-0.1:00: Timeout waiting for
    ATU op 4000, fid 0001
(...)
[   61.826293] mv88e6085 mdio_mux-0.1:00: Timeout while waiting
    for switch, addr 1c reg 18, mask 8000, val 0000, data 9860
[   61.837560] mv88e6085 mdio_mux-0.1:00: Timeout waiting
    for PHY command 1860 to complete

The reason is probably not the commands: I think those are
mostly fine with the 50+50ms timeout, but the problem
appears when OpenWrt brings up several interfaces in
parallel on a system with 7 populated ports: if one of
them take more than 50 ms and waits one or more of the
others can get stuck on the mutex for the switch and then
this can easily multiply.

As we sleep and wait, the function loop needs a final
check after exiting the loop if we were successful.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Cc: Tobias Waldekranz <tobias@waldekranz.com>
Fixes: 35da1dfd9484 ("net: dsa: mv88e6xxx: Improve performance of busy bit polling")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230712223405.861899-1-linus.walleij@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4db1652015d1d..b69bd44ada1f2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -109,6 +109,13 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 			usleep_range(1000, 2000);
 	}
 
+	err = mv88e6xxx_read(chip, addr, reg, &data);
+	if (err)
+		return err;
+
+	if ((data & mask) == val)
+		return 0;
+
 	dev_err(chip->dev, "Timeout while waiting for switch\n");
 	return -ETIMEDOUT;
 }
-- 
2.39.2



