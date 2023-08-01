Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A833C200A5
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C2BC433C8;
	Tue,  1 Aug 2023 09:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882685;
	bh=XhABoXK3MZ6InE6Cx6RgE3IE/CjlFi6FEWpFYGZGxb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpZSuTi+HmApGffraDKet8fFx8ZNSpV5GINf27ShVLZHPD+9OxkSD+gwPGZloi2fq
	 SCLNQiGaSJfThR6Pv2XTCeUYxbeAKbgBG5mmKRhGI41Dp0rlizvVfPZU/kn5RcQRnA
	 LzOQzUcp+XMHMONmqD/MNPdZPupOG2qbiHLTwrc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 194/228] proc/vmcore: fix signedness bug in read_from_oldmem()
Date: Tue,  1 Aug 2023 11:20:52 +0200
Message-ID: <20230801091929.874597014@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 641db40f3afe7998011bfabc726dba3e698f8196 upstream.

The bug is the error handling:

	if (tmp < nr_bytes) {

"tmp" can hold negative error codes but because "nr_bytes" is type size_t
the negative error codes are treated as very high positive values
(success).  Fix this by changing "nr_bytes" to type ssize_t.  The
"nr_bytes" variable is used to store values between 1 and PAGE_SIZE and
they can fit in ssize_t without any issue.

Link: https://lkml.kernel.org/r/b55f7eed-1c65-4adc-95d1-6c7c65a54a6e@moroto.mountain
Fixes: 5d8de293c224 ("vmcore: convert copy_oldmem_page() to take an iov_iter")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -132,7 +132,7 @@ ssize_t read_from_oldmem(struct iov_iter
 			 u64 *ppos, bool encrypted)
 {
 	unsigned long pfn, offset;
-	size_t nr_bytes;
+	ssize_t nr_bytes;
 	ssize_t read = 0, tmp;
 	int idx;
 


