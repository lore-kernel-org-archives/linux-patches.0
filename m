Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC5C8474
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFE3C433D2;
	Tue, 28 Mar 2023 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014683;
	bh=BzwoLEgEmjlQxZ6RaWl2xqKjtBWjOmUiNfAcfOcdHxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykIfOe0pJE/UMv6VdoLM9rIS7B0Q6r4vyd0WoPiazqgo8+NoX61Ba7tS37du50GRa
	 vZ0dfGBJDPwTlgqEdrNG7naBdn8nCdzdzgdbUejsZvMEKlWT2LqhZFkKFUHHLeI4NB
	 +5c7I0Dy6PZf/ik3MhmC73W/DgFNemskQFTXE+WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 015/240] power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition
Date: Tue, 28 Mar 2023 16:39:38 +0200
Message-Id: <20230328142620.288780822@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 2b2c3a4391c19..6bd711932e06d 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -1906,6 +1906,7 @@ static void bq24190_remove(struct i2c_client *client)
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
+	cancel_delayed_work_sync(&bdi->input_current_limit_work);
 	error = pm_runtime_resume_and_get(bdi->dev);
 	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-- 
2.39.2



