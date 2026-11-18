Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041280;
	b=0IMbfhWs0id4TXVr2TfPuywUACRPGDulaQM3LCEA84ULgJ+U4P4HJWY6NzkK/B3AR/Fd
	 3eYaLyM78zRhgsmUIh3wMfUIsTzP/tY/d3dn/V7w7uwA3OL3NPDGQUOsIu6WzbyK879KJ
	 ZPTgL0lFGxDlQflkfsbG008/5kJWMyLSrltsaz5YVcwABqBqzuru/FMjnd8RUSr6FPgz/
	 qvESZX9e/XLM9XzeuHASM7vS1ZkxRa0FhTvDAsAvxAox3gJdWyCI87PYXX6tOSGTioXHQ
	 WJMBaSxdvyXtZ9oJNmYmnS7aPH3sB0bSXOW4NJDbtZrNc8dHPKnlT7TPtEhPbPUSK1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nnRKFikjoVbOi0UredcU0eOfCyl8+AfeHzov1bgG9RM=;
	b=z+smNOwxaZohZ1iqr3cr+5CFLsuX6zxCyKz2FnhABsFByW0+UeDZ1uXavCpaR1RbxXi7
	 HoorQruaEy/03Ay8qsPqgshv28INSEkizsQFII3Psgn1JD9yZEC+d8YS99AWZ/gzP1gPc
	 aiNxBKrsUCrgYMjCwoNnx7E4q7Uf8wDq2pOXz8ocW+gT6ci8RkFJCxcWfZ0FSvZvp/AZV
	 gkvWPl4dj4Bitm2yPdt57eTp4e+bszhXWHBzWgIsztE8gHUnDTTvn32+8T6uJNI443xbb
	 YCqIL7/ANi4xnMFZFTHRzuDnEY9vck6/w0Q7i+tjzVcpq1ziGDnYoZE95EV1s668a8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h0wnOOxu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57A0606A320;
	Wed, 18 Nov 2026 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h0wnOOxu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA081F000C4;
	Wed, 18 Nov 2026 22:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041280;
	bh=nnRKFikjoVbOi0UredcU0eOfCyl8+AfeHzov1bgG9RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0wnOOxu9tVMnKbAtl9/Rsy2gwPqPXWlMsFaK+6WDd6q8WOCp3OJe4qwevEK907+g
	 RVd6yfkxdH3bigs9pNUHpdL9izY0yM56Cr2mf3Q/T+6SCwuUIsHaklqjRqMBT1Onq7
	 fTtglmUtCEajytmDBPmcoU751kQRajALYgpYmdpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2755/3318] mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()
Date: Wed, 18 Nov 2026 15:56:17 +0100
Message-ID: <20261118150443.393428543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1ce45f0e74d60e8279ed380c97047e6c351aee1b ]

pl35x_nfc_setup_interface() obtains a reference to the SMC "memclk" with
of_clk_get_by_name() and only uses it to read the clock rate. The
reference is never released: the function has many early return paths
and no clk_put() call anywhere, so the clock reference is leaked.

The hook is invoked repeatedly by the NAND core (nand_reset(),
nand_setup_interface() and the NAND_DATA_IFACE_CHECK_ONLY mode probing
loops), so the reference count keeps growing.

Release the clock reference with clk_put() as soon as its rate has been
read.

Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 140428fff8f1a..9a776d31d52ba 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -807,6 +807,7 @@ static int pl35x_nfc_setup_interface(struct nand_chip *chip, int cs,
 	 * macro to convert from one to the other.
 	 */
 	period_ns = NSEC_PER_SEC / clk_get_rate(mclk);
+	clk_put(mclk);
 
 	/*
 	 * PL35X SMC needs one extra read cycle in SDR Mode 5. This is not
-- 
2.53.0



