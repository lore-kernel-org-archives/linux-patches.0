Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92CF11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A83EC433CA;
	Mon, 11 Sep 2023 14:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443085;
	bh=3NlUmPktlyhUt6PnkO0KcM5WG1cqhCmyIqPfaYYm8ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clwa/P6gnv9xtYxAH8ibI2SVpuI4MWu85sbugSPIj6lRPPeCGBBJ0txetegr8sYr9
	 EMmi2g6xc9xPzfsvG4f3bZDQwrT5mCzCDTH7jNQX/dRDowQOEbuUEFBsICfVOGXlBe
	 rB+a6Dl9FNd0G6uvicj5q6in69SwZe0Qz0vleF1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 253/737] mlxsw: core_hwmon: Adjust module label names based on MTCAP sensor counter
Date: Mon, 11 Sep 2023 15:41:52 +0200
Message-ID: <20230911134657.660677974@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 3fc134a07438055fc93ce1bbacf2702ddd09500c ]

Transceiver module temperature sensors are indexed after ASIC and
platform sensors. The current label printing method does not take this
into account and simply prints the index of the transceiver module
sensor.

On new systems that have platform sensors this results in incorrect
(shifted) transceiver module labels being printed:

$ sensors
[...]
front panel 002:  +37.0°C  (crit = +70.0°C, emerg = +75.0°C)
front panel 003:  +47.0°C  (crit = +70.0°C, emerg = +75.0°C)
[...]

Fix by taking the sensor count into account. After the fix:

$ sensors
[...]
front panel 001:  +37.0°C  (crit = +70.0°C, emerg = +75.0°C)
front panel 002:  +47.0°C  (crit = +70.0°C, emerg = +75.0°C)
[...]

Fixes: a53779de6a0e ("mlxsw: core: Add QSFP module temperature label attribute to hwmon")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 70735068cf292..0fd290d776ffe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -405,7 +405,8 @@ mlxsw_hwmon_module_temp_label_show(struct device *dev,
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 
 	return sprintf(buf, "front panel %03u\n",
-		       mlxsw_hwmon_attr->type_index);
+		       mlxsw_hwmon_attr->type_index + 1 -
+		       mlxsw_hwmon_attr->mlxsw_hwmon_dev->sensor_count);
 }
 
 static ssize_t
-- 
2.40.1



