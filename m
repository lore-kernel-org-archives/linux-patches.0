Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062237;
	b=uFf2tfZe3Xq72kv/rG/kVkWwunwgLN02L5WK0GuqCL91Xsl8qjPw9GGlZZIht98HmJYj
	 DghuT5rWEcAws4bhNuerWf7qFK1uNfag7w6fowM6KwqBc6IJ44C/XJiwGR/+APTSMH0Fg
	 eoupbZ/BgGKhVQloxIfCFWNWO295liU7dtR0xE4/8PyfEICyxWoAtbyMy0RMiX+3qsvPa
	 wzaxGAqUIkvgsNOrBQ+WypBL3fWvOUPsUGhjTihySVsDkv5dB6rA8jUwpRjekGiMYjMN1
	 6QjhkVWOvODzZtD5OGLR+NEpCcrEJkdwC2nAwEDFn3ms6NGNzEydE6Xmi68jDgkO/9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3gSPC41tbJKk6rMGPpvo8bk3CjiM0Q11mtvzr/YNq8Q=;
	b=5gJfzPb57Q3Wy85JQ4Hyf+4gji/VUiaPf/ndHX2vEqM8fLOcSUG5yxFLQrVmNHtvqqm4
	 YAtm7zh4ZcuzHagAureHoN/sCv+17TcHJBbqaRxNPsDxng/5UdyAtKfi0Vm85FtyU3WQU
	 PGDGOPGTdrdymQCS5Pboa7jWLLMJJx0YoEwZ86DeWKbGzCFDf5QlD3tGn+Pq58wRiZyQZ
	 FC9ipyYQbuGwS7uiBTTbU/yGpnyPpgxRs4flaLBQOF1a3/+xlrZtiKhxMpzGTgdXi0jqm
	 kRpyPInTOW8V07RreUCKQGTjlw75OVW4B51nLZ9iUuyMD7hec03BvQdrhGoukMfbQqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lm30mD0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CEF606D839;
	Sat,  7 Nov 2026 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lm30mD0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321541F008A2;
	Sat,  7 Nov 2026 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062237;
	bh=3gSPC41tbJKk6rMGPpvo8bk3CjiM0Q11mtvzr/YNq8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lm30mD0GtpSH0f5le9jhjAnCedkeoujclytU0rsNENT3TvfWPvIVuqgTgN2y9E5IE
	 WwHc98DRBlo3r7vJpr5lF9iEEDu/iairhK+HASujB8BVaaggjUVoxBxUbnEoVPkYq1
	 rnLy23WYNDG2uSevTwH5MwGp6r6NjkDt0jbm/AUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1186/1536] clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure
Date: Sat,  7 Nov 2026 08:53:22 -0500
Message-ID: <20261107135031.054448709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 9cc2e18b32f12d26ae6729c62a03640423956b17 ]

digicolor_timer_init() obtains the timer clock with of_clk_get() and
enables it, but the request_irq() failure path returns without releasing
the clock reference, leaking both the enable/prepare state and the
reference itself.

Disable and put the clock before returning on the request_irq() failure
path. The success path keeps the clock enabled for the lifetime of the
timer and is left untouched.

Fixes: 9b8bb7736b78 ("clocksource: Driver for Conexant Digicolor SoC timer")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Link: https://patch.msgid.link/20260915045242.1726702-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-digicolor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-digicolor.c b/drivers/clocksource/timer-digicolor.c
index 559aa96089c34..46e0c329957a2 100644
--- a/drivers/clocksource/timer-digicolor.c
+++ b/drivers/clocksource/timer-digicolor.c
@@ -190,6 +190,8 @@ static int __init digicolor_timer_init(struct device_node *node)
 			  &dc_timer_dev.ce);
 	if (ret) {
 		pr_warn("request of timer irq %d failed (%d)\n", irq, ret);
+		clk_disable_unprepare(clk);
+		clk_put(clk);
 		return ret;
 	}
 
-- 
2.53.0



