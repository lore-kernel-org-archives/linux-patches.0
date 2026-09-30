Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15250355819;
	Wed, 30 Sep 2026 17:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789776; cv=none; b=gq0T6f2L3k4GwTQnVdE/Ps2vHoG/SxViaCXr+KYxTqoZVulDpqI1AzVeSSkU34vP2an4ZIg5Yk4+lEeXOiOiJC1u2CydTw5gqgIC3JKcxde7kTeeZsM9mOLTYURfDio7P94TqVCnssEkoVDOTZTzpI9i41qPpomkXCjprn8p24Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789776; c=relaxed/simple;
	bh=GmMTVgZmnTbgHlSZfiaNqwp2+YfRrflrMEsnUOxSU+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb2/Mx1jTmlzysfzf5lHK0psqRG3/ylFWzLA02cXtsXOztP6q/kfq1fxwjLJW2uQ186Oae+o27z4ZtzJo6++AoUxJbO5z6jCYw+Cy+aPvNPznpas/zS5zBn6qZbofMiQmyXsYh4lakAWdrElWSRUi2ymR+Q/zgImp7jUUzoianE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbfnZn7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbfnZn7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9771F000FF;
	Wed, 30 Sep 2026 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789775;
	bh=QbTcPpUMx/08aIHPB6kmffUxyhmEjP4qgWqao+k145g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbfnZn7HQffhDrJLTebMifplqTs19JQsq/n90m8ADC+iUecql7lYBWqp/deDC7GUw
	 oY6r0mymd5rwxylfrTkut2gs0yGcjO0XxBOVlF0yd0l9AwBqMVtfc9GBW76DQQgmro
	 N+EbhOpjjlAx0aNiFKzCXO1n1MZpofgtsT6vY194=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 551/877] xfs: check padding field in xfs_ioc_commit_range
Date: Wed, 30 Sep 2026 17:24:22 +0200
Message-ID: <20260930152426.531430424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -905,7 +905,7 @@ xfs_ioc_commit_range(
 
 	if (copy_from_user(&args, argp, sizeof(args)))
 		return -EFAULT;
-	if (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS)
+	if (args.pad || (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS))
 		return -EINVAL;
 	if (kern_f->magic != XCR_FRESH_MAGIC)
 		return -EBUSY;


