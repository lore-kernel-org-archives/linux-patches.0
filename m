Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E72332D7F8;
	Sat, 12 Sep 2026 18:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238474; cv=none; b=cbJvKGhdP5foUGqE6KrWHm1wcOfSAwv7M/JwDuXkktuzwZxnpVHfCl0dDZbHGLN0usxWySyN6GPR2OtTA7Zc7YBJThzUWI4EWJVyhSx0f9Ej79dLTG34BY7HbnKTaoi5pE48P+mEjzK5Z/N/9sSUKQcQaYYKBQuDFlsB9SGkcfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238474; c=relaxed/simple;
	bh=v/dle7CkwkXa7q0m6FB/HlZLWyTxtnGrwGubRBvIoF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppquj5SLskYtHPAzlOdGWe2XBb3caJ9+i1TR6zHhZtX5QWGHatmZKc3/8/QNj+WHlFckWyznelu7OEhRO1q4pr7fSwBpfceIh2bSveVNvKDZkQ1EPmEsXWof/431ICa/2XGy2ZqiEOax1AxeeIqNwyd3Fm6fEBvHagmMK77Swiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAI2SjHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAI2SjHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940651F000FF;
	Sat, 12 Sep 2026 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238473;
	bh=CGxGFMbSLA7P+OBUhU94xvsfAT9ADVQrOvWKHSxRbDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAI2SjHTLtPJKnyjCoy0ngqQKjbSPFY0i291aFkOXyiOrXnoLaUveLxXe86lTPXMg
	 ysMZPWHe5wiVAoVgmnJsOuIrEm1d61E+GvXY7CUOkJAmxA1hTZJuzoo5L/PRd5ZmJJ
	 z2pRBK4UbgLuv6ZimAkXst0n98QyLOoQ7LIX0ghY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 469/935] clk: qcom: gdsc: propagate gdsc_check_status() errors from gdsc_poll_status
Date: Sat, 12 Sep 2026 08:58:19 +0200
Message-ID: <20260912065537.584594764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herman van Hazendonk <github.com@herrie.org>

[ Upstream commit d69f0c2b8d292b4890c9f0fbe184dfc26c4de86c ]

gdsc_check_status() returns negative errno when the underlying
regmap_read() fails -- e.g. when a parent regmap dies during system
suspend, a CSR is removed by an HW debug tool, or the bus controller
goes into protection. gdsc_poll_status() treats the result as a plain
boolean ("is the GDSC in the requested state?"), so any negative error
return is truncated to "true" and the poll exits with success even
though the rail's real state is unknown:

	do {
		if (gdsc_check_status(sc, status))
			return 0;
	} while (ktime_us_delta(ktime_get(), start) < STATUS_POLL_TIMEOUT_US);

	if (gdsc_check_status(sc, status))
		return 0;

	return -ETIMEDOUT;

This silently misleads gdsc_toggle_logic() (which writes/un-writes
SW_COLLAPSE on the strength of the poll succeeding) and the gdsc_init()
sync path (which assumes the readback represents real silicon state).

Latch the return value, propagate negative errno immediately, and only
treat a strictly-positive value as "reached the target state". Make the
same change in the post-timeout final check so a regmap that comes back
after the deadline does not silently degrade to -ETIMEDOUT.

Signed-off-by: Herman van Hazendonk <github.com@herrie.org>
Fixes: 77b1067a19b4 ("clk: qcom: gdsc: Add support for gdscs with gds hw controller")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260602140934.796697-2-github.com@herrie.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index da3797241f319..8dc3f70ef2e43 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -102,14 +102,21 @@ static int gdsc_hwctrl(struct gdsc *sc, bool en)
 static int gdsc_poll_status(struct gdsc *sc, enum gdsc_status status)
 {
 	ktime_t start;
+	int ret;
 
 	start = ktime_get();
 	do {
-		if (gdsc_check_status(sc, status))
+		ret = gdsc_check_status(sc, status);
+		if (ret < 0)
+			return ret;
+		if (ret)
 			return 0;
 	} while (ktime_us_delta(ktime_get(), start) < TIMEOUT_US);
 
-	if (gdsc_check_status(sc, status))
+	ret = gdsc_check_status(sc, status);
+	if (ret < 0)
+		return ret;
+	if (ret)
 		return 0;
 
 	return -ETIMEDOUT;
-- 
2.53.0



