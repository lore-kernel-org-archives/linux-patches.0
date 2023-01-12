Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE5679C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F63C433EF;
	Thu, 12 Jan 2023 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533310;
	bh=+bpwetV2LU1ff15V/8g0/4eBKS2uxah7labs5OX4CiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHIt7DMQtJeHDQvKQ7GHZs0C/fF5zmtz6bsN9sQ9xauFgF0LLazkDzvmrEcC9atI3
	 9EljL8sDgjLQ6F40AhZOEW9kDX2ZJhAGuLBovP53ZvsSxZNyHWmN2cmGYgNtr0Dy6H
	 6peoMTpgiQpbYTs2v9B2/vhBTY+1ZIsV08rl/9vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 407/783] power: supply: fix null pointer dereferencing in power_supply_get_battery_info
Date: Thu, 12 Jan 2023 14:52:03 +0100
Message-Id: <20230112135543.188344644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit 104bb8a663451404a26331263ce5b96c34504049 ]

when kmalloc() fail to allocate memory in kasprintf(), propname
will be NULL, strcmp() called by of_get_property() will cause
null pointer dereference.

So return ENOMEM if kasprintf() return NULL pointer.

Fixes: 3afb50d7125b ("power: supply: core: Add some helpers to use the battery OCV capacity table")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index be2cb925c115..2b644590fa8e 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -677,6 +677,11 @@ int power_supply_get_battery_info(struct power_supply *psy,
 		int i, tab_len, size;
 
 		propname = kasprintf(GFP_KERNEL, "ocv-capacity-table-%d", index);
+		if (!propname) {
+			power_supply_put_battery_info(psy, info);
+			err = -ENOMEM;
+			goto out_put_node;
+		}
 		list = of_get_property(battery_np, propname, &size);
 		if (!list || !size) {
 			dev_err(&psy->dev, "failed to get %s\n", propname);
-- 
2.35.1



