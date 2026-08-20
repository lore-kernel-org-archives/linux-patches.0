Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF8247D93B;
	Thu, 20 Aug 2026 16:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244624; cv=none; b=s/05Xky19YrVziHJ6tFV/L0PQAcrAGES8tKXV5prirUcj8xvBlRI7VSD+wxSZKhtuh3qaPoS8ET1iSVvVWYKyZcsunqwBjD52waum71paH6MmpFpZtGgNJNJmve9paKSBB+LV+59LvhehtnR54BefSLO9r+M+bCNfkvT+WURgvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244624; c=relaxed/simple;
	bh=rbzMGoEEeJtG3HhlKCTDvIeCwFL4UFB9fgOlM/PHxlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5aiStyKAIpG9GRgf3EswpqoEORY6Y2HeT0tz+ib5QLNj5Md+O/jx5MfLYddsBSfaXWxMMo0JxEKwZkE+AQ7QcaUNQnKO93KLTweWmB595jQnIQZFzj9Skl2j910I26kKkHgU2SQQ4/ljttHU5qZe7TR3+WwjYZ/+GiBRcXzxvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8nkP+AS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8nkP+AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EF51F000E9;
	Thu, 20 Aug 2026 16:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244622;
	bh=HBhCp3Gd7RXb2F4/xw3jm0NJGibQtqDr1BSEX3RccBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8nkP+ASBqTZsNbZlCPPOGGFMHuIUSlVWQ6lO7dFIWUy1hHJxuZxI65dSvNsFf/V6
	 958hKtHm49S+AXxkSN6uvQqI+SOHaAdyGoEsyfVAYIdWO7PvquLWohngZ80PMd/pV9
	 fznLdpXMr7U+7Ltm3wvnhUZL8ky2ciiwoGk8hd1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 234/235] net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()
Date: Thu, 20 Aug 2026 16:57:50 +0200
Message-ID: <20260820145223.708285611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit 46fb6512538d201d9a5b2bd7138b6751c37fdf0b upstream.

The am65_cpsw_nuss_cleanup_ndev() function calls unregister_netdev()
even if register_netdev() fails, which triggers WARN_ON(1) in
unregister_netdevice_many(). To fix it, make sure that
unregister_netdev() is called only on registered netdev.

Compile tested only.

Fixes: 84b4aa493249 ("net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1947,7 +1947,7 @@ static void am65_cpsw_nuss_cleanup_ndev(
 
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
-		if (port->ndev)
+		if (port->ndev && port->ndev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(port->ndev);
 	}
 }


