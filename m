Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E865172F8;
	Wed, 30 Sep 2026 17:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787976; cv=none; b=Ox3WBL/0VOlCPgP3/OdL40gdD5mXUlZpCCFhdd+mqEkAIL7snoVb61OoIa6yIlwowezDrGDx9hrRKk8SwigAcQckKMevDICbou1H/xdwy4mMECG+9WTzd18XOZZLqf/eY5uMbenAUZo6ciPN11KtL75MuMrKOYVwVoFe9NjfGfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787976; c=relaxed/simple;
	bh=qSSDZqpl7/XiYCyUbjld+Q2LMORNeK+1f+2ZyhU+wYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuRZHvn8rNfynMyhHnuJEyRww9hHfg+upIa/Zgb0DwSAAUUebdmuiUC7R+mPtSCIgADhkwLiazTaz7VkvlYBqj+dG8BF7QmDjgM5f8L8JrruHJ2Nu9/GaeYqtD3iTiOCVWydqvnPou+Q7EWOUKvbqjqaYoKAwfEby2RADL910Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2j4xevnd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j4xevnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC0D1F000FF;
	Wed, 30 Sep 2026 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787975;
	bh=t2cEOWJwe2pRcN56YUxY/pNCrwENoH3qq2MjE93M4j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2j4xevndWN/fZziJ0m3/N1SRCXCJ7OyQxX9hNGAEJH/V2Kqtc0qzhWORh+lGKpCE1
	 EBXhAdeW6HH3dsCttgh2CRPa5xbZ90iM19T89CEosbqgxGIk8VzmxgtPTaRyMOZtZO
	 7wCin0GehYxIG3ZT3CTDC8nd+d+/MYyPiYKWl5v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 420/457] xfs: check padding field in xfs_ioc_commit_range
Date: Wed, 30 Sep 2026 17:28:45 +0200
Message-ID: <20260930152355.050996868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


