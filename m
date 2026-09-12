Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D174D3438BE;
	Sat, 12 Sep 2026 14:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222966; cv=none; b=pBBmruuCjnAC2BqzTgDKwpmzV4j4sGqwpJWM9isyWjSQ5rSB5X9slT8pLwmg9sLlxmWd7nIoS6fB1SzIU97afE+PXX/Y62eD28yKqjTD6OJnPlGOVGtgdbSikh5hrej3i0htG0RKM0uBLzn1oP0on82pbjOqKfI+HBxGjz5c2U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222966; c=relaxed/simple;
	bh=p+Re2A4OO2sctbErSKE58SheC2e7WfW2YKoxDSr8Ekc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz542aSRw1XvfebUtE/b+CFa8tMTJL+csOz4B57DSROXL54RzvhA/6Tcx6dziMbbC8/OF/6NH8HLBb/foUWmO/FAQHDrYbmnlsaDNbsK6yuU9DIpHYngVVCWXtyNaI+lZ+f6LgKvfZX/NSX3/+gOGRcTEetHjx8mU1h9U4nF3MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHBcUkHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHBcUkHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6629C1F000FF;
	Sat, 12 Sep 2026 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222964;
	bh=EuQo2unNbfN6LxP8Fj1sy8lXctUD8OJOV0BpwovyLZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHBcUkHVkP4k0iFRD4NUgWCvZ8hcAHaJgah8//Z7sew/IpdU1Xv/HFvUMJJVQbBQF
	 NmvjpAjw9ekx1vErmznORLsm4O2a4nB80AyIZO12h7JOL6wnQS7F4N3zvQAG7eZcPD
	 +ZwWbPgxHFzDsKsbWvCkNAzpsjaSXxEtTRZGuCCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0676/1424] clk: qcom: gdsc: propagate gdsc_enable() failure for ALWAYS_ON domains
Date: Sat, 12 Sep 2026 08:51:48 +0200
Message-ID: <20260912065622.437818854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Herman van Hazendonk <github.com@herrie.org>

[ Upstream commit eea55fc694e132aacbe2cf4be7f345115e3d1801 ]

GENPD_FLAG_ALWAYS_ON requires the underlying domain to be on at
genpd_init() time -- the framework will refuse to register the domain
otherwise. When the cold readback in gdsc_init() finds an ALWAYS_ON
GDSC powered down, the driver tries to bring it back up:

	} else if (sc->flags & ALWAYS_ON) {
		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
		gdsc_enable(&sc->pd);
		on = true;
	}

but discards the return value: if gdsc_enable() fails (regmap write
error, the long-form sequence's status poll times out, or the
HW_CTRL hand-off errors) the code still sets on=true and falls
through to pm_genpd_init(..., !on) -- which then registers the
domain in the ON state and sets GENPD_FLAG_ALWAYS_ON, even though
the silicon is actually off. Subsequent consumer probes will see
genpd report "on" while accessing dead registers and hang or read
garbage.

Catch the failure and surface it: returning the error from
gdsc_init() makes the provider probe fail with the underlying errno,
which propagates to consumers as -EPROBE_DEFER (or fatal if the
hardware really is broken) rather than silently lying about the
rail state.

Signed-off-by: Herman van Hazendonk <github.com@herrie.org>
Fixes: fb55bea1fe43 ("clk: qcom: gdsc: Add support for ALWAYS_ON gdscs")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260602140934.796697-3-github.com@herrie.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index c48340efc2f40..7d1fc7a2f678b 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -444,7 +444,9 @@ static int gdsc_init(struct gdsc *sc)
 
 	} else if (sc->flags & ALWAYS_ON) {
 		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
-		gdsc_enable(&sc->pd);
+		ret = gdsc_enable(&sc->pd);
+		if (ret)
+			return ret;
 		on = true;
 	}
 
-- 
2.53.0



