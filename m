Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D251C7292;
	Wed, 20 Nov 2024 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107602; cv=none; b=V/Qo9/30XnnHQC6pxAX0Y5eLeifsfc6zmao0ZvIjKTJwWSaz3mP2XonJZmOYbs5ApizYqf1I9it04EiOh1GgnHyfTjFBObFdgWIIcqeGUgd+4PPcQxigtQebFCstRq6oA9bxqqzfggW0KNOD4lVlAGL/PBAhAkH+pkhLlVkjXcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107602; c=relaxed/simple;
	bh=wW7/2LmtAjY4abSW+EX/W2eqbUPG0qPqf4An+JQvf/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsxDZiNULpO79nYzi2sIQ3FRjtvn5te4Z6hlPtEkZ7xB2619BKswuBJdHYLk1HNNi/7VN5DTZtML2yxdhE6h2ANvYt9AF+I9nMdfmfgEVTQUxt+0FEiBl6m4G8Itg1iW+TWFH1hBNfIDeEXLdgCLdpc6UZUhDd+3IPN1wMOQ1w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8TcA/uw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8TcA/uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3B2C4CED8;
	Wed, 20 Nov 2024 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107601;
	bh=wW7/2LmtAjY4abSW+EX/W2eqbUPG0qPqf4An+JQvf/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8TcA/uwfhblQvHw8DUhCw/8WnvuzVWRzdmsjcnhyEXBQNtumqSaMDMpR+EOo2Z6a
	 7RnfKZEThZ/PD+QDflDvSGidrpMWdPtsven8r2DsPxWTbOyh7hjnwVDXhe8tufkP43
	 knJWwENkwzh2xEf58wwUgaNXWzA6bSaN85Hvz4DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 51/82] pmdomain: imx93-blk-ctrl: correct remove path
Date: Wed, 20 Nov 2024 13:57:01 +0100
Message-ID: <20241120125630.759762280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peng Fan <peng.fan@nxp.com>

commit f7c7c5aa556378a2c8da72c1f7f238b6648f95fb upstream.

The check condition should be 'i < bc->onecell_data.num_domains', not
'bc->onecell_data.num_domains' which will make the look never finish
and cause kernel panic.

Also disable runtime to address
"imx93-blk-ctrl 4ac10000.system-controller: Unbalanced pm_runtime_enable!"

Fixes: e9aa77d413c9 ("soc: imx: add i.MX93 media blk ctrl driver")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@vger.kernel.org
Message-ID: <20241101101252.1448466-1-peng.fan@oss.nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx93-blk-ctrl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/imx93-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx93-blk-ctrl.c
@@ -313,7 +313,9 @@ static int imx93_blk_ctrl_remove(struct
 
 	of_genpd_del_provider(pdev->dev.of_node);
 
-	for (i = 0; bc->onecell_data.num_domains; i++) {
+	pm_runtime_disable(&pdev->dev);
+
+	for (i = 0; i < bc->onecell_data.num_domains; i++) {
 		struct imx93_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);


