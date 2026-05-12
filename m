Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C324DA539;
	Tue, 12 May 2026 17:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608020; cv=none; b=fjgmVwb4AKIjytnDoEEHLV9U1DmsYSSgKtGHVBn0pcclYJK6bEjtFiCqNxYnSeQN5fhwuxS4j/2rYpFxe/wSYTeckiRUmop8LSnj6uqhn10hBSYl99JVNU7DAekhZXi6Fc8ZydjYd6bUb7fQHm29fnRydx/X2KojMr9gCCwtMBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608020; c=relaxed/simple;
	bh=vgFpYDqR2j3eAYCr6cd4UymNXVP3TWcz3RnjR0+jq2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9zIiAUBQe6+zqaaJuVB47EpfJHCA9AAsvKm/T19n5zu/lFzvcl7Aks8dgKAi4fI/1YIvehIG3jfzeZX/nEowcIcNXNtRWoljXAOy/bGPeKHujB8k3sQVJ95s6KUeEfnmHakKTg5+lAChIrzv4nUK2D32H02i9CH4CPaDicMHXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OppACM6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OppACM6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51041C2BCB0;
	Tue, 12 May 2026 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608019;
	bh=vgFpYDqR2j3eAYCr6cd4UymNXVP3TWcz3RnjR0+jq2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OppACM6WSN0hgDM7nJ2t9XSnJW4I7qelNadO2xh2ux8SODNDPrucICc4sxAK+Mcuy
	 1dFikA10jSXfZmX7LV41hwHiu6cXmgYnGRbiwjCPueOtd3icuz0gBr1UNvNTTVMNck
	 YQf+hW4O5GSC4ayFP7SJ+svz1+cF4GAhpe//GRBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	David Gow <davidgow@google.com>,
	David Howells <dhowells@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 125/206] lib/scatterlist: fix length calculations in extract_kvec_to_sg
Date: Tue, 12 May 2026 19:39:37 +0200
Message-ID: <20260512173935.504445714@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 07b7d66e65d9cfe6b9c2c34aa22cfcaac37a5c45 upstream.

Patch series "Fix bugs in extract_iter_to_sg()", v3.

Fix bugs in the kvec and user variants of extract_iter_to_sg.  This series
is growing due to useful remarks made by sashiko.dev.

The main bugs are:
- The length for an sglist entry when extracting from
  a kvec can exceed the number of bytes in the page. This
  is obviously not intended.
- When extracting a user buffer the sglist is temporarily
  used as a scratch buffer for extracted page pointers.
  If the sglist already contains some elements this scratch
  buffer could overlap with existing entries in the sglist.

The series adds test cases to the kunit_iov_iter test that demonstrate all
of these bugs.  Additionally, there is a memory leak fix for the test
itself.

The bugs were orignally introduced into kernel v6.3 where the function
lived in fs/netfs/iterator.c.  It was later moved to lib/scatterlist.c in
v6.5.  Thus the actual fix is only marked for backports to v6.5+.


This patch (of 5):

When extracting from a kvec to a scatterlist, do not cross page
boundaries.  The required length was already calculated but not used as
intended.

Adjust the copied length if the loop runs out of sglist entries without
extracting everything.

While there, return immediately from extract_iter_to_sg if there are no
sglist entries at all.

A subsequent commit will add kunit test cases that demonstrate that the
patch is necessary.

Link: https://lkml.kernel.org/r/20260326214905.818170-1-lk@c--e.de
Link: https://lkml.kernel.org/r/20260326214905.818170-2-lk@c--e.de
Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a scatterlist")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Gow <davidgow@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>	[v6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/scatterlist.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1242,7 +1242,7 @@ static ssize_t extract_kvec_to_sg(struct
 			else
 				page = virt_to_page((void *)kaddr);
 
-			sg_set_page(sg, page, len, off);
+			sg_set_page(sg, page, seg, off);
 			sgtable->nents++;
 			sg++;
 			sg_max--;
@@ -1251,6 +1251,7 @@ static ssize_t extract_kvec_to_sg(struct
 			kaddr += PAGE_SIZE;
 			off = 0;
 		} while (len > 0 && sg_max > 0);
+		ret -= len;
 
 		if (maxsize <= 0 || sg_max == 0)
 			break;
@@ -1404,7 +1405,7 @@ ssize_t extract_iter_to_sg(struct iov_it
 			   struct sg_table *sgtable, unsigned int sg_max,
 			   iov_iter_extraction_t extraction_flags)
 {
-	if (maxsize == 0)
+	if (maxsize == 0 || sg_max == 0)
 		return 0;
 
 	switch (iov_iter_type(iter)) {


