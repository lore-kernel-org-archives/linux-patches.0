Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49BB4B04B2;
	Wed,  9 Sep 2026 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961752; cv=none; b=AR396s3hO1Mu7yY6Q1sszlY4gIvUU4o3Vk8z5PZvTwzkhZKsLS2uBcpmkpZlur/04YZx0n6q30oAoSNAoiW3zN+EdNJYn5m7tiYi15OBZZDcpeYWlOd++A0TPhJgv0Kkb5OMwR+Ja4b0qADQkUrZ4CIPyngrN00LIcg6FnkUWCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961752; c=relaxed/simple;
	bh=daGEu54pj0YvDVVft1MbZbZEkN4doxELE3ZFWexb40E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4qf2JlW7HderBF7QAfkn7etO9CVeexQQsEbvvbPIberpfmuhOtiYa8dD8YibP2807t4PzddLzmUQEMjlg8i2IBlHY6D4df09zUc9OEzVCUFvsQkOUoBY1y4aEhwlvMNTqOY7WfeTj+LWv7DFVIzAkS84QNnIZKW2o49OgGSOPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QooyYb/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QooyYb/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316491F00A3A;
	Wed,  9 Sep 2026 13:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961750;
	bh=l0+x+2w2SbYaDet2wlCYg4dDODTzW5MnowaHzMHuqoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QooyYb/s7Z7wbnzdNyhQRkmLmCk3+4R8BwiqsDHTl5OakoreyT3JX/cMP2kD2gYg5
	 X+0YVQgrHBY0jHkfcn1T1o7WMVyl8wxZuEDorT69E3Da22P9c3EI0ij1EnWeHmtoJE
	 hDjH5aTNeq6VPXY+TGwD+A6XhDOunxrVJq3fhqGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>
Subject: [PATCH 7.2 055/556] thermal/drivers/qoriq: Disable clock on resume failure
Date: Wed,  9 Sep 2026 15:35:35 +0200
Message-ID: <20260909134232.408147992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -415,11 +415,20 @@ static int qoriq_tmu_resume(struct devic
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


