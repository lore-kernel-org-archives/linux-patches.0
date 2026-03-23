Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA1C3BED43;
	Mon, 23 Mar 2026 16:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282649; cv=none; b=Tex1qICERwP29BXVXsEU0aCyyQXvjMoEup89MkClbIqhe73OGCJTQbAjry254uOojuu1pBDHaLi41zb6tKQKIMs/6clg7+BLiJB9rQQuWXM8K/p+QI0LzlZeSi+b4FXcz14J7rhKR4QJ3s/IGJOANAYgJ3BkpHZgLNj4mKsU/+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282649; c=relaxed/simple;
	bh=2w9hR/aw3Ovuwss4tOtVyPg30X+zEmBxIpKI+0hHqkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV+ghVOPh3ebufMB5m4urGVUpFiIePXSkvnCV6eOae91cbof/v56lpdcJWRNPw2wEo8GzHQJ/hua6Itlnqe5fE8hsZDD0sASpce7KvhyHQ/BWLZUOOnrGO8Fx19XLWpiwVDuFr04jU98ykhHGfFTP3T2LGeUZoXAVCw5n+DCiUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4l3+nTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4l3+nTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37BCC4CEF7;
	Mon, 23 Mar 2026 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282649;
	bh=2w9hR/aw3Ovuwss4tOtVyPg30X+zEmBxIpKI+0hHqkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4l3+nTA6R5Cbuou0NDgZ6mDAT9VXP3BJSd3pZNIPnUE1zjM2OB3w7LXo02N1jk5n
	 YU6NbJw60yGJuZWHQ+SMTG77AdRPWr3oCP2rtPMUoXPqziKvc8uigT+/kTtVUXuAk6
	 u0AJzkC0Or2F8K6ypVqV523F9LnWo+tvadqunOKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/481] octeontx2-af: devlink: fix NIX RAS reporter recovery condition
Date: Mon, 23 Mar 2026 14:42:54 +0100
Message-ID: <20260323134529.873105805@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dc26ca99b835e21e76a58b1463b84adb0ca34f58 ]

The NIX RAS health reporter recovery routine checks nix_af_rvu_int to
decide whether to re-enable NIX_AF_RAS interrupts. This is the RVU
interrupt status field and is unrelated to RAS events, so the recovery
flow may incorrectly skip re-enabling NIX_AF_RAS interrupts.

Check nix_af_rvu_ras instead before writing NIX_AF_RAS_ENA_W1S.

Fixes: 5ed66306eab6 ("octeontx2-af: Add devlink health reporters for NIX")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20260310184824.1183651-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 32fa8f2c5f4ee..48ce98ae56611 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -579,7 +579,7 @@ static int rvu_hw_nix_ras_recover(struct devlink_health_reporter *reporter,
 	if (blkaddr < 0)
 		return blkaddr;
 
-	if (nix_event_ctx->nix_af_rvu_int)
+	if (nix_event_ctx->nix_af_rvu_ras)
 		rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
 
 	return 0;
-- 
2.51.0



