Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B1651C348;
	Wed, 30 Sep 2026 18:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792884; cv=none; b=p1pw5Elirvsnf1xRKb2+K+BulvLT7S/oBWuC/AINhyo9IsVnjAZ1PLTgbs+j5eCsNrNNMaCtMA13j920BiSuey9d8NILafWhIb3+kqxnZhZ/tt4q2TjO3he6Jy2CeLZDLpR8+6SQlVSPBzHJOo4hMSbDGA0d7VJ0fGligR9Bq5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792884; c=relaxed/simple;
	bh=F95ocP8+1D+szBKhXe2EE2bf/cPscMC14M/RgHpZHZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+xjpyoVuLwS+1+LYRKuUuDlthvrBm00P+zWtqXpEl5Qy9iUmMQ3/jsvCV36ZbJGZyhjnOlsH4qIi3+aESA2CEoGgjhf5tsX9dzkscjN11rpdYtX3nVH0ghSPf41nPKPVNpBYPhl8dW73hkbDAJl3d0hVlyIGkD/yesWd5WRUek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOES5DSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOES5DSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE911F000FF;
	Wed, 30 Sep 2026 18:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792883;
	bh=uJOuyEsWparVZXiYXjld7yk9bBrGDJKKQcYEOaKS5Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOES5DSEQIpIHodBNieUAMcUZUEs/ULclcOeU8XJBjbNLPvjfWeJtLwZWmcZ7vBiM
	 bmC/sc5WU/IK/MVQEyHEpqaiLG4PzyWRJ3HD+BNSyUSqmXO28uRqvozD5V4InmGVA0
	 NlDHAVO1I7cHJdJZcVyWCfB1zkazc2bMcU80KX3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/395] eth: fbnic: Fix payload page pool error cleanup
Date: Wed, 30 Sep 2026 17:25:20 +0200
Message-ID: <20260930152341.892973062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@kernel.org>

[ Upstream commit 8e0b235bd918d06f54ba8fddd2c3ddc36ca59c15 ]

The payload page pool pointer contains an error pointer when its
allocation fails. The cleanup path passes that error pointer to
page_pool_destroy() instead of destroying the header page pool. This
can dereference the error pointer and leave the header page pool
allocated.

Destroy the header page pool instead.

Fixes: 8a11010fdd96 ("eth: fbnic: allocate unreadable page pool for the payloads")
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Link: https://lore.kernel.org/netdev/178915061000.219967.7726187707862333281@kernel.org/
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915104917.3978113-1-bjorn@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 0ea861ff40f56..7fc7761e8f2e0 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1620,7 +1620,7 @@ fbnic_alloc_qt_page_pools(struct fbnic_net *fbn, struct fbnic_q_triad *qt,
 	return 0;
 
 err_destroy_sub0:
-	page_pool_destroy(pp);
+	page_pool_destroy(qt->sub0.page_pool);
 	return PTR_ERR(pp);
 }
 
-- 
2.53.0



