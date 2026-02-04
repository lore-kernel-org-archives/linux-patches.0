Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514FF42188A;
	Wed,  4 Feb 2026 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217425; cv=none; b=aelHMfSOwmzLTTJgPWW9MfWzbhw3eH8b3+XYPx3/a3MU12aKsMYegajKkdDj70PmWEI5pXM6kiPOBowpYhHd0JwRGLJH5KDoK10Q241ugbBCqgmUztDEf/wv+PDFs1ckJyNBqBjONbhz7/UxJet3CHmmZU2ktWzeCrD5G8A8Eas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217425; c=relaxed/simple;
	bh=ihzJwWJILeLbFaAH5EmTRS7vaxvsn6Ma+z2nOOaSTB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRERCbnO1JHmWnSKiCGL+o1f53SaQo96SO2t6JCazlumIjUv32pBhQ98gbRY+F+BEePreyQX4+vQeWm7jwTZKmVxqoOGXPraADYZMCDrHaT+VSCNs7+HlB05JMVwJL26n3Z8padkZV1crFFvsZSCWMj5ijM1TiQ81jgr555y4gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+JzLcSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+JzLcSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43C9C4CEF7;
	Wed,  4 Feb 2026 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217425;
	bh=ihzJwWJILeLbFaAH5EmTRS7vaxvsn6Ma+z2nOOaSTB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+JzLcSo/m7pW0l6UhAmdJH+LMznJZPTlZ6JGu0p3y0g+ZqXs0Y8Lj8qRE+qRM8cU
	 rQgmxvktWZJaKLUCj/xOjk4Y4YTkt9ihuaZ0RFfjCxducnQSSX2BimY7LcP4z3cq6a
	 E9F6nImnPVr74OyW110w/6Xt6fTPhtiomr/QgFxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.1 003/280] Revert "gfs2: Fix use of bio_chain"
Date: Wed,  4 Feb 2026 15:36:17 +0100
Message-ID: <20260204143909.745657876@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

commit 469d71512d135907bf5ea0972dfab8c420f57848 upstream.

This reverts commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941.

That commit incorrectly assumed that the bio_chain() arguments were
swapped in gfs2.  However, gfs2 intentionally constructs bio chains so
that the first bio's bi_end_io callback is invoked when all bios in the
chain have completed, unlike bio chains where the last bio's callback is
invoked.

Fixes: 8a157e0a0aa5 ("gfs2: Fix use of bio_chain")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/lops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -491,7 +491,7 @@ static struct bio *gfs2_chain_bio(struct
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(prev, new);
+	bio_chain(new, prev);
 	submit_bio(prev);
 	return new;
 }


