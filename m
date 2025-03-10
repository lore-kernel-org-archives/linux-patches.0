Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DDC17A2E8;
	Mon, 10 Mar 2025 18:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629733; cv=none; b=b8PcJWEpgTBqNm6EFeZJlQZVjaLn/dyz2UgMe79k3Pxwb3zAhKFXku/vahuXixVNKRcv8FK2ufw/1/gHBWMOLxbieVy+H/eJG5ZxBGQKSyLNc04GxEzPLsMDQP+fZp/bnfhf4xJVKv7QVK+YYcxV9z5K1sSlTFQyAT1/4LlBit0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629733; c=relaxed/simple;
	bh=cOUd+e41ZntMxbs++QHBYdrcssJfWn4R9NB3QFLe89Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTDUfRt96pUSRqEyB9TjxJDKoCK+cGH/416UT85FI5SnpYiFf9ZIgcdioyB7DtiuzzUTxJ5/z/PLK33A9UQd/MhTchGvnLwdGEcv0SXE/izgsxdj8e8x14yeu1JAy2QCuZGibrF5rNPxJVf9a4g6+OdrWDBC1AgotRcx9RdLcDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg8adPyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg8adPyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48C6C4CEE5;
	Mon, 10 Mar 2025 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629733;
	bh=cOUd+e41ZntMxbs++QHBYdrcssJfWn4R9NB3QFLe89Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wg8adPyISJe4Nw4kdE9v485sYi+m6erLr5/if7s4/Z8PogfN2OailqXSgUGmoXymp
	 vgCDX8l5qTnRCchjg//s74kX6jyBr8uNKTtHZ3sb8P+SXQ0rzd+maB4VbOZMILAN+O
	 SX1ZVLsiQD7wPXdnu07dIQxCfxQWtjC5dBQlGItk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 387/620] mlxsw: Add return value check for mlxsw_sp_port_get_stats_raw()
Date: Mon, 10 Mar 2025 18:03:53 +0100
Message-ID: <20250310170600.870214482@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit fee5d688940690cc845937459e340e4e02598e90 upstream.

Add a check for the return value of mlxsw_sp_port_get_stats_raw()
in __mlxsw_sp_port_get_stats(). If mlxsw_sp_port_get_stats_raw()
returns an error, exit the function to prevent further processing
with potentially invalid data.

Fixes: 614d509aa1e7 ("mlxsw: Move ethtool_ops to spectrum_ethtool.c")
Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20250212152311.1332-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -761,7 +761,9 @@ static void __mlxsw_sp_port_get_stats(st
 	err = mlxsw_sp_get_hw_stats_by_group(&hw_stats, &len, grp);
 	if (err)
 		return;
-	mlxsw_sp_port_get_stats_raw(dev, grp, prio, ppcnt_pl);
+	err = mlxsw_sp_port_get_stats_raw(dev, grp, prio, ppcnt_pl);
+	if (err)
+		return;
 	for (i = 0; i < len; i++) {
 		data[data_index + i] = hw_stats[i].getter(ppcnt_pl);
 		if (!hw_stats[i].cells_bytes)


