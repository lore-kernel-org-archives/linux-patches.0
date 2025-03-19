Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8F61DEFE3;
	Wed, 19 Mar 2025 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394991; cv=none; b=VbJ7A5cGWbQqTOaO7zuOlpcENHRouP5J93u9SRs82Y9xaJRpEAyZ/cUN6QiMSk9hD9cIpMqvIoffHhsgYBk24TzfbWYrYsda37jPhgYebmWUBCpm0yKmwIee+3nf8lF4CofzHf0y0dkV8BpWnLqDwUPrWzhh4vBMAk2crXTcDm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394991; c=relaxed/simple;
	bh=tSSlhxgFgJ6TMcGrg10+cJ45h7db0zbefq5x2kFtXC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXXPpbrmZAEeBM96gs6dBvEf5JzdVP/kH3FIujklqAwTJJALO1XVGKUgyjzt68dgFsoKDmfgIoBiDCmUD6jM2h0cXmNijjezb7CG6e/yeRI0iPf0ndbUBkv0MwgMdIuB+NzINXpNHIif9y/qpH2UaWWDXMBqHtlUD7KzBrzaplA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrU4QFnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrU4QFnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D13C4CEE4;
	Wed, 19 Mar 2025 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394991;
	bh=tSSlhxgFgJ6TMcGrg10+cJ45h7db0zbefq5x2kFtXC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrU4QFnScayHqGcwpSRemMNlt6xnxMnjCZmaL4ghUWHJmtVD2cBNjwOovQVIlwnpH
	 sKqro984mzwU41N8HFDpo5uy0Osh2f5EYnecMnZJbhc5DTygKokpxCKJXTrY31rwn0
	 fUHGdZTgw3TF0JAH9ay/y6YCt/IIRosZnOyLr/bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.13 197/241] dm-flakey: Fix memory corruption in optional corrupt_bio_byte feature
Date: Wed, 19 Mar 2025 07:31:07 -0700
Message-ID: <20250319143032.592494241@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 57e9417f69839cb10f7ffca684c38acd28ceb57b upstream.

Fix memory corruption due to incorrect parameter being passed to bio_init

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v6.5+
Fixes: 1d9a94389853 ("dm flakey: clone pages on write bio before corrupting them")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -426,7 +426,7 @@ static struct bio *clone_bio(struct dm_t
 	if (!clone)
 		return NULL;
 
-	bio_init(clone, fc->dev->bdev, bio->bi_inline_vecs, nr_iovecs, bio->bi_opf);
+	bio_init(clone, fc->dev->bdev, clone->bi_inline_vecs, nr_iovecs, bio->bi_opf);
 
 	clone->bi_iter.bi_sector = flakey_map_sector(ti, bio->bi_iter.bi_sector);
 	clone->bi_private = bio;


