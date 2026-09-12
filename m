Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B64033F59A;
	Sat, 12 Sep 2026 11:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213040; cv=none; b=S4aB4eHfAJVdQEqMK8fgsbdo7cwh3ZcGwtP0oRNmXl1S91zDbom+R9FL2D3vAYvhFI14RxUaY1ZyeF8TS27ikRPak2jERYm11e+51z94nr+a11g/GGBWZ8NP99PmRfmnfyS/AfR1U6Qa+SZy/wtEegpYp4jy80Wmv/7QDDy2ytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213040; c=relaxed/simple;
	bh=XZE2wxaUj65oGmUto3NEhiNY4/UhAGmHcVSXI055IRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHuIAEYSgzY1qstmmx3SaMdanIo39wpN6jb7H8wxfuixAm1NU3gH0P670X50D0O8VD3G8A0oufnLRCrVOn3pMnsI2IE/SfL/OWwvDzpD3ITwIba2H4TFdBvDZziIt/Km2PrAxHoirANvA5JqHP8q5Fwrg2ouJlUJj74rydUuI3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ew+kl63T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ew+kl63T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8A71F000FF;
	Sat, 12 Sep 2026 11:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213039;
	bh=1Ru7OJ21tLgBnU+/UUdMbZlWvwUVC/aGCljXLq38G+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ew+kl63THLPVh9uLGRy2Rz8tPAshLqR8++7hbkjZeQmTVEzszieCP7+4euqwyEyE8
	 tDxXWfcvc13Fqa7k45zOzEqOhuD/xx1lGe1d6NE3Cgcc1JI9/fv/yyJzVgCn4x/ryI
	 /o3ytdJPKYalpdgoUng5LN9HgisNiSgVpWfQS5wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0039/1376] spi: bcmbca-hsspi: disable clocks on resume failure
Date: Sat, 12 Sep 2026 08:41:05 +0200
Message-ID: <20260912065608.422664985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit d2f5a606710ad70c341dc609430a20a5645618d5 upstream.

bcmbca_hsspi_resume() enables the HSSPI clock, and optionally the PLL
clock, before restarting the SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves those clocks enabled. Propagate the error and disable the
clocks before returning.

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Link: https://patch.msgid.link/20260804071904.860842-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcmbca-hsspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -612,7 +612,13 @@ static int bcmbca_hsspi_resume(struct de
 		}
 	}
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		if (bs->pll_clk)
+			clk_disable_unprepare(bs->pll_clk);
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


