Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704702C1586;
	Sat, 12 Sep 2026 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213020; cv=none; b=mZGvXO4x+vQAhYmx17TuaxLOJ+VnNV2ZKEVYgTuKJQ96Ll/G4KVgDf9nG+LS33UUjB3pvJ41y79ffMDSNGiYkObmfRYLzWEr2kKd1UHirixm3aVl2E4Al3fYawu5tSaYGGYvSI22KuYGBmkqb20lhqJOzUUupjQV5raR7DnIIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213020; c=relaxed/simple;
	bh=vU4Ju/3AaQJbcKwzabi8sZtw8vRFA/0F9+xcQHXrLb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3N+ycFlM7hgUnQPTW4ezyLPCACsR5/bSDWUTIueLVucuSFSJ8An7wOAPf4wWnPm0XVT3aTagjButmQBEiVliQswzwVmm9hEHHsE95O5V12JRBcQMujAZWjuN18Y3Rbz/wputHM+kGjMmtUbrqNWwtMCWK8CHH4WryLAb9aZ8KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nv84YDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nv84YDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DD41F000FF;
	Sat, 12 Sep 2026 11:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213019;
	bh=bW1D2JfHd7U5y9MlfkLGtTaXXuugTiBj9ihxOq4xZIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nv84YDGY5cJcwfEfDOKUx/y0ietpIwoZKcE0z421JrKHQgBus73sVruCFnXRh+x9
	 U7eB/RmwVxvypU/GWAuc2MC4fNXb4anB6EfDx11T7oRNn/MBG2sAQ4ggofP3GTHJzB
	 gOEYkW4a+rlzP0kuUrRS/kC5lr+lhW+IJSzEkUIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>
Subject: [PATCH 6.12 0035/1376] thermal/drivers/qoriq: Disable clock on resume failure
Date: Sat, 12 Sep 2026 08:41:01 +0200
Message-ID: <20260912065608.336566420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit fcbf9964b67a6d6704c50ed28daa24c3b164f01c upstream.

qoriq_tmu_resume() enables the TMU clock before clearing the
power-down bit and enabling monitoring.

If either register update fails, the function returns with the clock
still enabled. This leaves the clock enable count unbalanced after a
failed resume.

Disable the clock on those failure paths before returning the error.

Fixes: 51904045d4aa ("thermal: qoriq: Add clock operations")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260722075625.452684-1-pengcan@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/qoriq_thermal.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/thermal/qoriq_thermal.c
+++ b/drivers/thermal/qoriq_thermal.c
@@ -380,11 +380,20 @@ static int qoriq_tmu_resume(struct devic
 	if (data->ver > TMU_VER1) {
 		ret = regmap_clear_bits(data->regmap, REGS_TMR, TMR_CMD);
 		if (ret)
-			return ret;
+			goto disable_clk;
 	}
 
 	/* Enable monitoring */
-	return regmap_update_bits(data->regmap, REGS_TMR, TMR_ME, TMR_ME);
+	ret = regmap_update_bits(data->regmap, REGS_TMR, TMR_ME, TMR_ME);
+	if (ret)
+		goto disable_clk;
+
+	return 0;
+
+disable_clk:
+	clk_disable_unprepare(data->clk);
+
+	return ret;
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(qoriq_tmu_pm_ops,


