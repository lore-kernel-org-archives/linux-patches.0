Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3431E1A17;
	Wed, 19 Feb 2025 09:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955729; cv=none; b=oG2PkDrc+Tg/CYK/1P6cOEr1yVJ91EvBb6AwA272vKwHEFX9onP8Y8Vwh4PyjgG19vtOpN5tRrB3QgWYTtYOp5++TBaEdEBrvFhTeshfe96cI5VEzaOT9B4F0UfiwbcudTJaDK1dO81JFEo5VdNQ0Jcisl1WmR1qEXicAayLXbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955729; c=relaxed/simple;
	bh=6qi+W2HzRei5X7koxRE5FyQ36iCC2qjhkYQaqqAY7Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RehCBSRQ+lLtefoC7K4G1ZoaT3ue/g2Ooyuc/QxJr5MWk72l8MuAXtZ+AEe3dWEhr/9mKr8cMzVY1vLIzAdCQFTsTt3DLwWk3hxOx5aolQ59zH0aBo7Kfz+VME6L32nRGBwfa+YPwHi2Q4/yABI+EKVZLxpbT4dAIDxVAyB3ias=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7lIK+Kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7lIK+Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC60CC4CED1;
	Wed, 19 Feb 2025 09:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955729;
	bh=6qi+W2HzRei5X7koxRE5FyQ36iCC2qjhkYQaqqAY7Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7lIK+KnACLf7rOIQGMU42iLYs5sHNQG8rgqIXUguP6OU1+uCjAmSycZt+2Uy7eqM
	 BX88Ft0bwjbvgpgrXW9azSG4p9DoUK4sco5jP4CPaqyHz/uxqOuzrFMq9YpcLOO5kw
	 uD/yNMIHnIr9uHNLYrObcqqwvUEFjH4EA3WEQbx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 095/152] mlxsw: Add return value check for mlxsw_sp_port_get_stats_raw()
Date: Wed, 19 Feb 2025 09:28:28 +0100
Message-ID: <20250219082553.813024781@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


