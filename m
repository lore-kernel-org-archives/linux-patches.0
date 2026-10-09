Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418543D8912;
	Fri,  9 Oct 2026 14:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556565; cv=none; b=q8WTnGUPSlfmLcUJRzhLAZgTwNJNNiprL461Bg9uVzBd76tfYTH/sh30CzshtC6wYWJMiBQwmL7M21YZ1OxOdbY8MWGTFCAURTkNqAU8SvWqw8uJLD2L9wD7zX2KpfO8dsRjBNxNgnr8R3CbhMnkYno3RU9H327eu4YeM5osvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556565; c=relaxed/simple;
	bh=QbwvmrvDNQw7Plm8XW7N7/cu+P/E5FDBI5l728bBFXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETxxkxSjsOMiA/zevRz8ePng9WS725P4ivCUg7UiUjEoDPN/qHtVzsxLcQileO83WdaNoMkL9HA2n0mZ5MP4BPdTDoHys4EE2rv3Na+4dFUjOc62jItOPGEB19t4m9TsLHOl4L3JGVAbPeK0F/MnWTohVWOYr/nAcrsGK+I/dXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sdh6QJ1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sdh6QJ1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8B01F000FF;
	Fri,  9 Oct 2026 14:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556564;
	bh=okVNtWwXCoPGx6t1CCPjiDVC4nzl6TxUolS68nieZ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sdh6QJ1c1deQm+cGHXCSygBKxFqw89n2UVL7CqWcbhbX18pbuGKTnbgJG86etPwcq
	 QvoC7ZxHt/CdiZ6hwLSIOnNPyABW5QuMarDkloj31/vwYPFncw30/UDG+/lE5rvuIe
	 EtoIEUqt66eGpNkoTCm7qTrfGagp4FdJ+vOeAU50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sagnik Sasmal <sagnik@sagnik.me>
Subject: [PATCH 6.18 256/403] mtd: spinand: Do not update the QE bit on devices without one
Date: Fri,  9 Oct 2026 16:10:17 +0200
Message-ID: <20261009140958.161401254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Sagnik Sasmal <sagnik@sagnik.me>

commit 1c1a342aceec79528b3ba51f376eca2be5928fe7 upstream.

Commit be0b86c648bf ("mtd: spinand: Gather all the bus interface
steps in one single function") moved quad-enable setup into
spinand_configure_chip(). The new code only determines whether quad
mode is needed when SPINAND_HAS_QE_BIT is set, but calls
spinand_init_quad_enable() unconditionally. This clears configuration
register bit 0 on devices without a QE bit.

That bit is not universally a QE bit. On the Winbond W25N02KV it is
H-DIS, which disables the active-low HOLD function. Clearing H-DIS
enables HOLD during single and dual I/O operations. If IO3 is not kept
high, the flash can pause a command and ignore clock and data.

H-DIS is not restored by the FFh reset command, allowing the incorrect
state to survive an SoC warm reboot while the flash remains powered.

Before the refactoring, spinand_init_quad_enable() returned without
touching the configuration register on devices without
SPINAND_HAS_QE_BIT. Restore that behavior by only calling the helper
when the flag is set.

Return zero explicitly once SSDR configuration completes, as all errors
are returned immediately. This avoids returning an uninitialized value
when neither optional configuration step runs.

The regression was reproduced on a JioRouter JIDU6401 with an MT7986
SoC and a W25N02KV. With Linux 6.18.44, sysupgrade failed and the
following warm reboot hung in BL2. With this change applied, both
sysupgrade and warm reboot completed successfully.

Fixes: be0b86c648bf ("mtd: spinand: Gather all the bus interface steps in one single function")
Cc: stable@vger.kernel.org
Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Assisted-by: LLM
Signed-off-by: Sagnik Sasmal <sagnik@sagnik.me>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1510,11 +1510,11 @@ static int spinand_configure_chip(struct
 		    spinand->ssdr_op_templates.write_cache->data.buswidth == 4 ||
 		    spinand->ssdr_op_templates.update_cache->data.buswidth == 4)
 			quad_enable = true;
-	}
 
-	ret = spinand_init_quad_enable(spinand, quad_enable);
-	if (ret)
-		return ret;
+		ret = spinand_init_quad_enable(spinand, quad_enable);
+		if (ret)
+			return ret;
+	}
 
 	if (spinand->configure_chip) {
 		ret = spinand->configure_chip(spinand, SSDR);
@@ -1522,7 +1522,7 @@ static int spinand_configure_chip(struct
 			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int spinand_init_flash(struct spinand_device *spinand)


