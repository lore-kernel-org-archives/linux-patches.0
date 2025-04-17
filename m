Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A28425742B;
	Thu, 17 Apr 2025 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912493; cv=none; b=URvlCnmuEi9Ve5w2Xa1Mv5A45Dcw9I6If+9MvgBcS+yqWD63aGMcx1w1xyjBYI1Qk55tgzDViLhx/rJXVHPtWC/I4xfTa4sF0lqYSC8SPtIFNLyKXKrCZNH/RDN6BIGaUut24jHa2w2BJUW3y16lgVM+Zqt1ldwZ8Ux+XtftX2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912493; c=relaxed/simple;
	bh=3/ZGrlZqMt4duMNBZGQzEVEgww66dopYg3aCPHIFN0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AElSDw9aLOEKXk/AUohTcGmhPBNh2YUIvKehO1fSS4HRl87UfGFYcDU4GlPbAWe7zY5XH5uMeXEMtY8bAqcgAaeO/Q071fgkm20RdxLt1m0UvEHDJMDo71izUSU/Apn8PtV3bAxlANE6H4jDgH1fOGgXmxIp+zASXXEGmi6HD2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTxd9r+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTxd9r+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1810C4CEE4;
	Thu, 17 Apr 2025 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912493;
	bh=3/ZGrlZqMt4duMNBZGQzEVEgww66dopYg3aCPHIFN0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTxd9r+/9zlZimfqBzFugiPBnL6q8izzbs3ncSURGFG3cZvYJNaLC4Kxq7fMvw5ot
	 DcQXMzegaLjHi3e21SVIMVQ5SvuWkiSOUCz3HWFLrkBNnyJilwdRTcuWXHrLDfAvXQ
	 u0x3cEOcJ5iF9EJDcx6/RewX9Z2w+ptxP9gQv8JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 028/449] net: libwx: handle page_pool_dev_alloc_pages error
Date: Thu, 17 Apr 2025 19:45:16 +0200
Message-ID: <20250417175119.131985200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 7f1ff1b38a7c8b872382b796023419d87d78c47e ]

page_pool_dev_alloc_pages could return NULL. There was a WARN_ON(!page)
but it would still proceed to use the NULL pointer and then crash.

This is similar to commit 001ba0902046
("net: fec: handle page_pool_dev_alloc_pages error").

This is found by our static analysis tool KNighter.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: 3c47e8ae113a ("net: libwx: Support to receive packets in NAPI")
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20250407184952.2111299-1-chenyuan0y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 497abf2723a5e..43b89509d0fe5 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -309,7 +309,8 @@ static bool wx_alloc_mapped_page(struct wx_ring *rx_ring,
 		return true;
 
 	page = page_pool_dev_alloc_pages(rx_ring->page_pool);
-	WARN_ON(!page);
+	if (unlikely(!page))
+		return false;
 	dma = page_pool_get_dma_addr(page);
 
 	bi->page_dma = dma;
-- 
2.39.5



