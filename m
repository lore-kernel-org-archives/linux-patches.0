Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE2C2E736D;
	Tue, 21 Jul 2026 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654558; cv=none; b=ENVfSlk0R51HHoVpHxnachWekOa+7M16OtHq7nsJXR2Fy6v7hgAgHu8bznCxTnW07Z82RzJf8hJc7WBuTSziheN9tWZhmqs5ITO11etuyfXEccQETDbemf+0mlAC2KPsRKOwXrJQp/7KxJdZcb0nVzRHDQg1LNiBtoHpv+Gj5eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654558; c=relaxed/simple;
	bh=QS6R1L+8e0Ba4MefoV5NRsV0ogaWLEtcTc30aLSBFYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT+G2WvZBiNMhQXlpdsl9e0wqZmDCza1Tb3bfs/gKYAjEQpuCQ3wx3t9ZV/44EJkokAHHfa/oQ5Iihy76L69bIwCSRtWmpFR1x9PXShAWQpZCjXj37/TLdst9GqMmVBrbGNjCrFgHqQm0pqT09cLOJgOqAje780J1hHSFOLs1Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzkDYWlL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzkDYWlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45BE1F00A3A;
	Tue, 21 Jul 2026 17:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654557;
	bh=QrekykQl6biRWfVvLf4H1O7mvwABjbtDff4iT7vLEwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzkDYWlLNcuLq7++hZLO8qi2IbPxCug7BlW4gDb61UxBoqMbgqL7BRfkJWRehyhhs
	 cNyCE0+uf/ctPZ3liNRVbsN9iIbmtQUEQqnEZUpyqfGvhWrPt9KvIQaEBSCPfPn2Vf
	 BiIWvpymhafM0MT9sWUkFztAIK0ottA087hwV3nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 1748/2077] mtd: rawnand: fix condition in nand_select_target()
Date: Tue, 21 Jul 2026 17:23:41 +0200
Message-ID: <20260721152633.975308194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@rulkc.org>

commit 8507c2cc9e4fa402401819f44d1e8a5ef4d11d8b upstream.

'cs' here must be in range [0:nanddev_ntargets[.

Cc: stable@vger.kernel.org
Fixes: 32813e288414 ("mtd: rawnand: Get rid of chip->numchips")
Signed-off-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -175,7 +175,7 @@ void nand_select_target(struct nand_chip
 	 * cs should always lie between 0 and nanddev_ntargets(), when that's
 	 * not the case it's a bug and the caller should be fixed.
 	 */
-	if (WARN_ON(cs > nanddev_ntargets(&chip->base)))
+	if (WARN_ON(cs >= nanddev_ntargets(&chip->base)))
 		return;
 
 	chip->cur_cs = cs;


