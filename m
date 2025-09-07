Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217FB1CDFAC;
	Sun,  7 Sep 2025 20:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275918; cv=none; b=gQBPRcb9CeY5zoTAClkYCoi4K1tK/pZWlYUzBVo+TYENygvf8YrLtODW9jopJF7xPC2XditNr1vVsfS8825vgerDPV/Ne6FjrtoiTgdJGRx3cjLze3C2ZpDJZEb0m6Hg1QgLnP5XWbkrC3VvZ46noa7tlCbs6nASHTowzC41B1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275918; c=relaxed/simple;
	bh=HJUJOrljI1ejWc20DbZsrlB7tSGXq8bhabQiPqrVzQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWIcWOwVJzX508QUiC0p5SiaEz9PLWwVD8RXJNBrFzFKmoJf0Q7qJaUoggdjPFGNVLfGFwqBSRlVSYFPI9sVk6Q53mbQaiabLhsxzRZH69w1qDFHFLjrjR9/lT+jNkbqJq7J0ftRplLjRgkWp3BnDTAp6YO6wMhCbp2FxZYR4Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijWAIw8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijWAIw8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B56AC4CEF0;
	Sun,  7 Sep 2025 20:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275918;
	bh=HJUJOrljI1ejWc20DbZsrlB7tSGXq8bhabQiPqrVzQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijWAIw8y7Yb7Mtoi8T/+IR+LVm5+lzaC6OYUK4wAvAor71KnsyRMQl4D9xlt8ENZh
	 wcGkT6umLBeGUBusBe6NGxUqaejkKwhjVgRy22eemeL///OdLnWaN3+c+riJTFVKcc
	 JRURVa9owdwafJaH3uwwf/iZphmQGfo7dOn5y80g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/45] net: thunder_bgx: decrement cleanup index before use
Date: Sun,  7 Sep 2025 21:57:59 +0200
Message-ID: <20250907195601.347917375@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e3acbdbc80993..8f4f831237cd2 100644
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



