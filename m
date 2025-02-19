Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0CB1E0DCB;
	Wed, 19 Feb 2025 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956574; cv=none; b=A/dP/mmxrhMwGqwzWEzsvCxJDAh5ldzjzeatwqA2KItSoGJH4sZpaDBnVHY2pF+QjK24aDwQc5nHivUcuHAZ5ZDMyIYPePHEZRkUxZQYFkZP4zOWqySqVzSzEPRO4WOxUT92erkNcetYJ+3llP0vyZZpjC5u6z+vxzWSZBd4UD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956574; c=relaxed/simple;
	bh=t832xI1xu726SELP9QeAtetDXZP8UxfM1gTWpWUOokc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pysw4FR8qFFobw4Vnnsi412Hv72yIUWO7D/Ow9SrLjDHrTp8ylsDXLAJEsjm1ql6Wp6AlwgnQ6ctu81cVnuGtlk+Y/EKhMAumkfGL2t8EeTsX9aHwz9NBCbzEE78f4ZHkbQZRfthAvOKrl/dpTRDlDYvEe4RJHLyDVugozr4Y6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiV7iAo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiV7iAo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B95C4CEEB;
	Wed, 19 Feb 2025 09:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956574;
	bh=t832xI1xu726SELP9QeAtetDXZP8UxfM1gTWpWUOokc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiV7iAo7c+JSHAjXpxvGEAKPpLZbJslRv2lb7lsf3GgCKnRRc9qzEdIS/d/DT37Dq
	 AzCjPMxA5S8mF1MAbBF6zFde9IM3lOLRddPbAF7coM7jTeE4bOli1CNJoA8DuhzMKG
	 bhCNiOfNS6wTV3bawabil2L3fesJ25U+5IdrKclc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/578] net: davicom: fix UAF in dm9000_drv_remove
Date: Wed, 19 Feb 2025 09:23:50 +0100
Message-ID: <20250219082701.940738818@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 19e65c45a1507a1a2926649d2db3583ed9d55fd9 ]

dm is netdev private data and it cannot be
used after free_netdev() call. Using dm after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() at the end of the
function.

This is similar to the issue fixed in commit
ad297cd2db89 ("net: qcom/emac: fix UAF in emac_remove").

This bug is detected by our static analysis tool.

Fixes: cf9e60aa69ae ("net: davicom: Fix regulator not turned off on driver removal")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
CC: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250123214213.623518-1-chenyuan0y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index b21e56de61671..c79d97f4ee900 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1778,10 +1778,11 @@ dm9000_drv_remove(struct platform_device *pdev)
 
 	unregister_netdev(ndev);
 	dm9000_release_board(pdev, dm);
-	free_netdev(ndev);		/* free device structure */
 	if (dm->power_supply)
 		regulator_disable(dm->power_supply);
 
+	free_netdev(ndev);		/* free device structure */
+
 	dev_dbg(&pdev->dev, "released and freed device\n");
 	return 0;
 }
-- 
2.39.5



