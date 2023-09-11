Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25B11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68137C433CD;
	Mon, 11 Sep 2023 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445037;
	bh=3Lw66HD1xP7XjKQhMghKzx13keH4bvsNOXxH0yL1d6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdmOpvMsktKHamB5v1QonSkvkSwSmNe0QLCm6jCSnU9NlUBNX33fLgDVIRZ56rgzt
	 TnrgyaKfbwNgIprcp4NBaxzFsrKCjkZm7C7hlT0p3NX0FMWhzz0JVpuDA5BZChZY7L
	 lqnm8HOejJGLKIsIlS9mK42DGz5/zeQ3BH91skw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/600] mlxsw: core_hwmon: Adjust module label names based on MTCAP sensor counter
Date: Mon, 11 Sep 2023 15:43:56 +0200
Message-ID: <20230911134639.612782986@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



