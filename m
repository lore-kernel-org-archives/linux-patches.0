Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5916635B15F;
	Fri,  9 Jan 2026 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961618; cv=none; b=eQ/Zv5UlajQOBcl11KgtSbiRtR5eGp385zNWHTkAhuGuv3VczPUInwpBqIBbOHbbykYVABvQ5ZiL0xTpsra0QB5nrEGhndyYSO5nmhcTBr1O/pOLAkezPbBbZJhQwsYZ035uKB0/REtFnrAKaAJIQbUauXZXCZWYmYgUqhs4Coo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961618; c=relaxed/simple;
	bh=m7ey/7ca90bmUSK28CLGFY8BNsiVXeThUL6aDmxqgNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhWhQNKUVqRoBesnLtqVqxlVZmbsoGJVfV+RxJtMTleiWa+2vuUAukid+tqwBV3yHVS7N2cSMh3G7BC360OW8WRGR7kcR1D/qvH3ZZIaqnXTGySCje63tiREwZBoDbRg/7fHlw2Ss5J3tjjUHVfHcl/rubZjA2zyVGTQOw9xEeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDCuZPTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDCuZPTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C968DC4CEF1;
	Fri,  9 Jan 2026 12:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961618;
	bh=m7ey/7ca90bmUSK28CLGFY8BNsiVXeThUL6aDmxqgNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDCuZPTXqr6pAqhR5Ys8w8uNKlXViBxLeyRSVdaDSxs5PZeIjGcZF8CwPL2RDohp+
	 3FYUyav6k6/f0ORfvbkrjUuWMt2OhG18Ft2Pv31SeHRUFJ+WD10wrJKfvPe5YBnajv
	 dnmzhF4WwAx2+52usyGCePe2ldHTikItg0Q2fyc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/634] power: supply: cw2015: Check devm_delayed_work_autocancel() return code
Date: Fri,  9 Jan 2026 12:35:56 +0100
Message-ID: <20260109112120.375675705@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 92ec7e7b86ec0aff9cd7db64d9dce50a0ea7c542 ]

Since devm_delayed_work_autocancel() may fail, add return code check and
exit cw_bat_probe() on error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0cb172a4918e ("power: supply: cw2015: Use device managed API to simplify the code")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://patch.msgid.link/20251008120711.556021-1-i.abramov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index ae6f46b452101..e4783f009a384 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -702,7 +702,13 @@ static int cw_bat_probe(struct i2c_client *client)
 	if (!cw_bat->battery_workqueue)
 		return -ENOMEM;
 
-	devm_delayed_work_autocancel(&client->dev, &cw_bat->battery_delay_work, cw_bat_work);
+	ret = devm_delayed_work_autocancel(&client->dev, &cw_bat->battery_delay_work, cw_bat_work);
+	if (ret) {
+		dev_err_probe(&client->dev, ret,
+			"Failed to register delayed work\n");
+		return ret;
+	}
+
 	queue_delayed_work(cw_bat->battery_workqueue,
 			   &cw_bat->battery_delay_work, msecs_to_jiffies(10));
 	return 0;
-- 
2.51.0



