Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EC1352F86;
	Tue, 12 May 2026 18:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609447; cv=none; b=MsLVIZGj1G3sR2F0fQ2ji8omwR/TM7pisKqlri6ef2yRVwlcXsp+pHYJZvUPkJGbW2B61tEdWUwaFutqLnrYEDupbdD2L37yjzdBMCH6QtllqqRM3yxZ4vD6Myerz3mMJpqQKyNCq8QO8/jHcD1E/MBKvXC2pwp1GojEE2qDNy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609447; c=relaxed/simple;
	bh=hjuI7dW9M07DUSQuJuSbc6XovRgEWBy/gGPBTWxI4G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngGAk3Zy8dEBhSnWbmCgOyqYxpJCoKwJrwDfcmbJ9Y6l4xth+RJJ07IqsRpcwrjI5Ch3ERIf1jz9cJU1K+81sBVFKmVG729jdRQlO0e3dYcVaIj1gaWY8BCi4YTR0uEHjsCuSqgIfYFtGlr2F+cgu/HxgmZIvpW3D/nfHfoXaFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjOu436V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjOu436V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FF0C2BCB0;
	Tue, 12 May 2026 18:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609447;
	bh=hjuI7dW9M07DUSQuJuSbc6XovRgEWBy/gGPBTWxI4G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjOu436VL/8ELCSEqfe+i0/iqM3x87Uu+0Z5J0SNZmsH/S8DKL3R+KtOUdE7Mayjd
	 swmn68q8IMeIoJJRuE1zynzHN1UfhdQEya/F85vCNJZvjY8DyXX+lLrQB8dg5lseAp
	 iXH1/zvZCNaYPIPqdJlYa1c68IeQn7mKWpdH+5aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	David Howells <dhowells@redhat.com>,
	David Gow <davidgow@google.com>,
	Kees Cook <kees@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 197/307] lib/scatterlist: fix temp buffer in extract_user_to_sg()
Date: Tue, 12 May 2026 19:39:52 +0200
Message-ID: <20260512173944.277441958@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 118cf3f55975352ac357fb194405031458186819 upstream.

Instead of allocating a temporary buffer for extracted user pages
extract_user_to_sg() uses the end of the to be filled scatterlist as a
temporary buffer.

Fix the calculation of the start address if the scatterlist already
contains elements.  The unused space starts at sgtable->sgl +
sgtable->nents not directly at sgtable->nents and the temporary buffer is
placed at the end of this unused space.

A subsequent commit will add kunit test cases that demonstrate that the
patch is necessary.

Pointed out by sashiko.dev on a previous iteration of this series.

Link: https://lkml.kernel.org/r/20260326214905.818170-3-lk@c--e.de
Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a scatterlist")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>	[v6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/scatterlist.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1123,8 +1123,7 @@ static ssize_t extract_user_to_sg(struct
 	size_t len, off;
 
 	/* We decant the page list into the tail of the scatterlist */
-	pages = (void *)sgtable->sgl +
-		array_size(sg_max, sizeof(struct scatterlist));
+	pages = (void *)sg + array_size(sg_max, sizeof(struct scatterlist));
 	pages -= sg_max;
 
 	do {


