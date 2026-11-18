Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036364;
	b=1xFc8tGSdnTk8sNFPnLvEdWB9d5BkImXQSVAwPjwh1M8Ti4Dko0le4cliJlTVoc8HYY8
	 D9wCOTtz8uf2wzhxIi3lR+cJxS1hqZtN7ipDnLNJyKcnzDhnXo8xQTGDzSnDzGLHtnabx
	 QYYz+Yil92TkCPSdmbXmdsNurrZE/3cwef2TabnJ8qzuYs4UhLZ1rYJYBZwRXObpLFOiF
	 Ri0U/AyYLZg0tp8b3ULsgeW4xmIaozBfT5GItglTJZg1n7s2xFhFrff9IRaeKA/ptgAp9
	 jsTtIqc86odeJmNETOI7x5+BXbh9xh9xE0hFlytKyY6n/rTVVyDPekk8NTlmgK2I+wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N/sz9J2AfF8cOWLDTOzS37H5szsQ31CucKBmK3AvO6Q=;
	b=3DTklqYeAL4kY5MO4uoMgyQyc73/Z5EezsiYHjerbHl5adsfRpatYqy4HS4ZAm3H3poc
	 I7QY4CLETwfF2apkdsFP5+as5QfaXSwXVXaoZQKLCP51CjgH1r+4VAaFUG4i/1X2d7tml
	 vfQBMEM7KtaNYah9B9nyj3DyoI4YEaoa1MK2n8F6g1JD4ZjWgo5QPBlpI/fjfsp+eMoli
	 ChY7+6VsAddvgo4bej+b+8I6DRKy3PHIVt+DJDSFOybOETRsK78SsfPWEo4gRJ1OmI7Cg
	 sesJBymg+wAeeiSWmpORjmJr9EDUvclZBx/KSrL0alScXla7mv6o9fyHCcjQj4s6E3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kh2rh+W7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EF1606A336;
	Wed, 18 Nov 2026 21:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kh2rh+W7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A405E1F000C4;
	Wed, 18 Nov 2026 21:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036364;
	bh=N/sz9J2AfF8cOWLDTOzS37H5szsQ31CucKBmK3AvO6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kh2rh+W7aCXGBUVW+tIRsayVkyffVspMd18cnGkBoyg79fVaewbkUFpvV/v4wIq4b
	 51uflOyG4CouDsHDEKEqWKMK5RZtaye+7o7+zoTlhpZ0NeTJzeVRTtXEGxXCpbNUxt
	 52s5QC4y2tAMPtwdWwBFtuKoCiIqviTU8HVBSIxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1033/3318] clocksource/drivers/fttmr010: Fix clk reference leak in error paths
Date: Wed, 18 Nov 2026 15:27:35 +0100
Message-ID: <20261118150350.883455578@linuxfoundation.org>
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



