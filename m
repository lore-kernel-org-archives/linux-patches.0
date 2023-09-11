Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C71291E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6AAC433C8;
	Mon, 11 Sep 2023 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440791;
	bh=63nrEpIwwuIsnZmcrT27LJUuFxi5qL0qSnIOU5qi9Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lj8tUnzyjaVwEksoASBm9oEUxDN6LQbfXK3Dbdp0NmWx/4p8r7FdVZ4Hh/F6R6ifE
	 L+3yDK+ncZkuabUtWVXc/6vecYOiGY6Z7aEfHyPzg4xfrYsEkJC3E7114tPaN0iCL8
	 IebSmsuhwTsg2qm/Z0qgJf2cJIb70HZKig/H+Z9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 186/739] mlxsw: core_hwmon: Adjust module label names based on MTCAP sensor counter
Date: Mon, 11 Sep 2023 15:39:45 +0200
Message-ID: <20230911134656.388485535@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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



