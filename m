Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9F348C403;
	Fri,  9 Oct 2026 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557267; cv=none; b=MDANBokGCyXiDMWfHFDWs+HlOmSY2eOe1intcJ/iUUaCqn/CcI8zeNJlNpbX+FF+fMgLxez/5H61WbxR4grSDEVWgwQjioYH/ZzNn5LO5P7/LJCxKQkqsF3gIuSFJX43ygo4AH+saQX4K9rtQWlePJoZNgH/gxBSZuzBOsTpHc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557267; c=relaxed/simple;
	bh=gFdQKesmXsDEj7Bbn5uwWG/MoiQLvaa4YozV6ZYsqW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYqzpdponde/tU43U6sTgQQNXpzlP5OCcq43X5d45U1uKFottP8gtoP8mRDjmr9JcIOHzzti4GdEpnJY5B9UodXyWvJa2MyXlRbP6JhrhJJpNx+rtGvfHVBfVFilamlzBriTuJIx5mLOlYjx/r+9lPozRGz0YT0LRndp7KugUVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAD+nY5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAD+nY5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302ED1F00893;
	Fri,  9 Oct 2026 14:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557266;
	bh=t4NfJJVbrubUq2Mr8U/4/KA6uYnR1ViteSCT4pAUQWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAD+nY5I3quBwBKnd71qaK10bEsUWDJcuVjG6SmUVp6VN8vonNYJRltVwUtrVRegl
	 e/9OlKuUDWowcfbAS07HfbLxDG13wVgGWMnNDqyepUEAX0Wl3+XrCXxkTG0YHJjf1o
	 W5fJoeEeI5qcAUTN1+zj4lReHSpHANQjvAwdqaC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sagnik Sasmal <sagnik@sagnik.me>
Subject: [PATCH 7.2 310/428] mtd: spinand: Do not update the QE bit on devices without one
Date: Fri,  9 Oct 2026 16:10:47 +0200
Message-ID: <20261009140952.931381935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1812,11 +1812,11 @@ try_ssdr:
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
@@ -1824,7 +1824,7 @@ try_ssdr:
 			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int spinand_init_flash(struct spinand_device *spinand)


