Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F84529C351;
	Wed, 23 Apr 2025 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421471; cv=none; b=VngDgTw37mni3kDD7WeQzjDV2Xy+viCr1K/oMbj3pIhL+wXdcx1R8MH/Zz/B+bEualiaVr2vfQ1K+hn5L0GWDfDCxEW0MphsbJxrjbFtR0+gLDtLFnxTvhIJvmD8w4NNC2qmIBc+6EgCx+z0aeU/vTfs0Qa6Cw2Z0fZCDkq/ji8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421471; c=relaxed/simple;
	bh=93SOK3Nh1BEYVVDHatB15LgofFD6THrX5Ig3WRutXcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7/Qm6POleEfgBlFsPAuW1mcRAVqaTCI11vb425J6NFhicVIUEH15nPpR6BOBem+9l32tNbzScFMMVx0mi3tgLaV6K98nyz/58vKoNXgbcTSrqK/CV7A/NEkJKcWZ6Uaxqc/wOv6m7tJ8gHbvnbAkIoaP9nRei5pqOeZA5068o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCyJup6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCyJup6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAD8C4CEEB;
	Wed, 23 Apr 2025 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421471;
	bh=93SOK3Nh1BEYVVDHatB15LgofFD6THrX5Ig3WRutXcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCyJup6sSvy+Uh9SjGgrEB5POEMXVVAwNnsXPLHejp+8l1Uvr3sCXmISM4BYYCzZ6
	 4le2yO/q6G6/aRpUd1jVrAFFeDkaNDBTgmbSpUmG8/Ejcp7hNYr+hlTlL3tUEvxigL
	 AZngfoqmoSeFf32z9kz7O8WaDN60KqfuBp193eaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 140/291] clk: qcom: gdsc: Set retain_ff before moving to HW CTRL
Date: Wed, 23 Apr 2025 16:42:09 +0200
Message-ID: <20250423142630.130800524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

commit 25708f73ff171bb4171950c9f4be5aa8504b8459 upstream.

Enable the retain_ff_enable bit of GDSCR only if the GDSC is already ON.
Once the GDSCR moves to HW control, SW no longer can determine the state
of the GDSCR and setting the retain_ff bit could destroy all the register
contents we intended to save.
Therefore, move the retain_ff configuration before switching the GDSC to
HW trigger mode.

Cc: stable@vger.kernel.org
Fixes: 173722995cdb ("clk: qcom: gdsc: Add support to enable retention of GSDCR")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Imran Shaik <quic_imrashai@quicinc.com>
Tested-by: Imran Shaik <quic_imrashai@quicinc.com> # on QCS8300
Link: https://lore.kernel.org/r/20250214-gdsc_fixes-v1-1-73e56d68a80f@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -290,6 +290,9 @@ static int gdsc_enable(struct generic_pm
 	 */
 	udelay(1);
 
+	if (sc->flags & RETAIN_FF_ENABLE)
+		gdsc_retain_ff_on(sc);
+
 	/* Turn on HW trigger mode if supported */
 	if (sc->flags & HW_CTRL) {
 		ret = gdsc_hwctrl(sc, true);
@@ -306,9 +309,6 @@ static int gdsc_enable(struct generic_pm
 		udelay(1);
 	}
 
-	if (sc->flags & RETAIN_FF_ENABLE)
-		gdsc_retain_ff_on(sc);
-
 	return 0;
 }
 
@@ -418,13 +418,6 @@ static int gdsc_init(struct gdsc *sc)
 				goto err_disable_supply;
 		}
 
-		/* Turn on HW trigger mode if supported */
-		if (sc->flags & HW_CTRL) {
-			ret = gdsc_hwctrl(sc, true);
-			if (ret < 0)
-				goto err_disable_supply;
-		}
-
 		/*
 		 * Make sure the retain bit is set if the GDSC is already on,
 		 * otherwise we end up turning off the GDSC and destroying all
@@ -432,6 +425,14 @@ static int gdsc_init(struct gdsc *sc)
 		 */
 		if (sc->flags & RETAIN_FF_ENABLE)
 			gdsc_retain_ff_on(sc);
+
+		/* Turn on HW trigger mode if supported */
+		if (sc->flags & HW_CTRL) {
+			ret = gdsc_hwctrl(sc, true);
+			if (ret < 0)
+				goto err_disable_supply;
+		}
+
 	} else if (sc->flags & ALWAYS_ON) {
 		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
 		gdsc_enable(&sc->pd);


