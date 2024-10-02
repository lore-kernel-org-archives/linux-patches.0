Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2287918DF60;
	Wed,  2 Oct 2024 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876200; cv=none; b=WwtIX8Txoqfdqys87la1RVoK/m9tnc8fktIVSYQbyU/prVbC6CSL1+tsLWp9mzzdKruVv2Z4G73DjlN1rYhKRgkE7rJah/0H3pj8k4htZGYq27QSwAm32nITsmyAyPsU2lzcxTdI1Qkef+QjMDM3VcTgcPvWESQF64gAuLRtfjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876200; c=relaxed/simple;
	bh=KdCxp2+IcdbOnOfbmz51E4fX+/HkoB0ZE067gAUDaSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFy91/rUkByLBP+AgmFZnNloMBYldz/PYP0zbvT3mVDbf1f3gr05PYBon88loGrblvGE3ZppS1HbzvcEa8GBeWdo/pe5CEGXqbv2/+pLC9YLE2IF1yDNZl8+jJ3pai3cINJ8+r1oTzaVWdDVrBDD5zNebdoDTRvKp8HgAwcAr3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq0AUiXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq0AUiXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0132C4CEC5;
	Wed,  2 Oct 2024 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876200;
	bh=KdCxp2+IcdbOnOfbmz51E4fX+/HkoB0ZE067gAUDaSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq0AUiXtnRO6X26r9RF131WDSLdxFGUBs3vJsf+0hpUjVEWLm8kH/TZluIUMg0waU
	 ozDQ7zRRBe2McAl0KFhkE23/J8siX3qAU1iAGqjOHIiEItdt3XvId4xsdumo9VUn4/
	 qcbcR1QXCC0ANHuK0pZYdi5wdzfGsl70nPACmx6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 363/695] Input: ilitek_ts_i2c - avoid wrong input subsystem sync
Date: Wed,  2 Oct 2024 14:56:01 +0200
Message-ID: <20241002125836.934705879@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 7d0b18cd5dc7429917812963611d961fd93cb44d ]

For different reasons i2c transaction may fail or report id in the
message may be wrong. Avoid closing the frame in this case as it will
result in all contacts being dropped, indicating that nothing is
touching the screen anymore, while usually it is not the case.

Fixes: 42370681bd46 ("Input: Add support for ILITEK Lego Series")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240805085511.43955-2-francesco@dolcini.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ilitek_ts_i2c.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/ilitek_ts_i2c.c b/drivers/input/touchscreen/ilitek_ts_i2c.c
index 3eb762896345b..e1849185e18c7 100644
--- a/drivers/input/touchscreen/ilitek_ts_i2c.c
+++ b/drivers/input/touchscreen/ilitek_ts_i2c.c
@@ -160,15 +160,14 @@ static int ilitek_process_and_report_v6(struct ilitek_ts_data *ts)
 	error = ilitek_i2c_write_and_read(ts, NULL, 0, 0, buf, 64);
 	if (error) {
 		dev_err(dev, "get touch info failed, err:%d\n", error);
-		goto err_sync_frame;
+		return error;
 	}
 
 	report_max_point = buf[REPORT_COUNT_ADDRESS];
 	if (report_max_point > ts->max_tp) {
 		dev_err(dev, "FW report max point:%d > panel info. max:%d\n",
 			report_max_point, ts->max_tp);
-		error = -EINVAL;
-		goto err_sync_frame;
+		return -EINVAL;
 	}
 
 	count = DIV_ROUND_UP(report_max_point, packet_max_point);
@@ -178,7 +177,7 @@ static int ilitek_process_and_report_v6(struct ilitek_ts_data *ts)
 		if (error) {
 			dev_err(dev, "get touch info. failed, cnt:%d, err:%d\n",
 				count, error);
-			goto err_sync_frame;
+			return error;
 		}
 	}
 
@@ -203,10 +202,10 @@ static int ilitek_process_and_report_v6(struct ilitek_ts_data *ts)
 		ilitek_touch_down(ts, id, x, y);
 	}
 
-err_sync_frame:
 	input_mt_sync_frame(input);
 	input_sync(input);
-	return error;
+
+	return 0;
 }
 
 /* APIs of cmds for ILITEK Touch IC */
-- 
2.43.0



