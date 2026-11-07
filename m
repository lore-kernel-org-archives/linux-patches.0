Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063190;
	b=wHicWwKUkHgEhoOVrGcicohGnvU/+s3pNcp47ckxLwgsQZBSQL5A5sizKcIDjOfKAjjL
	 IswTFEUXrcWIrYoY9xyA5AfrS057JWo7N8mgnPS6SilXPiJDhpbFStGephhuGn/ZEkilz
	 fYbpne+jz2tOilws2G2lb1L5qKZ105RVaY+JciofXmC5mwYvJei/2Ugz9JIFv/oVCeTTG
	 Q4ytWckle9BjceUzQfNGOXYwNhLB+3lRvC4LWayLD7DaKHwbmcBzPqIqJFO8fdRFM2ela
	 3B1KtdFAIlTBieddJIXn5uZvqrTKkxcba/Kw5hUmOCp8ela295Elpa3qGwlGDteD/LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4Bu3HSAfGszTdEq5WQJFBkSDTsULcmG+6Yt2hKi28A=;
	b=jWVFqWMhoJEDBfvPHo80ER+5Ph+6cnRQkyC1vX3rVPPH1liZVJ7Wa7entQfm/taxFEnl
	 xEkKt1d1488PRRTz0qekKuZGU87YhjqBTX4BzeC/A2voieeuwgGzSoRXmQaV9v9wc3ony
	 u55oPlcBRbhs5p7z5axbjsQmrgW7hPOtLipgALog8bgwmp36qGh5mimMRO924oCFDXkCb
	 L3h80UyBBkRC2JYbQ+CKrj7udZtboW2AK64/wy9Pc3pR8BsLydU20sYFwfHPkIh+SGLQ8
	 ypCBRrNImKim7SJHv30R4aj3RNRgZA5Q6KtiyfGz9e9T6YBTOiaPKqpmTL2L7kb1nOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dup+cftW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31364606D82E;
	Sat,  7 Nov 2026 14:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dup+cftW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3921F0089F;
	Sat,  7 Nov 2026 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063190;
	bh=x4Bu3HSAfGszTdEq5WQJFBkSDTsULcmG+6Yt2hKi28A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dup+cftWIPT0bXpM6WQdrdXEyE6NBJck50k/l0QXd2Obi/cwW6UiE+PXN49c0elz8
	 EHZaQuPw1zSM1wIdYXHC1x77iQbnUI6DpliFb+dYM1V0TJrFQYxSmLfUIJ7IMlS5dO
	 ImYCmzEmsMbjAQReUQPSX6WffOwls91RupWjKzrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 406/869] clocksource/drivers/fttmr010: Fix clk reference leak in error paths
Date: Sat,  7 Nov 2026 08:51:28 -0500
Message-ID: <20261107134907.131688593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 277e5657237a92e279ee28da2f5c07902cc6aa0b ]

fttmr010_common_init() obtains the PCLK reference with
of_clk_get_by_name() but never calls clk_put(). If clk_prepare_enable()
fails the reference is leaked directly, and every error path that jumps
to out_disable_clock only calls clk_disable_unprepare(), which releases
the prepare/enable state but not the reference obtained from
of_clk_get_by_name().

Add clk_put() to the clk_prepare_enable() failure path and to the
out_disable_clock label so the clock reference is no longer leaked. The
success path keeps PCLK enabled for the lifetime of the timer and is
left untouched.

Fixes: dd98442e17a6 ("clocksource/drivers/fttmr010: Drop Gemini specifics")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260915045426.1726805-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-fttmr010.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-fttmr010.c b/drivers/clocksource/timer-fttmr010.c
index 126fb1f259b28..0003d49768f62 100644
--- a/drivers/clocksource/timer-fttmr010.c
+++ b/drivers/clocksource/timer-fttmr010.c
@@ -292,6 +292,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		pr_err("failed to enable PCLK\n");
+		clk_put(clk);
 		return ret;
 	}
 
@@ -432,6 +433,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	kfree(fttmr010);
 out_disable_clock:
 	clk_disable_unprepare(clk);
+	clk_put(clk);
 
 	return ret;
 }
-- 
2.53.0



