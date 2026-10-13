Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A160D4F4D18;
	Tue, 13 Oct 2026 12:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894719; cv=none; b=frR1p/t2iQEvektkeuu+MiYMoPPF77GMNPZJaUoby/unb3sxiDMUt0LFz+u3KyzK5F4U7ihXfeBSdXU1GmfH4HmvbnsFW5UcAlpWfCOjOYNNKFLtEYfU4NkHsCH7kLrSrejPMiXvmYkdWj/Cg7mhQ4U0OY1jrJNAJFokWx6aRQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894719; c=relaxed/simple;
	bh=/N3o8jBKw1oA7q2eTrXIQ9OFeCLjb686+kSnB0VR3XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALp/agHHQfAQ4jjfMTgjACA0125sWAwu7KGk78oLvNyUxu2I+XlOaOokotJlyWyoDiWB1iUP10hN28/1e0xpO8qQoZM1HIXnB9vy20lK0V9ocw4Gd/h+ZZ46v2lW4WGHh/lCLT/G3owY79ME16+HQ+o9W1SorERIrTco7w4BcRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKZyhF1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKZyhF1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019731F000FF;
	Tue, 13 Oct 2026 12:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894718;
	bh=X8/ezTUHgLgHM0HZqyVVpAJj3MP5Ik0fW5vZds6hMNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKZyhF1UE6d+0EybFOeNsmuxDfmpJ8ADJN0BKTPSZibL0vNyDj7X/74uaWD6YvSUe
	 WVRd1D6G5wjyvdhRttqaDa9TDHSOGr3p5kAD1b4B2RqJzDq1R11VbzxZ8lqn36lcnH
	 A5Q2H0MfYgBZdDi0xNWMU8BwIGos84CyCTR4hWBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Chen-Yu Tsai <wens@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 032/497] rtc: ac100: Assign .num before accessing .hws
Date: Tue, 13 Oct 2026 13:33:19 +0200
Message-ID: <20261013112908.651332898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

commit 6a4117eee82dd85f11bf898bf66026764011eeb6 upstream.

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer (UBSAN_BOUNDS)
about the number of elements in .hws[], so that it can warn when .hws[]
is accessed out of bounds. As noted in that change, the __counted_by
member must be initialized with the number of elements before the first
array access happens, otherwise there will be a warning from each access
prior to the initialization because the number of elements is zero.
This occurs in ac100_rtc_register_clks() due to .num being assigned only
after every clkout clock has been stored in .hws[]. With
CONFIG_UBSAN_BOUNDS and a compiler that implements __counted_by (GCC
15.1+ or Clang 20.1+), this triggers an array-index-out-of-bounds report
during probe, and with CONFIG_UBSAN_TRAP the first store traps.

Initialize .num with AC100_CLKOUT_NUM, the number of elements .hws[] was
allocated with, right after the allocation. That is the value the loop
counter ends up at on the success path anyway, so the provider's
behaviour is unchanged.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/AS8P251MB00013E724A77A355668B6CCEC8B42@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ac100.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ac100.c
+++ b/drivers/rtc/rtc-ac100.c
@@ -316,6 +316,8 @@ static int ac100_rtc_register_clks(struc
 	if (!chip->clk_data)
 		return -ENOMEM;
 
+	chip->clk_data->num = AC100_CLKOUT_NUM;
+
 	chip->rtc_32k_clk = clk_hw_register_fixed_rate(chip->dev,
 						       AC100_RTC_32K_NAME,
 						       NULL, 0,
@@ -359,7 +361,6 @@ static int ac100_rtc_register_clks(struc
 		chip->clk_data->hws[i] = &clk->hw;
 	}
 
-	chip->clk_data->num = i;
 	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get, chip->clk_data);
 	if (ret)
 		goto err_unregister_rtc_32k;


