Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C78F4657D0;
	Tue, 16 Jun 2026 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630465; cv=none; b=Pooz8gNtY0bi9mxu6ya0TfjImeM0mVC5/z3vsWyXsmekEH6CLnhw/spn/mvk8/dUoB9GPqydVAySvG01P2mdwAuiRj2dSVizaPiXC6j55bO6IH2UFgrGwnrFovU3obNdI4NiGbLi/ZxHqZMMUW/3ajTesFYpzkyW82260UuCA1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630465; c=relaxed/simple;
	bh=/eF0D76Kq3LdmO62QD4GB4JdBoQe/PHTrIR+OP1v5ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCliDJg0Wfciw0ftzf5gyOgu2c/D7NGEwWhTo8aFwMBe9Vp0TpitXYpw4tucHgk3ZwuG4UOP2nkA53xJUaXtkmKwL8G164RdG1nqF/xFOA3sKqndIg0z8Ya2lOXjx/bCsNXFRXKmWA90mBn/lqGrHcrIR+KqT3qjyKZUQaR5UG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msk+ftab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msk+ftab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0611F000E9;
	Tue, 16 Jun 2026 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630464;
	bh=+XpWFDL/UcWFkO9pN2Nahbhz3w5DvABuEBSe/NCNSwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msk+ftab5ZwumMNSFy621WsJf0p7NhJ0zsqKAb55QDDFTIvUmRb+J4+vt607UBgMO
	 Fs5M7l686NPQYj/6et8cWRNFsS0BQwal/MWJ+ItBbd+fmz5yC6zAeThUOXWS5nJrMo
	 dbeIJJtkBs/J81/jBuviFAysCJUM/o97jUXh5CCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/522] net: cpsw_new: Fix potential unregister of netdev that has not been registered yet
Date: Tue, 16 Jun 2026 20:22:33 +0530
Message-ID: <20260616145125.661056557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 9d724b34fbe13b71865ad0906a4be97571f19cf5 ]

If an error occurs during register_netdev() for the first MAC in
cpsw_register_ports(), even though cpsw->slaves[0].ndev is set to NULL,
cpsw->slaves[1].ndev would remain unchanged. This could later cause
cpsw_unregister_ports() to attempt unregistering the second MAC.
To address this, add a check for ndev->reg_state before calling
unregister_netdev(). With this change, setting cpsw->slaves[i].ndev
to NULL becomes unnecessary and can be removed accordingly.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://patch.msgid.link/20260205-cpsw-error-path-v1-2-6e58bae6b299@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_new.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index c99dde9dbe7750..17c267f6d79aa9 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1437,7 +1437,8 @@ static void cpsw_unregister_ports(struct cpsw_common *cpsw)
 	int i = 0;
 
 	for (i = 0; i < cpsw->data.slaves; i++) {
-		if (!cpsw->slaves[i].ndev)
+		if (!cpsw->slaves[i].ndev ||
+		    cpsw->slaves[i].ndev->reg_state != NETREG_REGISTERED)
 			continue;
 
 		unregister_netdev(cpsw->slaves[i].ndev);
@@ -1457,7 +1458,6 @@ static int cpsw_register_ports(struct cpsw_common *cpsw)
 		if (ret) {
 			dev_err(cpsw->dev,
 				"cpsw: err registering net device%d\n", i);
-			cpsw->slaves[i].ndev = NULL;
 			break;
 		}
 	}
-- 
2.53.0



