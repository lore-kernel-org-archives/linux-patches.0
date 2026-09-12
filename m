Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB7A2594BD;
	Sat, 12 Sep 2026 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229513; cv=none; b=m2j67VxozlfNDx08ZkgNWy3GPC9Pwv32wpZWkZo2hqJFr/DHcnNeZPia62+/EPxKG6B3bk6ByoeKY8L/VLWo6RrRDSrCo1lCPKOiUJKVaZfT3R2DXn+9286ahpzqXU3Cv787q5sIy3+fiF49YiNZ1A3yviJu4Pt/Gvo4+ISMvc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229513; c=relaxed/simple;
	bh=2ceIQsFyhCtkWET+YuPfk8Yo7Xkx8NmiYhJ0CFKkv48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiuT6Ef4NlaVLaAbnuCvA1+wKOCVG36cuyn1Kq8/Yoi4fqfTNqKKWhEcH1p+714kWfnE65janJgeKWfS74+D7uiLZk5JtVsS3foT/aummHsO/QwOPD4zEMNwp0Swb3oqNOwRfEUWbHldMlhLq9GDfR0nAXNLYld47fahHnDgXic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hh3SSQ36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh3SSQ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358BD1F000FF;
	Sat, 12 Sep 2026 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229512;
	bh=C0dBW+KWiHhkExTKwc3295RxRdHTv7hfdmfj6jMqz5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hh3SSQ36cedNGeH5SeyL9n17h+QUm6eKWxkH4vPOVIA9R/s7ErctZY1CTLPk7XH0b
	 kzmgr8uHgM8ERH6QzYEHt+/5ENqP9epb+7gM5h0zdn5PgTSzGp1iROpZmsjNAxjKIi
	 ehYf0dMsade04PEM+kDYsFwMb2BtyFWq2/M2BuAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0553/1191] clk: qcom: gdsc: propagate gdsc_enable() failure for ALWAYS_ON domains
Date: Sat, 12 Sep 2026 08:54:41 +0200
Message-ID: <20260912065600.664251837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bad3343e30bb6..ecc7c67207e0a 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -442,7 +442,9 @@ static int gdsc_init(struct gdsc *sc)
 
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



