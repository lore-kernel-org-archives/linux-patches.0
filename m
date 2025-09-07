Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775C722F74D;
	Sun,  7 Sep 2025 20:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275741; cv=none; b=sOm9Qa6T3h+yDoKf3Z7CGHdzPRHKAUArrMCyRVBNMzkrurMZ/0pOwYYbJutnStQafOFIb84o8r/WdByFrRpzCMgyeSRAHcCrVU/Vb2Lba4LO+v9nrZxE5HIfJIQ3XcJZ7oe9rNuRCnLwiCsMiTtlX3Cg9bzc97wH/F41auoxw0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275741; c=relaxed/simple;
	bh=fN/7YFl8UW7dxGok0iUFS6oKcryf8HcIkLh9if1VpBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvCQrRU0zyzfkJ/f5kWoA3gWDSUtT2pV/YoFBr1r/4s7GU+6P2aCU4wl9wFOO9NAGYd8uTYxJJ+jkFMrrL38v5Oa5o+zycUfRBoBGdDRIIyq9g3u77jUmrPxfsv7PpYkp1KrGy2BFeZnwgu8MfSh2/OtMxvMdgeezrZI9OwDdtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDUCAJB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDUCAJB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C4C4CEF0;
	Sun,  7 Sep 2025 20:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275741;
	bh=fN/7YFl8UW7dxGok0iUFS6oKcryf8HcIkLh9if1VpBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDUCAJB0wObcVG6pM+2gCGQ9IjEPOLjmSan7Zw4oX7IXeNWfdkp01u+W/jal86j96
	 rNEMOg7dYniSKBpO54bS/omjNyLRzsww1GnajENOXuJd9geu5BTHOS/d/uZUn/3tiM
	 YztT8sUkDpzEME/n8Z8ujV0W8uolIkBJdPqzr8K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/52] clk: qcom: gdsc: Set retain_ff before moving to HW CTRL
Date: Sun,  7 Sep 2025 21:58:10 +0200
Message-ID: <20250907195603.407979477@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 25708f73ff171bb4171950c9f4be5aa8504b8459 ]

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
[ Changed error path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -273,6 +273,9 @@ static int gdsc_enable(struct generic_pm
 	 */
 	udelay(1);
 
+	if (sc->flags & RETAIN_FF_ENABLE)
+		gdsc_retain_ff_on(sc);
+
 	/* Turn on HW trigger mode if supported */
 	if (sc->flags & HW_CTRL) {
 		ret = gdsc_hwctrl(sc, true);
@@ -289,9 +292,6 @@ static int gdsc_enable(struct generic_pm
 		udelay(1);
 	}
 
-	if (sc->flags & RETAIN_FF_ENABLE)
-		gdsc_retain_ff_on(sc);
-
 	return 0;
 }
 
@@ -392,13 +392,6 @@ static int gdsc_init(struct gdsc *sc)
 				return ret;
 		}
 
-		/* Turn on HW trigger mode if supported */
-		if (sc->flags & HW_CTRL) {
-			ret = gdsc_hwctrl(sc, true);
-			if (ret < 0)
-				return ret;
-		}
-
 		/*
 		 * Make sure the retain bit is set if the GDSC is already on,
 		 * otherwise we end up turning off the GDSC and destroying all
@@ -406,6 +399,14 @@ static int gdsc_init(struct gdsc *sc)
 		 */
 		if (sc->flags & RETAIN_FF_ENABLE)
 			gdsc_retain_ff_on(sc);
+
+		/* Turn on HW trigger mode if supported */
+		if (sc->flags & HW_CTRL) {
+			ret = gdsc_hwctrl(sc, true);
+			if (ret < 0)
+				return ret;
+		}
+
 	} else if (sc->flags & ALWAYS_ON) {
 		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
 		gdsc_enable(&sc->pd);


