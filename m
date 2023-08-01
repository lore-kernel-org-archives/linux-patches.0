Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BE81FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98639C433C8;
	Tue,  1 Aug 2023 09:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883344;
	bh=WuCR0/jMG8wNcm0ECVWI4tXf0cTrIGhu3I3UQcaBtMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8A/crK3lgedsQg8m4HQb/emeXSyfZH6qAdXsjc5MhBHEGRYNrG42RsMGK4iw7iLa
	 /E7hjLQZf29s4tVzjgmzbcFTtO50U90/bqyLGbHF7eOg1Vhhon3HJbtczYjafIS9Yx
	 9xgkkA3iilBElm4qMHYEoWQj5sCglPOTgfj4CJys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 203/239] net: dsa: qca8k: enable use_single_write for qca8xxx
Date: Tue,  1 Aug 2023 11:21:07 +0200
Message-ID: <20230801091933.127979965@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

commit 2c39dd025da489cf87d26469d9f5ff19715324a0 upstream.

The qca8xxx switch supports 2 way to write reg values, a slow way using
mdio and a fast way by sending specially crafted mgmt packet to
read/write reg.

The fast way can support up to 32 bytes of data as eth packet are used
to send/receive.

This correctly works for almost the entire regmap of the switch but with
the use of some kernel selftests for dsa drivers it was found a funny
and interesting hw defect/limitation.

For some specific reg, bulk write won't work and will result in writing
only part of the requested regs resulting in half data written. This was
especially hard to track and discover due to the total strangeness of
the problem and also by the specific regs where this occurs.

This occurs in the specific regs of the ATU table, where multiple entry
needs to be written to compose the entire entry.
It was discovered that with a bulk write of 12 bytes on
QCA8K_REG_ATU_DATA0 only QCA8K_REG_ATU_DATA0 and QCA8K_REG_ATU_DATA2
were written, but QCA8K_REG_ATU_DATA1 was always zero.
Tcpdump was used to make sure the specially crafted packet was correct
and this was confirmed.

The problem was hard to track as the lack of QCA8K_REG_ATU_DATA1
resulted in an entry somehow possible as the first bytes of the mac
address are set in QCA8K_REG_ATU_DATA0 and the entry type is set in
QCA8K_REG_ATU_DATA2.

Funlly enough writing QCA8K_REG_ATU_DATA1 results in the same problem
with QCA8K_REG_ATU_DATA2 empty and QCA8K_REG_ATU_DATA1 and
QCA8K_REG_ATU_FUNC correctly written.
A speculation on the problem might be that there are some kind of
indirection internally when accessing these regs and they can't be
accessed all together, due to the fact that it's really a table mapped
somewhere in the switch SRAM.

Even more funny is the fact that every other reg was tested with all
kind of combination and they are not affected by this problem. Read
operation was also tested and always worked so it's not affected by this
problem.

The problem is not present if we limit writing a single reg at times.

To handle this hardware defect, enable use_single_write so that bulk
api can correctly split the write in multiple different operation
effectively reverting to a non-bulk write.

Cc: Mark Brown <broonie@kernel.org>
Fixes: c766e077d927 ("net: dsa: qca8k: convert to regmap read/write API")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 09b80644c11b..efe9380d4a15 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -576,8 +576,11 @@ static struct regmap_config qca8k_regmap_config = {
 	.rd_table = &qca8k_readable_table,
 	.disable_locking = true, /* Locking is handled by qca8k read/write */
 	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
-	.max_raw_read = 32, /* mgmt eth can read/write up to 8 registers at time */
-	.max_raw_write = 32,
+	.max_raw_read = 32, /* mgmt eth can read up to 8 registers at time */
+	/* ATU regs suffer from a bug where some data are not correctly
+	 * written. Disable bulk write to correctly write ATU entry.
+	 */
+	.use_single_write = true,
 };
 
 static int
-- 
2.41.0



