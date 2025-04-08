Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065D1269820;
	Tue,  8 Apr 2025 12:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114600; cv=none; b=iQAmh3V+ezA4dl05bwnanaw1clsbhJy3BMMfJNcUktdJqgeA7KBJli53IrFAL6HncVQMIRX0CWDYGslSdsctjyAhrgSdqivJ8ksCY9l1pHvVzAA33lDp9wph/JS1Ktdl1N5/5WRiIODeVJ996Zn8kvw/Hi8gDiRAgpgEkii7qEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114600; c=relaxed/simple;
	bh=QGTYLowFX/YFrO4EsvXExkVmpeOxPxgpx7W5xqnGDx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHvMFcd2ud8BqYi9xnQts3yk9uVAjQbSk1gA2hyZJvaQQK0SmDtxbCjBFKuAzeJtn3rA82Seobx5A4UHsPtI8jyAI9RAqS1GnVoip0Ev2UJBi4y0FQ3zrXTwT3OgRxWYSTFoF4IKy3wLqbYl6Op36CYhuDUtwC1sgDL9kvY2OrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjjsfTdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjjsfTdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2602AC4CEE7;
	Tue,  8 Apr 2025 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114599;
	bh=QGTYLowFX/YFrO4EsvXExkVmpeOxPxgpx7W5xqnGDx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjjsfTdx0E5CLng8zinKSsg5fVfpcit2gVk7MPh4ie+xVz0FQmJ40jsHuXrbS2R/e
	 QRRxB0Dv11QyT20zCQ+Cl1jG6GQIiijrurnTFH4EN84qoV0irFO0F0r5j1WJjS0rQm
	 rka9in/4XfRSErVIGgiEzjiHV5ilSygkVHINqHFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 164/499] RDMA/erdma: Prevent use-after-free in erdma_accept_newconn()
Date: Tue,  8 Apr 2025 12:46:16 +0200
Message-ID: <20250408104855.269955352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 83437689249e6a17b25e27712fbee292e42e7855 ]

After the erdma_cep_put(new_cep) being called, new_cep will be freed,
and the following dereference will cause a UAF problem. Fix this issue.

Fixes: 920d93eac8b9 ("RDMA/erdma: Add connection management (CM) support")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
index 771059a8eb7d7..e349e8d2fb50a 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -705,7 +705,6 @@ static void erdma_accept_newconn(struct erdma_cep *cep)
 		erdma_cancel_mpatimer(new_cep);
 
 		erdma_cep_put(new_cep);
-		new_cep->sock = NULL;
 	}
 
 	if (new_s) {
-- 
2.39.5



