Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E924F402E;
	Thu, 17 Sep 2026 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665998; cv=none; b=fCOvebqZ345rESQe3VtwQqeiV2b/+fA+OT04hAXhFZdQeKCR6YAIwsvPhZZGrA7c3zp5ncRcwLHvC6EwjtJo4C/l0lWG8N2OJTy6h14YqZW3T1u3PsNHkb/aTNfwWvCoTJ9t2eqCx8AkauGA+vUVpnSzpgsOoK5Sy/5lWDmedts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665998; c=relaxed/simple;
	bh=bgU0zVogSZtduJWH/pOiE3MFRl7nDBsMuVMznA3QyKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QffRqwg3BgUFCaldCUXRtHhXZd0mP6ceG2Tb1X82AIrm7DtnbMoUCFcb60LfVknlT2jzPutNBhpUgIg70kj21sN2o/rto5/FnPmfd+hjTI/PXHSEExhDTTroFV+WPhrTNe8ZdXr04uSOik/0lnrCnXM8hJbqlgWJPs4kiLocJh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1texG9jY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1texG9jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B911F000FF;
	Thu, 17 Sep 2026 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665996;
	bh=db2SX4DN7hOKfY2iKHvHqPir7NKuScpDMWL7M45uFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1texG9jYk8VAinJS30HQZg5hwH3MA7FtPYHMEoqnOTspLTgAMIj+P4S988RRqX+z3
	 nPBq/r+byB146P0jWQVX/Y6mxAKSkICKCFP1JVlwrBZBJEfkYiB3hcqHGQkhVeaQLn
	 j5Z9KesRgh4sCWwMPzjQgYj+1PJ+m4BGiKaDzK6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0889/1250] net: macb: put the "mdio" child node reference on success
Date: Thu, 17 Sep 2026 16:11:24 +0100
Message-ID: <20260917151616.080296718@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 382a373d9ea7a6ac4de9c022385b6217f65ae3cc ]

macb_mii_init() holds the reference returned by of_get_child_by_name()
for macb_mdiobus_register() and drops it only on the error paths, so
every successful probe leaks a node reference. On a CM5, overlay
removal after four bind cycles reports

  OF: ERROR: memory leak, expected refcount 1 instead of 5

Drop the reference after registration, where __mdiobus_register() has
already taken its own for the lifetime of the bus.

Fixes: 8a6631f1cece ("net: macb: avoid redundant lookup for "mdio" child node in MDIO setup")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260907210856.1673589-3-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9889ee4bef00b..1e488f17f5aa9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1058,6 +1058,8 @@ static int macb_mii_init(struct macb *bp)
 	if (err)
 		goto err_out_unregister_bus;
 
+	of_node_put(mdio_np);
+
 	return 0;
 
 err_out_unregister_bus:
-- 
2.53.0



