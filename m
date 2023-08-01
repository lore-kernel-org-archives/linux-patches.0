Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA50200A7
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655F8C433C8;
	Tue,  1 Aug 2023 09:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883435;
	bh=y8FFAVh19zJZ36FULwbJ6DbCmIu0WfH/xbQKBTfjtHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utFzV6tPe1Y8NNPGpAYLYv4iQ8vSk0jgl/Yv3XSlvp1Ksz4Yy165DxFmmYg4lU8Yy
	 J6MqaqapsL8+efAPazx7D2PCexq5pl97xkGPayIu2jCinOKE/hWKihlj3aK13wxx/k
	 MfOkjsTt6Fx/F9Eux8GPDprjEef2fCorvrIxCnfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 236/239] mm/memory-failure: fix hardware poison check in unpoison_memory()
Date: Tue,  1 Aug 2023 11:21:40 +0200
Message-ID: <20230801091934.549900939@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

commit 6c54312f9689fbe27c70db5d42eebd29d04b672e upstream.

It was pointed out[1] that using folio_test_hwpoison() is wrong as we need
to check the indiviual page that has poison.  folio_test_hwpoison() only
checks the head page so go back to using PageHWPoison().

User-visible effects include existing hwpoison-inject tests possibly
failing as unpoisoning a single subpage could lead to unpoisoning an
entire folio.  Memory unpoisoning could also not work as expected as
the function will break early due to only checking the head page and
not the actually poisoned subpage.

[1]: https://lore.kernel.org/lkml/ZLIbZygG7LqSI9xe@casper.infradead.org/

Link: https://lkml.kernel.org/r/20230717181812.167757-1-sidhartha.kumar@oracle.com
Fixes: a6fddef49eef ("mm/memory-failure: convert unpoison_memory() to folios")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2490,7 +2490,7 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (!folio_test_hwpoison(folio)) {
+	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;


