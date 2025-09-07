Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB4E1CDFAC;
	Sun,  7 Sep 2025 20:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275630; cv=none; b=sRc41wMBLEOO+aAzAggvWHvGjGChgw6ZDlLXzYl4MwGsBG72wJUA219qsIuMJy7y+4C9Ck/cefMXBTD0R//ss3mK9KsV3P8uTNpwpMSIpIL73vLnsd9ZwAVko9cDFmMCHA56WnH84O0QofneSjWpZ+/Nw9qFm9Y1bV4rrQH9CCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275630; c=relaxed/simple;
	bh=UPVBD489bpfNMgTb0fyYpiNa4V6gUwrSj3Ef4uo8W9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1RPkMEDf8DFrEIZXWDD8yXFyKkwTp6mvuBvn45HJWdB5ORTnFNj3fSv8rDT/zJHi0zICOwcfgoKBlzSYWuIK5+pwl/HQBGhZtOYeJxqGC1uTQO0gQPOVXX+lHkDiEwEl2EBjcQ0Qk9+DJGealZzQF6F5GSiLWk3bj4ht21psN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsLhAdQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsLhAdQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F86FC4CEF0;
	Sun,  7 Sep 2025 20:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275629;
	bh=UPVBD489bpfNMgTb0fyYpiNa4V6gUwrSj3Ef4uo8W9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsLhAdQTqWXXDPodNV6XywlMHgnL+UFkYUpQ49JI7vvf1QQOKXPvKAN4SwFrFETKT
	 oF46/uG2T/YW/NA3yulyGJFoVHXhLBwiG4H8I65gQlf40JzfmlmUp5Ou0vm1aR4QJI
	 WodBjRDmm5BsO7jve/QcAygK4laVRxporeQ0We4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/52] net: thunder_bgx: decrement cleanup index before use
Date: Sun,  7 Sep 2025 21:57:35 +0200
Message-ID: <20250907195602.434826639@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9e3d71a92e561ccc77025689dab25d201fee7a3e ]

All paths in probe that call goto defer do so before assigning phydev
and thus it makes sense to cleanup the prior index. It also fixes a bug
where index 0 does not get cleaned up.

Fixes: b7d3e3d3d21a ("net: thunderx: Don't leak phy device references on -EPROBE_DEFER condition.")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250901213314.48599-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index f5dbe2f5af659..daabd851dae87 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1523,11 +1523,11 @@ static int bgx_init_of_phy(struct bgx *bgx)
 	 * for phy devices we may have already found.
 	 */
 	while (lmac) {
+		lmac--;
 		if (bgx->lmac[lmac].phydev) {
 			put_device(&bgx->lmac[lmac].phydev->mdio.dev);
 			bgx->lmac[lmac].phydev = NULL;
 		}
-		lmac--;
 	}
 	of_node_put(node);
 	return -EPROBE_DEFER;
-- 
2.50.1



