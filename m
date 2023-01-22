Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AFD2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE02C433EF;
	Sun, 22 Jan 2023 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400989;
	bh=7wV5KL/QoMV80fwP6x/kDuM6XjkKEe3S2CNeV9M6C24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRYCp9L8JRR4NYoirvDSbIqjkXtXTHIIwZGthykk6ZMJ0e8AzU74gcRehOBJppQdO
	 Ocv8OcHE2sE0mreTs2Zc7qID1h/2cq3fx5INs1T1N0Lcua91K9Hj0MUOhtKz8yMZSZ
	 osP9xaF/KSebTNvCLx6BrcuNdinioN35JTcZ8p6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 038/193] nommu: fix do_munmap() error path
Date: Sun, 22 Jan 2023 16:02:47 +0100
Message-Id: <20230122150248.148116267@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam Howlett <liam.howlett@oracle.com>

commit 80be727ec87225797771a39f3e6801baf291faaf upstream.

When removing a VMA from the tree fails due to no memory, do not free the
VMA since a reference still exists.

Link: https://lkml.kernel.org/r/20230109205708.956103-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/nommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index c8252f01d5db..844af5be7640 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1509,7 +1509,8 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list
 erase_whole_vma:
 	if (delete_vma_from_mm(vma))
 		ret = -ENOMEM;
-	delete_vma(mm, vma);
+	else
+		delete_vma(mm, vma);
 	return ret;
 }
 
-- 
2.39.1



