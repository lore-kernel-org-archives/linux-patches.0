Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B3C134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44481C433C0;
	Mon, 26 Jun 2023 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803486;
	bh=4PWE3ykqn1k155ujOMaKHhbDukWjMc3TmCyTFuvqZAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2UkbdGbHRr1VbJYAfzMxoyYhrG/q0uHYp9n/4wNQqobzZdhf4I2MPO/vYFyXjkb5
	 K6geR8sNFJHJoBUWoRHGNvNDczArZwhTNp3hg7hGaIS5TrgXO44dg//6qtzRIb6WBT
	 h4XEpiQdP+u7i0QGLpHsx1YNAR4xIdH07rqdDC+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 060/199] mm/mprotect: fix do_mprotect_pkey() limit check
Date: Mon, 26 Jun 2023 20:09:26 +0200
Message-ID: <20230626180808.206508926@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 77795f900e2a07c1cbedc375789aefb43843b6c2 upstream.

The return of do_mprotect_pkey() can still be incorrectly returned as
success if there is a gap that spans to or beyond the end address passed
in.  Update the check to ensure that the end address has indeed been seen.

Link: https://lore.kernel.org/all/CABi2SkXjN+5iFoBhxk71t3cmunTk-s=rB4T7qo0UQRh17s49PQ@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230606182912.586576-1-Liam.Howlett@oracle.com
Fixes: 82f951340f25 ("mm/mprotect: fix do_mprotect_pkey() return on error")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -838,7 +838,7 @@ static int do_mprotect_pkey(unsigned lon
 	}
 	tlb_finish_mmu(&tlb);
 
-	if (!error && vma_iter_end(&vmi) < end)
+	if (!error && tmp < end)
 		error = -ENOMEM;
 
 out:


