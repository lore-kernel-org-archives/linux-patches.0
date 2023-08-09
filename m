Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DED017AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864DBC433C7;
	Wed,  9 Aug 2023 11:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580827;
	bh=+YHGZxQgg61/xHxTJN/+H46POv+pk6eYgfwC39rHZ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LQRQpPFkVWwbTTb+j0LLvcgfTquOjjk6GAH1mcDu5ee65lHwzZL56NNexJD5KbqQ
	 xN4iq9CJ9rksz0JS5uve6hhX+8d5qSmg7WScuFdGJ0H33O2RqNkU+6Vl56jkWCWzhy
	 Z0rjPV9xd8NAZkYMgSKdh46XNWYUewagbEVL2Aro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/201] KVM: s390: pv: fix index value of replaced ASCE
Date: Wed,  9 Aug 2023 12:40:03 +0200
Message-ID: <20230809103643.846759196@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 03e561608eed4..b5a60fbb96644 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2786,6 +2786,7 @@ int s390_replace_asce(struct gmap *gmap)
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
+	page->index = 0;
 	table = page_to_virt(page);
 	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
 
-- 
2.39.2



