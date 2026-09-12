Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C526ED46;
	Sat, 12 Sep 2026 19:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242420; cv=none; b=fDAPVTVmX5xUzq0x3sablZACcYowijQqyAQK/GVTVBUBmo7Os1uoZ07xwIqonS1Xiw/eGa+tEF/tN5ty5E4BkzmY67m1/yd7bxgQJgQh0QmY03Qo0iD1ODW1zzRVKZBIUWdzeW09VraM+8MD4DcjxX/bOKjO3QGuGUVHPTdfGTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242420; c=relaxed/simple;
	bh=9v6y3rsqgjhx0+FPOJPVUyJwFk02daTNIebfaHgMPoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIhwyF8XYJ+An/ZhAi4fFW5Vkb/53yxg5mlYzchoU0mSzywhQFE88u9Fm52zFGWispbmXXUOrZrIGE5fd4ICuDmc7wqcdxSfbVsk4sjb7s6KbL8J/RFWp94E12v8l7b5ZhDpGL7B8XrRJaP/pPPTFf8BjaiViDh4sn517FWww7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9Dhk4xC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9Dhk4xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30AB1F000FF;
	Sat, 12 Sep 2026 19:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242419;
	bh=f7ENx3O96qkPahPgfY6SKaaYt20SHb7aJH17obtS3DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u9Dhk4xCZpAgGPDokWOsddnY8BjcUmBfzyLJ8JnBt9NGWUpjWMCoX0AMK/gQ6FvAz
	 ijOjsxMUfR8xJ+79Qs1R0aXh4cAn85DKOlK6L35JP++FOprgSmwDf5fVv1QtbL2J8V
	 hdLygOzC9cPMBE9QQyMa3UpejquFs9DqRhL79fl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/798] clk: qcom: gdsc: propagate gdsc_check_status() errors from gdsc_poll_status
Date: Sat, 12 Sep 2026 09:00:25 +0200
Message-ID: <20260912065526.247411741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



