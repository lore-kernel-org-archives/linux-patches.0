Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EA83815F8;
	Sat, 12 Sep 2026 19:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241868; cv=none; b=rh9a/A8s5Os8oZbM+yTyJb/BGDbCCLVOb/wn6UfdlQZE7RPCC+A75cbY1TFSOGMinDDpdvLagipfO4IajYdP6CnK67onNPBDCZkqielg4oWw5YEHAXFeLx7ZGcqP60KG4nKEWaLWkd3FB32BkRQ7iGJUfWqN2McjMVuxl1yTOrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241868; c=relaxed/simple;
	bh=bWb9btTd1zUVnmw1OSAOKA7Cwl92Jq1LwJj2ZP1scYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dcbqz1cOsS3VH04WydhBmY9SEBDCLhN2EK7QXtDwY+VHnfYi2fPVmX/FizknWWLQvehYGD36EgXmBdgVSK+r6VcUrNELaP7LvGO+nlFqmRzGT7R4SfNXlL127SxmseWl/B9ypRSveWXQPXZY2Z6k0nHl6jGraHHr+1yN8JFTKoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OlwYh7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OlwYh7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F63C1F000FF;
	Sat, 12 Sep 2026 19:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241867;
	bh=TAw4SFOuz8VbsQHijw/EICVN2dQlPmQRxikq/xSf6dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OlwYh7+GVADREfeyCyY3n1mEU0hGlcWkNdJG/1BkOKC8DtxnKiDV4mcIsHkJfVX4
	 MmAkRtwNXeI2srwESbdx5SnFurKaFZsacw7gWVAvQFumF2tATdrlEwDxUibwmhQ9aM
	 Qop+yd2HkNceuA9w5nYQP1SAdzneo2pnYVFSyNB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>
Subject: [PATCH 5.10 223/798] thermal/drivers/qoriq: Disable clock on resume failure
Date: Sat, 12 Sep 2026 08:57:31 +0200
Message-ID: <20260912065522.242933832@linuxfoundation.org>
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
@@ -369,11 +369,20 @@ static int __maybe_unused qoriq_tmu_resu
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
 
 static SIMPLE_DEV_PM_OPS(qoriq_tmu_pm_ops,


