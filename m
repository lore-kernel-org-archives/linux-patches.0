Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3586015AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C67C433C7;
	Wed,  9 Aug 2023 10:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578204;
	bh=lioioFTzveg9uOJXhwc+Y94idNQZkr/ip16TaRXGABs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYNgBmX7Sf9Ax74kDEreSZDfQbFq9aLySIGV3XOAAcGtVt+ewCZX6CY8ol6WFLS2+
	 kgPCZE3Vrx3ULwUf8j4aiqmSfaF2dnod7+FPbSQfUvJRi2w4pwZWJyZhmQ8manvoO4
	 Gj3VMKNtGE6n1j7HZEi8fg4SrcNHpi91f/tOq4uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	syzbot+353c7be4964c6253f24a@syzkaller.appspotmail.com,
	John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 143/165] mm/gup: do not return 0 from pin_user_pages_fast() for bad args
Date: Wed,  9 Aug 2023 12:41:14 +0200
Message-ID: <20230809103647.480696506@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

commit 9883c7f84053cec2826ca3c56254601b5ce9cdbe upstream.

These routines are not intended to return zero, the callers cannot do
anything sane with a 0 return.  They should return an error which means
future calls to GUP will not succeed, or they should return some non-zero
number of pinned pages which means GUP should be called again.

If start + nr_pages overflows it should return -EOVERFLOW to signal the
arguments are invalid.

Syzkaller keeps tripping on this when fuzzing GUP arguments.

Link: https://lkml.kernel.org/r/0-v1-3d5ed1f20d50+104-gup_overflow_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reported-by: syzbot+353c7be4964c6253f24a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000094fdd05faa4d3a4@google.com
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2977,7 +2977,7 @@ static int internal_get_user_pages_fast(
 	start = untagged_addr(start) & PAGE_MASK;
 	len = nr_pages << PAGE_SHIFT;
 	if (check_add_overflow(start, len, &end))
-		return 0;
+		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;
 	if (unlikely(!access_ok((void __user *)start, len)))


