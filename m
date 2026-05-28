Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B481E339866;
	Thu, 28 May 2026 20:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998876; cv=none; b=Jqmmc/8AWWOVebpsw1nCLizlkuBb4OLFo3NBecMAN6GcVPbEvEYZYBUdOu3m+IpR1PbZS0y4cy0DVsZIGmJjeubSCtgZ5k9P0unik2t1BdKLzfGjaTkYrIeJwpZ31E6jd+mV8cmFeUgMGQGRvvDNo/g4n1QwtsBQGVb24LY4P6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998876; c=relaxed/simple;
	bh=oIXaZEjqmXXBxWwVCT76ET8jE/AtxMqtQgghpwtCouc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6iH3krGWtsDYxqTzhn65h4AvqzL9A+hqHOSdJjxaCPe/wdDmj5PbYmGTuOOD94qngej/AgunnBJHXsxEAoSuCDdNWqRSBasR7/RQPIJIUN3lRne6T7IYFWB/iQ5VI+AH2gTqBPm+Dp0ji1Iow+lQ0ibFEkBeCg1KKGHDgBK9lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5C4f357; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5C4f357"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256201F000E9;
	Thu, 28 May 2026 20:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998875;
	bh=IoCjViE5gnCWw8VyZGrQIFfvUf6R2Ycw6lJVQqju7gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5C4f357eboez/PgvH8cFl11ZJ9qbDCQaQ6DmWOROzBMr9jIhlyYL3JBG1Z4VjjW+
	 +8IoCNXMY3O7U9NrWftd8XkWaAgQKAO08LyWJwy2NVnb7Mu0c0XnXP4kxgmNxPk4r3
	 AXSLqcMfCVTct2BO5TtRGHAxEFKWjmVLcj1mVSkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeroen Massar <jmassar@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 330/461] net/mlx5: Do not restore destination-less TC rules
Date: Thu, 28 May 2026 21:47:39 +0200
Message-ID: <20260528194656.900249540@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeroen Massar <jmassar@nvidia.com>

[ Upstream commit 8d0a5af8b1ba598e7340761729801624e7a9330e ]

After IPsec policy/state TX rules are added, any TC flow rule, which
forwards packets to uplink, is modified to forward to IPsec TX tables.
As these tables are destroyed dynamically, whenever there is no
reference to them, the destinations of this kind of rules must be
restored to uplink, unless there is no destination for that rule.

The flow rules FLOW_ACTION_ACCEPT, DROP, TRAP, GOTO and SAMPLE do not
have a destination port, and thus out_count = 0.

At cleanup time of the rules in mlx5_esw_ipsec_modify_flow_dests
we call mlx5_eswitch_restore_ipsec_rule but as the above types
do not have a destination we get an underflow of out_count, as
the port is passed, which is esw_attr->out_count - 1.

This change avoids calling mlx5_eswitch_restore_ipsec_rule when
there are no output destinations and thus avoids the underflow.

Fixes: d1569537a837 ("net/mlx5e: Modify and restore TC rules for IPSec TX rules")
Signed-off-by: Jeroen Massar <jmassar@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260513063302.333761-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
index 3cfe743610d3f..ab50d2c734ede 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
@@ -142,7 +142,8 @@ static int mlx5_esw_ipsec_modify_flow_dests(struct mlx5_eswitch *esw,
 
 	attr = flow->attr;
 	esw_attr = attr->esw_attr;
-	if (esw_attr->out_count - esw_attr->split_count > 1)
+	if (!esw_attr->out_count ||
+	    esw_attr->out_count - esw_attr->split_count > 1)
 		return 0;
 
 	err = mlx5_eswitch_restore_ipsec_rule(esw, flow->rule[0], esw_attr,
-- 
2.53.0



