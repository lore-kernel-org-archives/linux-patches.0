Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29D735202A;
	Thu, 28 May 2026 20:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001605; cv=none; b=T2yx5m12eB2tYC56ULvrOn1l06hMRst8mz2wG0wo0+RnJFWmUqrNUM8w7W4XVanN6/LGw9EbIYk9aKhBK5d2SJuV5gth/gJE9oYBKV1odmB6DqVpfVYV7WwscwFf71OLuKeDbM1RqaRGGQc9EUYzdtPN8wcw7qxy42ZV4ydcwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001605; c=relaxed/simple;
	bh=+2rkZp/0bb2TWESH3oD2/FB/oxQMzlspxpYZ+Au2D/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kimp5tIE1HxOFbgdg08BKW7ptYeEIw8EnwAJzilPTAQ8UBLErtREBkDtqzhF13YVRGD+MCByXhSWXOIZeCquIKN9XFa5XaWJr/r/HYHgnsJlwqxts5rgzYDkLncxICQeyawAzeM49vevZhJ//bFtLk6RkbSuQIJMFsw5Gv0D9Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPIdUYjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPIdUYjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9291F00A3A;
	Thu, 28 May 2026 20:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001604;
	bh=c9Y5g1F8uLduP0an0nB4Mb+/6PAbPaXrgY4zpv6YLgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPIdUYjLmcAaq4DyJOjBCEFpPJkNCCp1bTNoMRbZinq9I4XqQALYOITm4cgTk+kSj
	 +VmypObfHczwDIpZuxDG64EtGFBu33safVgNniQ2GjeZ4m7nczXuZ65+RCgt+dyNh0
	 grLmy1LyxZUHOIl9xdfk1miQMsZ6//CMhMWd53Ug=
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
Subject: [PATCH 6.6 150/186] net/mlx5: Do not restore destination-less TC rules
Date: Thu, 28 May 2026 21:50:30 +0200
Message-ID: <20260528194933.005954403@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eed8fcde26138..7dfec1629bab7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
@@ -129,7 +129,8 @@ static int mlx5_esw_ipsec_modify_flow_dests(struct mlx5_eswitch *esw,
 
 	attr = flow->attr;
 	esw_attr = attr->esw_attr;
-	if (esw_attr->out_count - esw_attr->split_count > 1)
+	if (!esw_attr->out_count ||
+	    esw_attr->out_count - esw_attr->split_count > 1)
 		return 0;
 
 	err = mlx5_eswitch_restore_ipsec_rule(esw, flow->rule[0], esw_attr,
-- 
2.53.0



