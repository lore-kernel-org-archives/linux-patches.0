Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB53218E91;
	Tue,  6 Jan 2026 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719799; cv=none; b=aQ+nca0oMP+mWFaiiLJbaS+CETU6ArpDsaF5Rk93jsi0I0JUEr0LsZ1pY4XgjEJdqpQzPaqF7Wf/YkPrBvk9OnEkEaVA8tvxOinKjw2rTn1ZCz5vzMZDrwGR2RfWHKNzoiPGDPuKkL1Lp/g8oWkytQtVWVwlx57VqgUVLzmhjL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719799; c=relaxed/simple;
	bh=sePkuSWsgNl7b+zc9rNcZ0ibzSd5t1zkRyHMGMW/tkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTicrz3YKL/2kXVeUqDwVvBoJnKtZEYA+2TrQpcQmLbOXDLJrmfRJZCfGZQWlFZKumqp08zVcXAwWg6rxqzoc9GA09qzDhKKE/8jfbXh5Q2IDanEroFaJwJFHwi01l9qftwO14ZuOs7I7u6lQ5PjJ22pysxQFsvow8WHWjZ290Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RByc79T9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RByc79T9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD17C116C6;
	Tue,  6 Jan 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719799;
	bh=sePkuSWsgNl7b+zc9rNcZ0ibzSd5t1zkRyHMGMW/tkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RByc79T9dNFJvLoIiXNHhEPUwGcwEQy/y+4hrAD3HLb0HD08xCRPu6AL+uzJqAE2S
	 TGKghCtgIChtpD5YAWlZUNgee6/fiEZu6MUDx+vIObfvJkAnS4EygXF3tyKUBpAdNR
	 bWzIxQ14I6Kgf120i6QxFO0eJGhHNvRoTdte4FMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/567] gfs2: Fix use of bio_chain
Date: Tue,  6 Jan 2026 17:57:06 +0100
Message-ID: <20260106170452.971320055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index 314ec2a70167f..2e92b606d19e0 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -485,7 +485,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
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



