Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670D51DDCE;
	Tue, 16 Jul 2024 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145746; cv=none; b=Ogs7905NnPsZXnn7C64lVKLpDM+dlCRiV4BI5sOyh+PxDZ32O4bMizhbke3IsWDPtdvKUn4OTtdYsxiniX/la+Mb77f3Z1R7zNyHAU409+ZwL5yc3iWGI5N4pMp865aU3Hwhg2E+iqQCaTH/sCGuTf7tx0n/zyJ235ZcbY2uRkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145746; c=relaxed/simple;
	bh=2el+USjeO3Xnl2rpNQCG/krI1QfrK3DC1SpCnpT5CJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACek3eSy438p+l3AK4X/dBiQ9Yw6Ak0TokUP4AmWsbT2BA8/tqyNGAIhZ9R1VlvjBXM7uX1+Bse9ADvhWsw6wPwkXTjwm7jLwgU1Teav1G6KsIDKCHEB9uXGflvBPjuqHBLg9kVlp5iZOyV2td8Qp72A3EQ5u2Def1+GBJV9Q+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAO30HjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAO30HjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E090AC116B1;
	Tue, 16 Jul 2024 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145746;
	bh=2el+USjeO3Xnl2rpNQCG/krI1QfrK3DC1SpCnpT5CJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAO30HjMByBApOaDzJALFbTFglXEn9FLs9Ow1xgLUQ4i5cyj7Fpc0HbrcxVxskKfh
	 0UfndzXT70ZRKGakCwtU/uPRi0vqexFXXAsoxM454ucGKifAAjvtX3UqnPYZvMQ0rL
	 +nPT39gkYwayk2iB6Aqhjq8CMMlUDJTSCnUk3pc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yskelg@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 071/121] s390/mm: Add NULL pointer check to crst_table_free() base_crst_free()
Date: Tue, 16 Jul 2024 17:32:13 +0200
Message-ID: <20240716152754.059927114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit b5efb63acf7bddaf20eacfcac654c25c446eabe8 upstream.

crst_table_free() used to work with NULL pointers before the conversion
to ptdescs.  Since crst_table_free() can be called with a NULL pointer
(error handling in crst_table_upgrade() add an explicit check.

Also add the same check to base_crst_free() for consistency reasons.

In real life this should not happen, since order two GFP_KERNEL
allocations will not fail, unless FAIL_PAGE_ALLOC is enabled and used.

Reported-by: Yunseong Kim <yskelg@gmail.com>
Fixes: 6326c26c1514 ("s390: convert various pgalloc functions to use ptdescs")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pgalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -53,6 +53,8 @@ unsigned long *crst_table_alloc(struct m
 
 void crst_table_free(struct mm_struct *mm, unsigned long *table)
 {
+	if (!table)
+		return;
 	pagetable_free(virt_to_ptdesc(table));
 }
 
@@ -500,6 +502,8 @@ static unsigned long *base_crst_alloc(un
 
 static void base_crst_free(unsigned long *table)
 {
+	if (!table)
+		return;
 	pagetable_free(virt_to_ptdesc(table));
 }
 


