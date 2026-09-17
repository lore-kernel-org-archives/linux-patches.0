Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CC4ED1B7;
	Thu, 17 Sep 2026 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661121; cv=none; b=Wnb8E+YTv4fNl2TWR/enklv23AWWKnQjaXh5Luzo0ExhfsLMQaRr7ssx4Tm1NTguN2mAwQ3Kt5n4DRP3jYzB6smwYjnSvgUSEuiWBReef9dc6D4w2O3r5l01MW7r7P/7MfIwd6qBrwal8DMe7DG78PYoT/DkJ4kaOXZYasFxpO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661121; c=relaxed/simple;
	bh=E5Q0EH6rM81/dY8taEV4lZ9XVqSKha6CKOgXphbY03Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGhJoAPb3DBEhQUDnKIhR3HwcW1+8DusPeTt7TidQ1yG30v7jlegwt/3I9Kk7muNngEoiIf7OlEFxx/CxJ1UgyQwW445MsysaQfNMwccPAt5hlijfcKob9Kmu4emgqvuhPDiPyBb7+Wgjj35+CsK/KeP75OKuSnMR9dhY9npTCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAtz8lz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAtz8lz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA0D1F00893;
	Thu, 17 Sep 2026 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661120;
	bh=QTJS/LaXuCbpQLVLNUD76PP9lL7q7IsEvjXSkg45X4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAtz8lz9k5pbDVn7NWSMhVstbDuxqmeqxdwzufPgIOe4kyBud3v9qP/Tzyz/hd839
	 9SVV1Rl+d8wM+wMc85eihjd99g/FSQBg4yVcAjEc7ugDJxXwVpxnAezkey8Tx6eKJj
	 5EbbviLGmo24qlRZHTZakVsgurLoYpp2fBZTLztE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erez Shitrit <erezsh@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0090/1250] net/mlx5: HWS, Handle destroying table that has a miss table
Date: Thu, 17 Sep 2026 15:58:05 +0100
Message-ID: <20260917151554.424713469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 60e9e82f162ab7399373ff2185119289e4f6dc06 ]

If a table has a miss table that was created by
'mlx5hws_table_set_default_miss' API function, its miss_tbl
keeps the table that points to it in a list.
If such table is deleted, we need to also remove it from the
miss_tbl list, otherwise the node in miss_tbl list will contain
garbage.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260507173443.320465-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
index 6113383ae47bb..07a3dd1248c77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
@@ -282,6 +282,9 @@ int mlx5hws_table_destroy(struct mlx5hws_table *tbl)
 		goto unlock_err;
 	}
 
+	if (tbl->default_miss.miss_tbl)
+		list_del_init(&tbl->default_miss.next);
+
 	list_del_init(&tbl->tbl_list_node);
 	mutex_unlock(&ctx->ctrl_lock);
 
-- 
2.53.0



