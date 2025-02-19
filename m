Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470B21E1035;
	Wed, 19 Feb 2025 08:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955198; cv=none; b=e6D4p1T1rhAVrFoVk9HWKZq0OY34HGBx5sC590rWHeCS1HkJuzVXWdP11SX7RL8Gwf+LL+ovadMNdb1gBfKAmcDBmVFAhVbiSdRtSxxdgsSc7tZmnbeyMOUgazW8V6KvofrnkD2vb48p8UZWEale5fakZaghlpcCpkkrjoGdSPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955198; c=relaxed/simple;
	bh=a7im5m3FV9BU733oYFMvl068MUM52U85nzteLcgIo/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf+OGwRxIbQx36ubwEA9DYio11kwBptWcKv53vbopsmOCn5FQiWhWnBMKobrgBKi4UrV4nfK62a45kL5VB5IPHhzwResQHFC7k9yGTcC3joiCpQkWmUjlVZouJ3sAnrfQhYaVskJ//4c8XM//UWfxw0Muem7JEjNVOFYaVoynUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoadyM7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoadyM7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A7AC4CED1;
	Wed, 19 Feb 2025 08:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955195;
	bh=a7im5m3FV9BU733oYFMvl068MUM52U85nzteLcgIo/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoadyM7cQNoodcD61+2b5OsrylK+/XdHhi1hG8Z9SKySHJ1t0bO73+N8zm8dSOol1
	 iGcfPaO0mIqjnqJxl1UYrr3ph/qL/rn8cbzIzPbCdzkPnUI2Y+/jXadgMRdczG7cp4
	 1o8EnZptHoZC6ygoIHEOfN98bESLP/TlDFs+HXFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 161/230] mlxsw: Add return value check for mlxsw_sp_port_get_stats_raw()
Date: Wed, 19 Feb 2025 09:27:58 +0100
Message-ID: <20250219082607.993073107@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -768,7 +768,9 @@ static void __mlxsw_sp_port_get_stats(st
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


