Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2223933EA;
	Tue, 11 Mar 2025 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706611; cv=none; b=j7gvuXJl3MQ7SDXDfU90JtpcmO4KBwnEmy2ZycaTXI9aC+4eIvlMtV5z4PAEhw1HCqocPLCTAHuSNeyfke2b1UCaLOQKZtbXllzmDB+GsKwVGDLH7Cl+DrpTGNZzSFkQXt45wwiPWene0lsr7BH8M8xfRnEFQLMPdNQVdCUSQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706611; c=relaxed/simple;
	bh=kItq/SFGHbXRworgDSj04aCif+142xLqGWaFqj6Yi+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3KVTfzZwXeVdyVVmURdKfm8O4gst0O0zMtrxDn0uRwtvERedxEZNokl7r1P0T7eFfho6ilra/aakEgmrfXQWAa7DNCDT/q7Te4hZZ/lwVIPxKLNW0WmBN2mK5ZkkoqierE1UxoCt+/ZJ2NVl0xr+xTmyJ0J6qPnjSaWyIuA+Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOf992F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOf992F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F423C4CEE9;
	Tue, 11 Mar 2025 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706611;
	bh=kItq/SFGHbXRworgDSj04aCif+142xLqGWaFqj6Yi+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOf992F54F7a7AOj9kSkgKf3jSd6GNODBYyhunmHd8OyYgwqtbkNHgQU6F+om1JnV
	 cSnUixwm+9VH8U0oi6lp85QTF1sHRMAfIVPoxZo928toZPJfBqx9WRVgeir4wpswNq
	 wj2qYz2cmfTVX0jWn0FQ+CzF9Ux2fmhzgjenI3Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/462] net: davicom: fix UAF in dm9000_drv_remove
Date: Tue, 11 Mar 2025 15:56:12 +0100
Message-ID: <20250311145802.551773591@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index afc4a103c5080..79aef6b368836 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1779,10 +1779,11 @@ dm9000_drv_remove(struct platform_device *pdev)
 
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



