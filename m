Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C683C8827;
	Mon, 23 Dec 2024 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970744; cv=none; b=deg8OIVG1s5qAZU6msDrsPpPQJFJMJ+0RdJO6QvBWa6eANUujL16uEFJlq5HBeFqNmzWbbsBJAovazQlNCFZ/JlQrlRA0zfBTPbRNsRXKi7odG+tuL1YlwB5SsYOCJ75d3px3cdvbLxE9JnOk3hogGMWZmYALkYyXnVGM8Tkhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970744; c=relaxed/simple;
	bh=+A2tNBrbd5ISYEmDxo5C8m/rujhc5u4yaM95/o+nLVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxZ3Ga8dTWsDtXfAXNZzmq81JeCUVgoTb3uedCC23GWSzJSPlMlJkP+sd5aFJQkuDtlsNpQyiy0oStXGw/tnJu+JHXwI6+Qtac8goePaN5a4Ky8TaDnSmbE2onsxbGeyMp6MPNik77/ZgeDe2Q0BnYcGWeDG8zAFV50O9uFnxt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6y2GEos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6y2GEos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079F8C4CED3;
	Mon, 23 Dec 2024 16:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970744;
	bh=+A2tNBrbd5ISYEmDxo5C8m/rujhc5u4yaM95/o+nLVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6y2GEosKEPFdcOBxwtmV38WCgi5rZ6n4f34zNYLaGCjzpzGU17P7DufB0I5Mdot3
	 OFE4YK1cIWl96yzkDtAR51CTe+tesAarDdpcj31KyR2AARFxBioE/M1dQGsE6DDAtK
	 oy6IysU86RpEFMyNyeDtHSX9kRM9B/zaPNY486bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.1 56/83] sh: clk: Fix clk_enable() to return 0 on NULL clk
Date: Mon, 23 Dec 2024 16:59:35 +0100
Message-ID: <20241223155355.796294160@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit ff30bd6a6618e979b16977617371c0f28a95036e upstream.

On SH, devm_clk_get_optional_enabled() fails with -EINVAL if the clock
is not found.  This happens because __devm_clk_get() assumes it can pass
a NULL clock pointer (as returned by clk_get_optional()) to the init()
function (clk_prepare_enable() in this case), while the SH
implementation of clk_enable() considers that an error.

Fix this by making the SH clk_enable() implementation return zero
instead, like the Common Clock Framework does.

Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/b53e6b557b4240579933b3359dda335ff94ed5af.1675354849.git.geert+renesas@glider.be
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/sh/clk/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/sh/clk/core.c
+++ b/drivers/sh/clk/core.c
@@ -295,7 +295,7 @@ int clk_enable(struct clk *clk)
 	int ret;
 
 	if (!clk)
-		return -EINVAL;
+		return 0;
 
 	spin_lock_irqsave(&clock_lock, flags);
 	ret = __clk_enable(clk);


