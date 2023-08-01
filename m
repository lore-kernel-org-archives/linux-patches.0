Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6C91F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF9C433C7;
	Tue,  1 Aug 2023 09:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881745;
	bh=0CIPnZUJovU51Gqd30qHdxrNUi1xVl7XJ+Ub+cRCCnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qS52JrTAmc4v5tXDIadv97ckm4e5INjfFueCmxrwtx4AQkj6Ob7dAV3NeacKWeT0a
	 AFdyoGjGd+2v1kFQSvpeWnQGcaHRxbQtLK0efBiVzhAYrX+RtdIHRCao1X8QnYOU0u
	 NJXri5+5HMY79O6ncJZ1HwE4ZEHnFZeVv9sl9arM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/155] KVM: s390: pv: fix index value of replaced ASCE
Date: Tue,  1 Aug 2023 11:18:34 +0200
Message-ID: <20230801091910.268021277@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit c2fceb59bbda16468bda82b002383bff59de89ab ]

The index field of the struct page corresponding to a guest ASCE should
be 0. When replacing the ASCE in s390_replace_asce(), the index of the
new ASCE should also be set to 0.

Having the wrong index might lead to the wrong addresses being passed
around when notifying pte invalidations, and eventually to validity
intercepts (VM crash) if the prefix gets unmapped and the notifier gets
called with the wrong address.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Fixes: faa2f72cb356 ("KVM: s390: pv: leak the topmost page table when destroy fails")
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20230705111937.33472-3-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index ff40bf92db43a..a2c872de29a66 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2791,6 +2791,7 @@ int s390_replace_asce(struct gmap *gmap)
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
+	page->index = 0;
 	table = page_to_virt(page);
 	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
 
-- 
2.39.2



