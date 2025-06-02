Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B1E1FF61E;
	Mon,  2 Jun 2025 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877081; cv=none; b=GCoYCpHk/SjYbCobBAfJdFnQLtGXtT3Ytx5Z5pdbgDQofOIS29JZtt7pruFuhqLsufkfKy0vPUldoTMrV7oCIOiRsVXMwf/aTSUPfqY5EgPqT/pltBqlvzScmpfVkCcHUsq8grt41KRQx7jy/DYo1YL9kVhWYSXWUGmGIfWOq+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877081; c=relaxed/simple;
	bh=umh8fiGDM5LuWbVmJUuEpdiSOCNAgEcDIrulbUmeI5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GThQDdU4PSYK0gLpxXTErdZ80hm8//do84wq6NOLZtnNJtYQ7twtN3qvjQOujwdVfQLqj168CJvF1pj+Ohyy1CDjrcDLcSG8VjxkfjS6LikmSnaxEY7yIidBP7rZwBJs0maPKLKNIj98GHL1f9V/J2ghTd44XLpfhX3WZlapG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcqkiKjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcqkiKjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9669C4CEEB;
	Mon,  2 Jun 2025 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877080;
	bh=umh8fiGDM5LuWbVmJUuEpdiSOCNAgEcDIrulbUmeI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcqkiKjpGXg3qDbbUm2i62O4dMfnLkyVT+M0AJ8vlW/9oIpypapngF9Cab1mek5lT
	 ZqRxnYarwQQqXwkMyefjpPCj9uWBznM9HT3aLJrbPYhKk6l3ulmKl/RpmPul9BnKnY
	 VNddego5REbJsgzrrrwlbKB5sZJQOJ9qh/zQb4Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/325] net/mlx5: Modify LSB bitmask in temperature event to include only the first bit
Date: Mon,  2 Jun 2025 15:47:21 +0200
Message-ID: <20250602134326.500076375@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 633f16d7e07c129a36b882c05379e01ce5bdb542 ]

In the sensor_count field of the MTEWE register, bits 1-62 are
supported only for unmanaged switches, not for NICs, and bit 63
is reserved for internal use.

To prevent confusing output that may include set bits that are
not relevant to NIC sensors, we update the bitmask to retain only
the first bit, which corresponds to the sensor ASIC.

Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Link: https://patch.msgid.link/20250213094641.226501-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 9459e56ee90a6..68b92927c74e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -163,6 +163,10 @@ static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
 	u64 value_msb;
 
 	value_lsb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_lsb);
+	/* bit 1-63 are not supported for NICs,
+	 * hence read only bit 0 (asic) from lsb.
+	 */
+	value_lsb &= 0x1;
 	value_msb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_msb);
 
 	mlx5_core_warn(events->dev,
-- 
2.39.5



