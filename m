Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FF715B2E9;
	Mon, 29 Jan 2024 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548232; cv=none; b=Pw+eKAi/6mLQUyDO0YTSywOtfCzZkc3dDkSE7nDCXcmsaODHb0MlfqtSMbeBvwwExt23TUMhLO0B/2uiPw0p2gdkGrSrDbfisxAZK97/X9vVAMKy5g4IuYvocPjv8YPKEREy0385WvEhL5o2FTlIj2VIsx+gSNIQRrXMehyBXiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548232; c=relaxed/simple;
	bh=fRY7N6DxOiCaYYcJCtQb8oOOcSba8s6gxm0MEFVQphs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8t50T7P/+RvXkyMeD0Yy9w1xMuS/OXq6dsLB5FcFBfhQPQXWE/TWWy4KdTj/sqT5C2NUbC2LfWnCggCBl+njq5hy8ZhMBkLZh52sEwPhZ6FT/p27OAPJhY8+QaIqd4/1+/x5BmB/93olr+skCV9nyP4j3UC5xmPD8UWxM2KoFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZyU/7kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZyU/7kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E367FC43399;
	Mon, 29 Jan 2024 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548232;
	bh=fRY7N6DxOiCaYYcJCtQb8oOOcSba8s6gxm0MEFVQphs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZyU/7kDV9HTID+DBh9Q0yW/EOH7OhhuSqdcwqPemOisNo3fFUxB+zmzy9qtj7KIt
	 NcWPlnxEuLZDSz0gkDLhWmZLsk93+QBSsMxOMABYGo1ZMNeLlwTq2hjRHG0p6UDysa
	 RpndsVMD+K1KYtRwAiMmHz3SKoxnuJMlmnb/s64I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.1 009/185] OPP: Pass rounded rate to _set_opp()
Date: Mon, 29 Jan 2024 09:03:29 -0800
Message-ID: <20240129165958.888770304@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 7269c250db1b89cda72ca419b7bd5e37997309d6 upstream.

The OPP core finds the eventual frequency to set with the help of
clk_round_rate() and the same was earlier getting passed to _set_opp()
and that's what would get configured.

The commit 1efae8d2e777 ("OPP: Make dev_pm_opp_set_opp() independent of
frequency") mistakenly changed that. Fix it.

Fixes: 1efae8d2e777 ("OPP: Make dev_pm_opp_set_opp() independent of frequency")
Cc: v5.18+ <stable@vger.kernel.org> # v6.0+
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/opp/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1226,12 +1226,12 @@ int dev_pm_opp_set_rate(struct device *d
 		 * value of the frequency. In such a case, do not abort but
 		 * configure the hardware to the desired frequency forcefully.
 		 */
-		forced = opp_table->rate_clk_single != target_freq;
+		forced = opp_table->rate_clk_single != freq;
 	}
 
-	ret = _set_opp(dev, opp_table, opp, &target_freq, forced);
+	ret = _set_opp(dev, opp_table, opp, &freq, forced);
 
-	if (target_freq)
+	if (freq)
 		dev_pm_opp_put(opp);
 
 put_opp_table:


