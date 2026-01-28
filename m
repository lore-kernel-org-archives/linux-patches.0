Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBCA356A37;
	Wed, 28 Jan 2026 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614082; cv=none; b=QWtLaOywXxmElCAE6m3623VZgV8O7MhCMKaFjPV2MOIeppGXoro2rYtlNe+EHy8J0nINV6OL2smC8KQYNN2LxWacN36jTCkDA3XT+aBz5TMkrqNBOWEcLISoLk9brf94axElJuejaEsE5+LN7AVY6ooInvx9uFa0KaAF7jLqOGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614082; c=relaxed/simple;
	bh=616oOGs6FtdMqQ4MP3FiPeaGQbafvTzy36RiE1NWmcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOcoVTSghG5CuC3HRqCE/rZN23dfwT4DCsBaqLFQgkJdzo80iZxIwPwftBQ0aGrVBlngVI6jQvAl4tNef8q94P3RQV9nz4zMBx+wcvdhGXWb96DcZpzUghrbpQi9RTTaTro+KayMpOdKWPxQoq/0uk1zqaQyzlHNWytvOi0E3dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRyS07d1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRyS07d1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EB8C16AAE;
	Wed, 28 Jan 2026 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614082;
	bh=616oOGs6FtdMqQ4MP3FiPeaGQbafvTzy36RiE1NWmcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRyS07d1cOcCiHs/DrvchLXEfiYq63ysvxHCSCCQeNiwcljnVkWLfRISPoQrPOnF+
	 BGTkAk+SaNMZyslU4EuExG0GIJt1/BN3tQhih6kU72+yhWVUAQX+qeDHz+MTz3ml7t
	 RHOoVdCMJ7PzekbI1ZF5Epzh4eDlXjOEvTBOQ+r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.6 003/254] Revert "gfs2: Fix use of bio_chain"
Date: Wed, 28 Jan 2026 16:19:39 +0100
Message-ID: <20260128145344.826528915@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -492,7 +492,7 @@ static struct bio *gfs2_chain_bio(struct
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(prev, new);
+	bio_chain(new, prev);
 	submit_bio(prev);
 	return new;
 }


