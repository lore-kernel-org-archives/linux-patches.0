Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EF4BA34;
	Mon,  6 Jan 2025 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179168; cv=none; b=ieA7y6J7tvBvJxpHo/VMrGniZP7tYjredjE1MUjAirvns+hNm0dUp07GkDfQCQy9yme7CsZZax011YeI3gFFIs+MpYwplG5YwixD8rKQq4f2gAESwg6Ot/PlxxWF0oqqy34OEgcZedRktfHdQppHrMbK9DZQBmNE2JFNOhfm3hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179168; c=relaxed/simple;
	bh=iG92TIq1oQ/PE/C/no2FQqi12TAaci2IisAw6HDp+XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAflDqc5ilfFfI4afrB3ZasJyVRqrUeN/v8BNP34ZCVzkco0aQfu56+Gn+CAl6vDlmsONjM2/g7MzNUGpFlt7Ka7wXqBDnS0Cuk5UAaYnZgtVODqrA9aE4kV6L99odsOYmouxmXcotBCWV94JoPfcPV8GZjV4kBhKMTD40mO3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCsGJ3NZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCsGJ3NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4615DC4CED2;
	Mon,  6 Jan 2025 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179168;
	bh=iG92TIq1oQ/PE/C/no2FQqi12TAaci2IisAw6HDp+XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCsGJ3NZ4zF+V6MC7Hd2AJbgTFXOKtP09gLCDSsg2qqX31Mx/oKkeg07AplREGNGF
	 olGZ47k9CK+1FdU4blup2J6plKdwAIBV6ND0fpK5M0lokuxL60/smsAKQY0p9wUiWk
	 7NBPvqaMcUfKRcayPXRuIezbTXz8j3v7r/OFLFGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.4 17/93] i2c: riic: Always round-up when calculating bus period
Date: Mon,  6 Jan 2025 16:16:53 +0100
Message-ID: <20250106151129.352696973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
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
@@ -323,7 +323,7 @@ static int riic_init_hw(struct riic_dev
 		if (brl <= (0x1F + 3))
 			break;
 
-		total_ticks /= 2;
+		total_ticks = DIV_ROUND_UP(total_ticks, 2);
 		rate /= 2;
 	}
 


