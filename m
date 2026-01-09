Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F80D31ED6D;
	Fri,  9 Jan 2026 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962194; cv=none; b=jmTxcVtW+IJeJAuPazWh+jjJg5eBOf1z0v2BzBA3CTy/3M3h386Wvj5WJHVtW4J03zvy0X+/9ySiIBOM0EZ1erq2SUysZR9WaXiSCls9yuIssMM2F0V0M4jfvcLKWHg3GWMa8fzyIwd6QFJKnJH4/i8/0UdqYcS1z0KKGVOlEOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962194; c=relaxed/simple;
	bh=hL3bPCzV8bvMRPAMV72KooCExY8khqxDKnICPR3jook=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNpPELvaK2QGx6jAbm40w+XPQjot+Vx74z4YMW17nWylAfvNsgvgqw2m3p4DGy/xv+kKOla78HZGm2XDWb+mlo+Q+N2C/xz1qt1JHvGfzJFBBtzlYO1Ia0BhL82JsAxgfMh+Jo3d880K+gbftsG+BJDdHUVi4BSqRvUfdDsqJNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCnh+kUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCnh+kUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D77DC4CEF1;
	Fri,  9 Jan 2026 12:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962194;
	bh=hL3bPCzV8bvMRPAMV72KooCExY8khqxDKnICPR3jook=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCnh+kUkLy+4IUKfEP2F1fPzFb2smN92+f+PP5bS4YeI47OYkK28+epHWqNIOOhXr
	 UA04gR7xoMJFVfzXGx1DsMMj6c92fMCVr+Hche5uCLQrt7pZeCsin7EXzi+osxco7b
	 bEr6RAdB2sSZhbUhfg3doNeDNiVyVV6X36b70UoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 247/634] gfs2: Fix use of bio_chain
Date: Fri,  9 Jan 2026 12:38:45 +0100
Message-ID: <20260109112126.835795326@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]

In gfs2_chain_bio(), the call to bio_chain() has its arguments swapped.
The result is leaked bios and incorrect synchronization (only the last
bio will actually be waited for).  This code is only used during mount
and filesystem thaw, so the bug normally won't be noticeable.

Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 1902413d5d123..5656851b9240a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -491,7 +491,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
+	bio_chain(prev, new);
 	submit_bio(prev);
 	return new;
 }
-- 
2.51.0



