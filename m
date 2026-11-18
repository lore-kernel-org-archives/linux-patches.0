Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055004;
	b=a11PViiaVuxOj4MpU7xcZG4x2mbjr0c16xi30hpL5iHdlB2neVmHi4h/mjMtWPmK/R6P
	 BSRAMUj/pDGJtQGRokUPqqrQs19CWAvwm8Qj21f7ySXpRtuIyt9z2Wx4GIz2Mpm16xkPW
	 pUHAQocTnp1yfvVO8GgYM8wkwitkiico0adeG/7KOzB7TmAIjH+UCX01j/SO214rtqDFJ
	 HEp8UQBK2gcDsctZtHyREUPTwXrjbmHAv7C3j082piVT+Pdm+aNihOfHjO/748OrLYD9a
	 A5HiwanHE4wFvtjLLxB4r8bdM3AGSjumBhJE/IJA118z3oJJjyhfcx76d7FulKDfHVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VbuBt26DUs9NgImoSTjMeBh9Zj8GvPljMYfYXzVETEQ=;
	b=rSYitXgPu7V8g0jjIPPM+ZRhsXQU5kb/ymKeRMOcTNDK0AcHK8fzvXkQdXMX/YhlshT4
	 46FEm9VkcvqtkqsQwEfxdl9VuGOCquMJbeRszIqdaLAL/yhw3MMo7IAZQQpZaRWTOJg3v
	 5TC5PdQhljaLzkopwfhYFSbzR9VT6yqmdXKe70IYAblT/WyIYZBZLc1m5Am7YkHIM9SxT
	 tUFfwc0qyp2GVR//p9nmkB9a84mH5rhqQaKItQ+4njeS7xUTiMFN0F0uCLkaG+GwdkLqO
	 ioro72s+0yaPk2JwRcJAiZiTIjPgnz32IWjlmP9Nome+/zDMXmDea4LT96OwHipY/aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fm9KRGUO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF90606A31C;
	Thu, 19 Nov 2026 02:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fm9KRGUO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139351F000C4;
	Thu, 19 Nov 2026 02:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055003;
	bh=VbuBt26DUs9NgImoSTjMeBh9Zj8GvPljMYfYXzVETEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fm9KRGUOW1KoxGAJiEAs/R8dwseoyyuGFK51KitjIknkAwp8t4sc9uFq6ScUr0lqW
	 N5BV3UJYA4zms7yXlcWaMe8ej6zfPbYNSqZRJL1fPUI1up5i+kislSJyXPlmQHpfJN
	 b4gf+llGDEN91vMrjzs8ECLKof4yFWKPh7x9A0K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1477/2214] gfs2: Fix journaled truncate range end offset
Date: Wed, 18 Nov 2026 15:52:33 +0100
Message-ID: <20261118150110.249082780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit a52652efd8f985397e87669f505af83f06e335cf ]

The third argument to truncate_pagecache_range() is the inclusive end
offset, but gfs2_journaled_truncate_range() passes the length of each
chunk. A hole punch at an offset larger than its length therefore
creates an inverted range.

Commit 86066914edff ("gfs2: Don't support fallocate on jdata files")
disables fallocate for jdata files.  Otherwise, the following bug
could occur:

The MM truncation path then underflows the unsigned partial-folio
length and passes an oversized range to folio_zero_range(), triggering
a BUG. Pass the last byte of the chunk so page-cache invalidation
covers the intended range.

Fixes: 4e56a6411fbc ("gfs2: Implement fallocate(FALLOC_FL_PUNCH_HOLE)")
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1e95d777f6737..9a68e9b7c2ce5 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2387,7 +2387,7 @@ static int gfs2_journaled_truncate_range(struct inode *inode, loff_t offset,
 		if (offs && chunk > PAGE_SIZE)
 			chunk = offs + ((chunk - offs) & PAGE_MASK);
 
-		truncate_pagecache_range(inode, offset, chunk);
+		truncate_pagecache_range(inode, offset, offset + chunk - 1);
 		offset += chunk;
 		length -= chunk;
 
-- 
2.53.0



