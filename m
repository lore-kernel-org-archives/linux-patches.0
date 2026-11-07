Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063191;
	b=HXwUS9VfB7VtgLpo4j+ZZLsJ+xlKu6HQ1YhxOp5OSG0smiFIgKYd7VL5soU307wi9vBy
	 tZA4OFk+FVTSUzDUdu2Zpc431Sv+6v2vX01JPemgfwi7gXtCOHCDDp684w02DVbrKX+d3
	 8Z3914gIVvzNkHnR/+RS33EVAb3BYMg8V2/yQC3WEXwHQGg4Sj92702Yyoiry0Tg0VGaC
	 8X0BP88iOeAq5yGA3eNoYOc6f27GA1i7fUaSqWrnOhu2+3CJc5vmRppmHcSZwsEP2QXlh
	 s0HMc/MsFTFFifZMlsYUfrelFv0OFFZYeWUHg63T9jozLNi3wupcuiWzHjBE0Ht5TmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ABzEt9WXJRQ65KVYmrPBMxoVPwghZ3v7iivzYoGuxQ=;
	b=OxVKqhnTgGIVuFClV3mlCPUzLdCT0nZ04isvtz/nIpWPEQZh6DL5F3rrAKpkGAzP6Cki
	 cVAcymRGEgEwMpm53QFa03tZKlFOLtAOFWpAUuZFsbURgOayqYCwQOwd9fpwuDzq+/wav
	 LyvjEJh9c8mma0WhQmFsKEfB/BC+KwG8pE2ryLABpfD3/ju3GeE2dDOsXNeRzT722Skia
	 YJeUYLWZWEY/FKxAb70SGac+la7tasO5JhmS/sZWFSntk4sEGvCpzo6hqWnkzLaMLuOdr
	 0wlBABInULa0Uefn7hnI59adZ0pR+hi7E5OSUjlGuFgjzJA0TFqF0BxP/Qok3XTRIEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D/127myN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF4E606D81F;
	Sat,  7 Nov 2026 14:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D/127myN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B26B1F0089F;
	Sat,  7 Nov 2026 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063191;
	bh=6ABzEt9WXJRQ65KVYmrPBMxoVPwghZ3v7iivzYoGuxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/127myNfOy0V8IFMRGA48HsY7O6ACevuG+258JyFQFVUly8Ad3Z5gkI1qGaMxgiy
	 3w5+uepQUK1YeNM7tBXqEd62REKfl+ZSuWMmPASZtMJOtFvOV4c/PU5eUx7HIG3WQr
	 0orYRg3llWk93BcZ1Xb+nBleJ8YCObBrzSyxYbyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 407/869] clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure
Date: Sat,  7 Nov 2026 08:51:29 -0500
Message-ID: <20261107134907.159221356@linuxfoundation.org>
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



