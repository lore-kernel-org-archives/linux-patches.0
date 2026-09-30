Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C4521231;
	Wed, 30 Sep 2026 18:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793671; cv=none; b=Y+TPyjbOJyASG55tHC1eWIzUA9JsuMjUm7DdGk76kN5fTZ7CuolGlLO0pqb9dYCa86gIxwP7EB3fwKs6Gg0swsc/J0mEyd/ozcsjwdsxZ7hHmWu6BlyPBKehXkrNhqeVFL7Jo0kiJXTWmveqirW40M9yIpV2uXfM0FZixKfV2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793671; c=relaxed/simple;
	bh=EXKAzC3CwyeiKHIfQvFk0zuqckLkdPN8M9AFfYppuhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkK/bH+T0fcVTkMdJNPsbf4B2DsS7rr/7Mkzru/BlZneupvp0CXATMg7N955EgNOVxRSjRmlvDoxhBM+Cc7vzvOJAOFqrUfdjh5b+MifyiVCARAcFgDovwGN8vh5TUJnv47H24xugfalsjRVxwbv+EbpWf8yoAuMJv4qAjZENe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oti9PZp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oti9PZp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCF71F000FF;
	Wed, 30 Sep 2026 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793670;
	bh=sl1fzz5WOoTo9g460pP8FvEpypFXQPXxQ1Gwax6LL7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oti9PZp2c/f9hcKJGaNYmDOA6DBek9Z7I1MR3wUOzIoPVe5aMZO+uoXF1NQViVk5n
	 XF52CQYj480A+7Tuz6O+NSqryjcgpt6s4wm2YMdvfvOjNDGiqeYYYwe5Mb4hem45ng
	 fgkFP9UYXAMt/EU/X+FV3g9wTY6zueqHNKCWrNBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 337/395] xfs: check padding field in xfs_ioc_commit_range
Date: Wed, 30 Sep 2026 17:29:59 +0200
Message-ID: <20260930152347.978587740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 3083ba8dde765a9ab2337f3db68d00724a6b1202 upstream.

LOLLM points out that we don't check the ioctl padding field here, so
let's do that.  I don't think there are many users yet since exchrange
requires a new feature flag, so it's a good time to try to plug this
hole.

Cc: stable@vger.kernel.org # v6.12
Fixes: 398597c3ef7fb1 ("xfs: introduce new file range commit ioctls")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_exchrange.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -902,7 +902,7 @@ xfs_ioc_commit_range(
 
 	if (copy_from_user(&args, argp, sizeof(args)))
 		return -EFAULT;
-	if (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS)
+	if (args.pad || (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS))
 		return -EINVAL;
 	if (kern_f->magic != XCR_FRESH_MAGIC)
 		return -EBUSY;


