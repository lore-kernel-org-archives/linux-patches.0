Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755DB6FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB0CC433C8;
	Sun, 17 Sep 2023 20:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982929;
	bh=0ixHSCuY9Bc03F57kY1emfPNryKRzhcZJD9hpZ+Sul0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMwcEOTV+MAlzDkHyBs1QTEiUBeHNdke43+w33C65f1ufL6/1DiLYb+I/ACUYRJIN
	 GSRVDCxxfSjwPQNNEDmxSg7zD1o9ej9j9jpRoJ8Jgfc7vGbrcxl1996K9ddSZEomZn
	 Z/Eav/DchnNHhyAmLkXKvaYpOJu0F3TxULxJl8V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Xiaoke Wang <xkernel.wang@foxmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 394/511] lib/test_meminit: allocate pages up to order MAX_ORDER
Date: Sun, 17 Sep 2023 21:13:41 +0200
Message-ID: <20230917191123.308366539@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Donnellan <ajd@linux.ibm.com>

commit efb78fa86e95832b78ca0ba60f3706788a818938 upstream.

test_pages() tests the page allocator by calling alloc_pages() with
different orders up to order 10.

However, different architectures and platforms support different maximum
contiguous allocation sizes.  The default maximum allocation order
(MAX_ORDER) is 10, but architectures can use CONFIG_ARCH_FORCE_MAX_ORDER
to override this.  On platforms where this is less than 10, test_meminit()
will blow up with a WARN().  This is expected, so let's not do that.

Replace the hardcoded "10" with the MAX_ORDER macro so that we test
allocations up to the expected platform limit.

Link: https://lkml.kernel.org/r/20230714015238.47931-1-ajd@linux.ibm.com
Fixes: 5015a300a522 ("lib: introduce test_meminit module")
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Xiaoke Wang <xkernel.wang@foxmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_meminit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -86,7 +86,7 @@ static int __init test_pages(int *total_
 	int failures = 0, num_tests = 0;
 	int i;
 
-	for (i = 0; i < 10; i++)
+	for (i = 0; i <= MAX_ORDER; i++)
 		num_tests += do_alloc_pages_order(i, &failures);
 
 	REPORT_FAILURES_IN_FN();


