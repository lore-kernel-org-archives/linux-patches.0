Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1364B249F9;
	Tue, 11 Mar 2025 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707103; cv=none; b=SJRSlcwI9fYKotlZKUrN3/tIF6zV8TaZGLL+SXUD+8xK3xSgR6SBocEPvA8hpggH3L3zYzGQ0h7OZ9nxHCuH20dBhKjpcbMwWzPDoxg3PaAECSZ18vKjmj2d0ThhFbQ6Ip2dDTINZaj00ijd4+RGmwHJKzXg3RLySW3KbgrnqKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707103; c=relaxed/simple;
	bh=2ZBVz6s5IstM3dSSa0uurAA6Bynjyr4v5RuhRaxE72Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbH0GKLsI+4T9CDE+tusuDH6/GbdfjZMR9r30RBIdPho1zh9CJHP+7eCkU9dkJMWbbadG1Cn9zrAmW3UByhhlpc9kOwMtJF98pqrrNKxXrNiYIwSLrAWlXhlEOZFzzysWDcxHVFdCbcboJfYXkm3JxHbUwajKpzbLGIyRWp+T24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFmw1SFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFmw1SFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392AAC4CEE9;
	Tue, 11 Mar 2025 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707102;
	bh=2ZBVz6s5IstM3dSSa0uurAA6Bynjyr4v5RuhRaxE72Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFmw1SFRgym1MD1FBoERx/0UrLluXBs+GKDsnnw10oxaJK5kUjteDmLZ8gatg/r8c
	 FLiSQ4YFVWKH4hne18vcM319eTb7/s4jWM40VV60Muha06sgOdVd+p6epQ5+mloYOW
	 icKYWOJBIQl3NUg9BSYL3Z0TcyFNpBE59rw026hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 273/462] mlxsw: Add return value check for mlxsw_sp_port_get_stats_raw()
Date: Tue, 11 Mar 2025 15:58:59 +0100
Message-ID: <20250311145809.149072687@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


