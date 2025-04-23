Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384B27EC6C;
	Wed, 23 Apr 2025 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420058; cv=none; b=ktvcNAc7Sqqik2AVpDtnZyeVLFYDdjAwxI0U/kOw8QKD1Aind1+oaoKlGV4fSxpiIVOtxeB1W4SFAPeliN3CPohehPGCMK+RSaAJzLtQh2JBYhyYZIzr0BSyx6px0imquuuIrCqqIBwaSuBLIMajxja4fIi6mzzNhApZF9WFZJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420058; c=relaxed/simple;
	bh=nG8mpdekUKMYw34I6Oze0umIpbzZgvA9MKJbcvwqO5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBBqz56GXGfh1rnro82ZdqirJkhrrtOWLsNsrSbbWkC3EmRKN4R0oda72yex9jehByrA3ms1QtzDvGH5jeG7iCxAQ5PsnHxyB49LODHxvhZ9xmxC41nroxbWKWzPgShX4ig1n8EWF8ATG0SccOCE9gTexr6K7kt5whZY+JVTlx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3Ha1WvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3Ha1WvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996A9C4CEE2;
	Wed, 23 Apr 2025 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420058;
	bh=nG8mpdekUKMYw34I6Oze0umIpbzZgvA9MKJbcvwqO5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3Ha1WvSwWLeOgsWcTvX4pzwaLUbtwyvQK43C6XCoASOLquL3Es/dfUq9YOPot1Fu
	 MGo1A2cRdhib1q+obcT8R1xFFJF1ogJui1SWrIYU1PBec8O5g4jxnzTQo7adNV/IoB
	 s83IKNzi2EcWbLWtJLxLglRf+WMNje0a6LanztI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/393] net: libwx: handle page_pool_dev_alloc_pages error
Date: Wed, 23 Apr 2025 16:38:43 +0200
Message-ID: <20250423142644.393262011@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c37500aa06379..c019fe964ecea 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -311,7 +311,8 @@ static bool wx_alloc_mapped_page(struct wx_ring *rx_ring,
 		return true;
 
 	page = page_pool_dev_alloc_pages(rx_ring->page_pool);
-	WARN_ON(!page);
+	if (unlikely(!page))
+		return false;
 	dma = page_pool_get_dma_addr(page);
 
 	bi->page_dma = dma;
-- 
2.39.5



