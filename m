Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A5352FCE;
	Tue, 26 Aug 2025 14:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218580; cv=none; b=u6f+b5gJpcvQo1Xd/1T92RxmKeyElY40ajrvdQjkOA6RJe/xNlfYVw7xQ/07xEWlEW5NnI1B4raHD5IVO0SFXuRtVkykPWnm3XB5lhmbDqpxQd+nPDdwK4ZdEPji1xdV6CtGOWFaTPkqE39Fv2eZ8U6opOmgQC747CoqZmZm8Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218580; c=relaxed/simple;
	bh=4mSnkWYzGcpDXrXza/A13wb37h9ieH9cPulwMCPflHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bud85dzZh27p12NQNUX7u1uUlWfRZq3Mcp5Qb3vvNOjm2h6o7Nd6GKzClVEg2m0uFJrf6GYkGOVk8uIyrEGcsC++2ndIng9cCmfm38hApHcZhLFJ7ln2rpOok4XtXFq9BfNNhG+N7dJUIVKevCGgW+KSheYM6jL/qFZoWl5tA7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSTzlw7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSTzlw7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3710C4CEF1;
	Tue, 26 Aug 2025 14:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218580;
	bh=4mSnkWYzGcpDXrXza/A13wb37h9ieH9cPulwMCPflHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSTzlw7sl2OM0KFOD8/1O6ScSKODF+3zOVAfC6dPznxWBomjuKeibtCgfoLUFT7ml
	 07VJgtPmqXjq798XCtBl31Njvyocie90gpaWlA7pMDU36FdfPattwSa5cmHgdoMiIW
	 k5IM5/avg20AA4WupWMlVrri2itvQTVc8eWTgVsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 047/403] power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition
Date: Tue, 26 Aug 2025 13:06:13 +0200
Message-ID: <20250826110907.138621565@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 47c29d69212911f50bdcdd0564b5999a559010d4 ]

In bq24190_probe, &bdi->input_current_limit_work is bound
with bq24190_input_current_limit_work. When external power
changed, it will call bq24190_charger_external_power_changed
 to start the work.

If we remove the module which will call bq24190_remove to make
cleanup, there may be a unfinished work. The possible
sequence is as follows:

CPU0                  CPUc1

                    |bq24190_input_current_limit_work
bq24190_remove      |
power_supply_unregister  |
device_unregister   |
power_supply_dev_release|
kfree(psy)          |
                    |
                    | power_supply_get_property_from_supplier
                    |   //use

Fix it by finishing the work before cleanup in the bq24190_remove

Fixes: 97774672573a ("power_supply: Initialize changed_work before calling device_add")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq24190_charger.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -1845,6 +1845,7 @@ static int bq24190_remove(struct i2c_cli
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
+	cancel_delayed_work_sync(&bdi->input_current_limit_work);
 	error = pm_runtime_resume_and_get(bdi->dev);
 	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);


