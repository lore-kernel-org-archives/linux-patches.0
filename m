Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7AD356744;
	Sat, 12 Sep 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222917; cv=none; b=kLx3oqgHcYZsygE8jf2dVTaWB9cAHf5pXuJ57PEAOyzBDM/oL/JJ6VgGHjl+W4JNUIZz1cMtGmR9xug+TItARHanrxTlSV8K1tHYelNDa7yGa/sFNv3c6e5o2pXuRg+T9W8Yz30O2NioETb0kmFPXAVjLWI7qKsydO0mBdwT6l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222917; c=relaxed/simple;
	bh=cuQX21q4RtFj5o/BHqtsx+yTBMpgxVW25dS/6EY6FQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKMRIFkK3L6QocDAyu/iY0D/3SackWV07eXO0uUNOMu0jfHfi6KRS6WAhFT/WcTl2+bGJaxSiMmPfNMp6zdY5fTPL+9nVU33G8nxgcauhkmBkjHGDJYv4ENXiYuC7miKydkfTvS8jdTGd6VZoQlswS2ln4IBu1mTninWCVXJfZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfgXdpil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfgXdpil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B641F000FF;
	Sat, 12 Sep 2026 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222910;
	bh=UWgjBfnw6Oz7Ih2T+mtbcHFRSS0tqU2MAzoH/wuC9g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfgXdpilI+YL0vmwyF6RdmUbqI1V/Me2VJxSs/yuuZLmtuYsT00eUaCLFSTwZkVxW
	 vNBwWU1/MOVN6rJsL+uafDL5aJaMWP0iT0kk1iViGCoSw4xEHvnfkDoMbU9Mzz8Ud6
	 npTTiT2kS3UfB2r6Bc/fb6hxxP9basltLhVR2IME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0675/1424] clk: qcom: gdsc: propagate gdsc_check_status() errors from gdsc_poll_status
Date: Sat, 12 Sep 2026 08:51:47 +0200
Message-ID: <20260912065622.413917158@linuxfoundation.org>
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
index 5a8c93b12efa2..c48340efc2f40 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -103,14 +103,21 @@ static int gdsc_hwctrl(struct gdsc *sc, bool en)
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
 	} while (ktime_us_delta(ktime_get(), start) < STATUS_POLL_TIMEOUT_US);
 
-	if (gdsc_check_status(sc, status))
+	ret = gdsc_check_status(sc, status);
+	if (ret < 0)
+		return ret;
+	if (ret)
 		return 0;
 
 	return -ETIMEDOUT;
-- 
2.53.0



