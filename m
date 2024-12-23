Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0421B392B;
	Mon, 23 Dec 2024 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970399; cv=none; b=tMrClF4RJdRLRbB3BDA27JkGXayGc5RO0yqnTpDyKublqSy/SRAdvEW+5G4HeYMWDY0wbl3cxpzBqx71okTrI8l2Nk6dn+kPcFYdFZF5+j6a4DpJv/ZJnNOrAULCM0sCyNpmIel27SDmT3mdiD+6wYQDklZOcCa+CQmiSYKJIB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970399; c=relaxed/simple;
	bh=ibyE78ACLR26I1AZfJ8/rX7/z3k9VNqNtvo2u1mPGpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Znt3F2bafSgug1w3IgCtxeq6rMNNHPWNDlEME7cFjeUgSdjwXlhQPvE7v8gn2d7yynidCLJY+Y9gtBNJn1fly1m9o0oRKFXnziXgtYOSavKX1+smKer2qohiGiaviYbdFQv7a37ITlnKBWyygKhNk/2A4kKtxS2CChpd796zdF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qF0Z2oQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF0Z2oQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319EBC4CED3;
	Mon, 23 Dec 2024 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970398;
	bh=ibyE78ACLR26I1AZfJ8/rX7/z3k9VNqNtvo2u1mPGpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qF0Z2oQXd0EKhzZlzH+pchS1KoR0B1oPlF/wGsQZP+q3x0NIX/A2KTd9QJ3qcRXY1
	 pMSyp/paMwXaqPg2a9TY1aSDCI6utNaNnEPEDW0ZmWqTuwYQ9klGrXomBG9sNIxnpq
	 NJuzQefBOH1f6XvEDxPEDtm7OYmoaFIcl/VNutE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 064/116] i2c: riic: Always round-up when calculating bus period
Date: Mon, 23 Dec 2024 16:58:54 +0100
Message-ID: <20241223155402.048713033@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit de6b43798d9043a7c749a0428dbb02d5fff156e5 upstream.

Currently, the RIIC driver may run the I2C bus faster than requested,
which may cause subtle failures.  E.g. Biju reported a measured bus
speed of 450 kHz instead of the expected maximum of 400 kHz on RZ/G2L.

The initial calculation of the bus period uses DIV_ROUND_UP(), to make
sure the actual bus speed never becomes faster than the requested bus
speed.  However, the subsequent division-by-two steps do not use
round-up, which may lead to a too-small period, hence a too-fast and
possible out-of-spec bus speed.  E.g. on RZ/Five, requesting a bus speed
of 100 resp. 400 kHz will yield too-fast target bus speeds of 100806
resp. 403226 Hz instead of 97656 resp. 390625 Hz.

Fix this by using DIV_ROUND_UP() in the subsequent divisions, too.

Tested on RZ/A1H, RZ/A2M, and RZ/Five.

Fixes: d982d66514192cdb ("i2c: riic: remove clock and frequency restrictions")
Reported-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: <stable@vger.kernel.org> # v4.15+
Link: https://lore.kernel.org/r/c59aea77998dfea1b4456c4b33b55ab216fcbf5e.1732284746.git.geert+renesas@glider.be
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-riic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -324,7 +324,7 @@ static int riic_init_hw(struct riic_dev
 		if (brl <= (0x1F + 3))
 			break;
 
-		total_ticks /= 2;
+		total_ticks = DIV_ROUND_UP(total_ticks, 2);
 		rate /= 2;
 	}
 


