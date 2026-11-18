Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039642;
	b=imo78Z8mT78LtKLQCUdz4uyD4TURleDtWeMLgOS6A+NtBSWTfLTajzYPVtxBv7OVtKaJ
	 5DMCxYp39z2OxWaw+FoqsEF7UsEmhAhTa2FM46uS/DzF/Yhlx6vyZrTjdf21PLILRk1Fp
	 HJxQpTGDVn8qxByohBDSgXQu5KJVuUCKZu5/DJeamCzwJ4UhE6Ci6v2O0SDwjXgFlH6ft
	 rbadCeEjr5tB1XQktUF94HSkdPAjw3WmC4dN2hAVSmbjhc5b+WwPETjFvGcnEeaiVhoLG
	 Lx/zaulpaKFjncD7mhPzbfKJgV6YbzJL40pOj1iwPXbCtU0qnk0DqV2/NCAPAOp6MEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6yjrGOI5sY/zpzANJXwZFToeuZupdxKfVWV6fT7gMHY=;
	b=HRoTljJT+4XPJ3NOEQfB2PJ0nxLllc72TZkNVANguXaiKj3LQhB6XFb7wdf23jjA3upH
	 GdI3WvIhZRprU4lF5putjE++qHZeTEVafB2fLjIi3A4VxMqEG+CE0nXei72GGtO7CuSix
	 dPKllQEfhVF70XK6jSWCA3MkuDjLti5X/xD9kcXwTDzMP4NfVgNNaupUI0uqVsyGVb8w2
	 C7D6UdhN5Gh1/Cu5yuk0YvrkMpZZxLYBUXYi3RKDnLECs4UAyzMdYDjSq5xodJX55UOx/
	 nmZHDqcuClMu09pClszd8eH2rxERR/EXKKXiiDSy39PedxbXHlhsJr5yrZBKJ0gYNzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lg+DOJhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9BB606A325;
	Wed, 18 Nov 2026 22:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lg+DOJhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D231F000C4;
	Wed, 18 Nov 2026 22:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039642;
	bh=6yjrGOI5sY/zpzANJXwZFToeuZupdxKfVWV6fT7gMHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lg+DOJhRrOs2FK8OUusOPGjFBBBUNidsg+a4Un8UdR+V3ILIR2Fx/S/oRmpyEh53U
	 miQiUixTgVzemdupFk4zAPq15E5FUyAnIosDqqAGJxi58mCoaSWnYUNb+ACGC92pWn
	 eIoCihG+w4K0OvhAxGbDi7BUtH3waMcSMGE5Pv7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2172/3318] gfs2: Fix journaled truncate range end offset
Date: Wed, 18 Nov 2026 15:46:34 +0100
Message-ID: <20261118150427.144993996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 06825903ea1dc..55d4c659bef3d 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2409,7 +2409,7 @@ static int gfs2_journaled_truncate_range(struct inode *inode, loff_t offset,
 		if (offs && chunk > PAGE_SIZE)
 			chunk = offs + ((chunk - offs) & PAGE_MASK);
 
-		truncate_pagecache_range(inode, offset, chunk);
+		truncate_pagecache_range(inode, offset, offset + chunk - 1);
 		offset += chunk;
 		length -= chunk;
 
-- 
2.53.0



