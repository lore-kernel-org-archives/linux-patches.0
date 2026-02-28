Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF56313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301015; cv=none; b=VMyed7mBaaxrF5rS+0hYYI8af9ETqr1FuPh8aPNz7hG0vAOjnzlanrdOYR1YtzyUw+1NedwPCmOPxL7CBYsWEqOp/2N/h0oGjAGrxf9XUIbBRUTyQBGm6mInxjcdD7kpiu59B8ln4VZk7gms+NQHMMua/9LmtSO05cJf+xcbo6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301015; c=relaxed/simple;
	bh=TnvSg15UR2X/ygSn0YbA1cSX1IgZUR41guHeiTLTJDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz50Vkg1BA3NqF14UyuMgn9yYv8aghICSHZvUN/14Sl0OMZ0HEFKPP2h48+yitAxevuvgbIBNAH+hziG8h/4SCnUkK7Lk5WcFNpdtHTpLIK14n1IsDi6AsqlXmaaooQ2xNj+b4YHU+LfoVNmB/Kt0Q9p+c+CNYSB3gJFo8/XDDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7HFhLjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7HFhLjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79545C19423;
	Sat, 28 Feb 2026 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301015;
	bh=TnvSg15UR2X/ygSn0YbA1cSX1IgZUR41guHeiTLTJDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7HFhLjgkM4sEWS/r0kxsoBPkRe8nB6jYCfb4c6fwJqI51+OMOMy+kcAtTzX6/tHM
	 j4SsbBq3rXn34QB1KH0HaHcGNi2SMWxlLKDPv55cyBj+0YN0lm5PTpGp86JuRrtsu5
	 NrVKn4abb7ioQhand6eroLF7GAX9G6Ck9WntGYwS4kFZAYEVBmafcwN2X43DQlbKvF
	 KVOV2ZPb+l9EmAoCwYraTHuHcxbTbcOR+HkmaruF7Ylu9E3WpT0p70YbHkDkXNybJE
	 wfHITH1tRfrFxkQBs6D185ec8kUaeeVHaFzRKg2Gf6zd69M8cvVgsxbG4q+2+4UX/m
	 8E3S48oa3T/+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/752] spi: spi-mem: Limit octal DTR constraints to octal DTR situations
Date: Sat, 28 Feb 2026 12:37:41 -0500
Message-ID: <20260228174750.1542406-150-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8618271887ca10ac5108fe7e1d82ba8f1b152cf9 ]

In this helper, any operation with a single DTR cycle (like 1S-1S-8D) is
considered requiring a duplicated command opcode. This is wrong as this
constraint only applies to octal DTR operations (8D-8D-8D).

Narrow the application of this constraint to the concerned bus
interface.

Note: none of the possible XD-XD-XD pattern, with X being one of {1, 2,
4} would benefit from this check either as there is only in octal DTR
mode that a single clock edge would be enough to transmit the full
opcode.

Make sure the constraint of expecting two bytes for the command is
applied to the relevant bus interface.

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260109-winbond-v6-17-rc1-oddr-v2-3-1fff6a2ddb80@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 064b99204d9ac..71e3eaf59df97 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -175,8 +175,19 @@ bool spi_mem_default_supports_op(struct spi_mem *mem,
 		if (op->data.swap16 && !spi_mem_controller_is_capable(ctlr, swap16))
 			return false;
 
-		if (op->cmd.nbytes != 2)
-			return false;
+		/* Extra 8D-8D-8D limitations */
+		if (op->cmd.dtr && op->cmd.buswidth == 8) {
+			if (op->cmd.nbytes != 2)
+				return false;
+
+			if ((op->addr.nbytes % 2) ||
+			    (op->dummy.nbytes % 2) ||
+			    (op->data.nbytes % 2)) {
+				dev_err(&ctlr->dev,
+					"Even byte numbers not allowed in octal DTR operations\n");
+				return false;
+			}
+		}
 	} else {
 		if (op->cmd.nbytes != 1)
 			return false;
-- 
2.51.0

