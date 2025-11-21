Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E58350A0B;
	Fri, 21 Nov 2025 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733041; cv=none; b=i5Cvs3GyZZEigIUufLz3Qx6OseXDvzXnKfuEeC4t8zD2A2j35gyyfB2PhHKR1aSPPe+nAr7CtNCGmn01TG3Y03yzNSRKK4EOD2sHVetvQU3orj2grwUZMNeNW5Y8gYDVMO9twQUxjG5A88BEJmE0j3j7ucqxwd4xc9Pv9568JUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733041; c=relaxed/simple;
	bh=AfaMk9OctL+1EiEhiml59OBZN6bmgtBYYSo11iiqsZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GshxY3yX8CcOJw0BGuYwEda2sMVq6j89eeRoWk0BejmaXXUfhrtCzDTsSg/b+CMJYdjZNxdjQMBX2Sw2y9pUF2GUcxVGTO5spPC4aRLIVqFy3TWPFYgDdqYlc9IzjqduM5neB5ENlDL+Xhr9cqqCCQjsNbiEG9WLQwA+guKXGn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aa6PE3We; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aa6PE3We"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32361C4CEF1;
	Fri, 21 Nov 2025 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733041;
	bh=AfaMk9OctL+1EiEhiml59OBZN6bmgtBYYSo11iiqsZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aa6PE3We+QvdC8GtmdJmsKYDo0yUuC9eDKqRU5qfaJZ/HDXB7mfp30zwbcDYjiyp5
	 89wtx8pSf1JTRSaKiMAEJVNHMTlP0oimvt9CzsgOUPi1J2/zcR9z7NgrdGfH24eEmO
	 9hj3ZTEYTc2NRVbW2FPnWWxiXro3i/W5zTHZlcmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/529] clk: ti: am33xx: keep WKUP_DEBUGSS_CLKCTRL enabled
Date: Fri, 21 Nov 2025 14:10:12 +0100
Message-ID: <20251121130242.161330427@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@tq-group.com>

[ Upstream commit 1e0d75258bd09323cb452655549e03975992b29e ]

As described in AM335x Errata Advisory 1.0.42, WKUP_DEBUGSS_CLKCTRL
can't be disabled - the clock module will just be stuck in transitioning
state forever, resulting in the following warning message after the wait
loop times out:

    l3-aon-clkctrl:0000:0: failed to disable

Just add the clock to enable_init_clks, so no attempt is made to disable
it.

Signed-off-by: Matthias Schiffer <matthias.schiffer@tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-33xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/ti/clk-33xx.c b/drivers/clk/ti/clk-33xx.c
index 85c50ea39e6da..9269e6a0db6a4 100644
--- a/drivers/clk/ti/clk-33xx.c
+++ b/drivers/clk/ti/clk-33xx.c
@@ -258,6 +258,8 @@ static const char *enable_init_clks[] = {
 	"dpll_ddr_m2_ck",
 	"dpll_mpu_m2_ck",
 	"l3_gclk",
+	/* WKUP_DEBUGSS_CLKCTRL - disable fails, AM335x Errata Advisory 1.0.42 */
+	"l3-aon-clkctrl:0000:0",
 	/* AM3_L3_L3_MAIN_CLKCTRL, needed during suspend */
 	"l3-clkctrl:00bc:0",
 	"l4hs_gclk",
-- 
2.51.0



