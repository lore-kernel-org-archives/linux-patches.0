Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0852A6AFAE;
	Thu, 13 Jun 2024 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281604; cv=none; b=mKH+pyT5qK8ao3TD4y6lrwKs1h19BxPSWyRRHRJHuWzEqr6tRQK2kK8V3dx7IaLBCKeBbRJKHGixaGnFGdBmj9p1b16VY0nUUaComSjyCA68nQVf06VIOdgYX+FSg4VZjMu9XHmH3VB/a50sQGhKERiGKiH72GGTI9h6hQE1t5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281604; c=relaxed/simple;
	bh=y3XcSOAap6qiTrWACR9AOn6rpgQLVSYE1Wfn1vQUL10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFCkgrQT0/HaZati72/68a5l7ZgOTBLYTU9VfoHHxewY5ZtuZ55906P5N35Y+PbcZYifdg2xYSlnPlS2ilSiINtSoz4gTad7dWmui6kWt1Z0cWocYSybvXUXlrislaZyn8XBNuMwg8S8Icnp7KWDyLShImNqmRXkjrwM9uAD/hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+8fzsiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+8fzsiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8580EC2BBFC;
	Thu, 13 Jun 2024 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281603;
	bh=y3XcSOAap6qiTrWACR9AOn6rpgQLVSYE1Wfn1vQUL10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+8fzsiEdne2SebyhbauXLzxLohqWR1ccmvav/9IPSsTeF7R7fumzmtt4K/GIfXeT
	 NstjJYz+B16OnZCJAjZvbIBnftopAMZGLV0IPbElwjaH+7mPGZUnAsm68hBspKyD5s
	 yDTrwfqLSJFrafSFzQC5vJARRse0Z7z3o4ufCdYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 312/317] nfs: fix undefined behavior in nfs_block_bits()
Date: Thu, 13 Jun 2024 13:35:30 +0200
Message-ID: <20240613113259.622709064@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 3c0a2e0b0ae661457c8505fecc7be5501aa7a715 upstream.

Shifting *signed int* typed constant 1 left by 31 bits causes undefined
behavior. Specify the correct *unsigned long* type by using 1UL instead.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -660,9 +660,9 @@ unsigned long nfs_block_bits(unsigned lo
 	if ((bsize & (bsize - 1)) || nrbitsp) {
 		unsigned char	nrbits;
 
-		for (nrbits = 31; nrbits && !(bsize & (1 << nrbits)); nrbits--)
+		for (nrbits = 31; nrbits && !(bsize & (1UL << nrbits)); nrbits--)
 			;
-		bsize = 1 << nrbits;
+		bsize = 1UL << nrbits;
 		if (nrbitsp)
 			*nrbitsp = nrbits;
 	}


