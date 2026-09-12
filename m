Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28F38DC72;
	Sat, 12 Sep 2026 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229262; cv=none; b=kXYqHX56iQo2E5pqGFgX0u0gusiUM3Fy8BXHh+e/urSj7ta//0km+hFNvYQJo74yFJipQgSzglZ8+L9CTq6vefMYZFKFn9qBP9NlG7yu8bZ29xguL1mGBLqgmRtRYHP6Mxz2W/9QWq7RbRYeflJsFNaYFBdoT5Boq5pYI0a6Ubg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229262; c=relaxed/simple;
	bh=GG7GM/FMfnCsMy2VLGrNOuWN2l7/OcWxV9wFflT01PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqYkIIGB5L6I+RgArglHMGqVWzk0LZ0C9JQsyAc8xz++VWd0fEL6hWCjVY+vmmnoeDIKjIY3eG0ADPBJCLFAEwo1IAl9rR+r+HE18UBafL65D2vTcdzZ4MYEzwsnqBvtPAcP9SxveX2mNE9x6Ph1if9D88XH/+PR/1tqz1PawWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVkLTAlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVkLTAlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2F71F000FF;
	Sat, 12 Sep 2026 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229259;
	bh=idihaHdRJ7ujBfA7xojLlvxquw872VaUkR8+Ho39j0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVkLTAlr5qsSrc52okZ361PqGMb21TE7xjxs7/dzdFNyVgAKWE8xpWJG+lL4JO7+B
	 KjHkdPVmh7+2v5URmz3C2wgmwYh71XpXB33EGiGs8e8f2ROJh2zToB5Nh4naBDiW53
	 c5xwgNe5DLH8TjVsDxjP2GbimyA8kTik43wRKLLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0552/1191] clk: qcom: gdsc: propagate gdsc_check_status() errors from gdsc_poll_status
Date: Sat, 12 Sep 2026 08:54:40 +0200
Message-ID: <20260912065600.642599978@linuxfoundation.org>
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
index bb6d39572d7ff..bad3343e30bb6 100644
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



