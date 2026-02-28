Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7470B43D4F4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301162; cv=none; b=hv5OTc1LFRE+e1BBctmy2F3iiv6F/xK2rHNuFjVMcG8i2QwetKYQxm7SIspytylATh8ijS4QfSf0JjRJODPIi6fmGr8LqiswSHngHN7WwmF1ZT24o0ViWmbgikCKtw90WeUYMkPzLwr9E8HMR9P7cpemagnlFhAuU2+q/NW7pBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301162; c=relaxed/simple;
	bh=YE0rsx0hax6JiTGRRaPO2CiszNWWwDsydZlkEZma7LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPm8vTvdJgyYgnkFhpebvTnkLWjfCoYnhg15BxTibVh9CYZc2TOtytdD6tIWP3uKyQRSLAMseMB+szek5k6YLRWKW9Ci/sNhb6jcXQJdRdxmN/CROno1uL2BMxd/uEIrWezI6MApNgkmPTM4NUYdK3/UQoz1EC14/O+PygKC9po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uV8F+bHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uV8F+bHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC16EC19424;
	Sat, 28 Feb 2026 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301162;
	bh=YE0rsx0hax6JiTGRRaPO2CiszNWWwDsydZlkEZma7LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV8F+bHO4GGPcmCP5n+erROxFr+1O+vE+PTMxAND711S6TF0wikLKYebUoDXcW/mh
	 An2MEZ84xT4UKuiOGnBv7gVqK45Ankm28uTUEYEdpEN+XpaET1YICPYzUBGSfqqEbd
	 tTVQsV9PfWRwHQOZ9AFQUBLoiy1xKRQvpLkSN74j32Vz5JKRTYVQ9E8wrbf20bWS35
	 sfmD/DScqMf53ouudfEed5PqjM0fy7bl5tP79ZYlLs3nVsp0ThPD8Sodux0zUROFSc
	 X27QNd0nt7HPijiEFsk4Em4ZdBosnyE6CztIl4m9ODisUGWNPhDUs8p5XPppaW+ZjU
	 qgw6fNJPZCKrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Artem Shimko <a.shimko.dev@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 327/752] serial: 8250_dw: handle clock enable errors in runtime_resume
Date: Sat, 28 Feb 2026 12:40:38 -0500
Message-ID: <20260228174750.1542406-327-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Artem Shimko <a.shimko.dev@gmail.com>

[ Upstream commit d31228143a489ba6ba797896a07541ce06828c09 ]

Add error checking for clk_prepare_enable() calls in
dw8250_runtime_resume(). Currently if either clock fails to enable,
the function returns success while leaving clocks in inconsistent state.

This change implements comprehensive error handling by checking the return
values of both clk_prepare_enable() calls. If the second clock enable
operation fails after the first clock has already been successfully
enabled, the code now properly cleans up by disabling and unpreparing
the first clock before returning. The error code is then propagated to
the caller, ensuring that clock enable failures are properly reported
rather than being silently ignored.

Signed-off-by: Artem Shimko <a.shimko.dev@gmail.com>
Link: https://patch.msgid.link/20251104145433.2316165-2-a.shimko.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 710ae4d40aec4..0ff500965c103 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -741,11 +741,18 @@ static int dw8250_runtime_suspend(struct device *dev)
 
 static int dw8250_runtime_resume(struct device *dev)
 {
+	int ret;
 	struct dw8250_data *data = dev_get_drvdata(dev);
 
-	clk_prepare_enable(data->pclk);
+	ret = clk_prepare_enable(data->pclk);
+	if (ret)
+		return ret;
 
-	clk_prepare_enable(data->clk);
+	ret = clk_prepare_enable(data->clk);
+	if (ret) {
+		clk_disable_unprepare(data->pclk);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.51.0

