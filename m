Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DEC46C4CC;
	Wed, 30 Sep 2026 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789648; cv=none; b=L8jLTzwgJQK0wO8tvtI3IN5MvSak9CDM5nH+klqUUaBauKQwndZbIfuyQUOe5SzOrk/ft0e7gguR0C/m3J8E5ACyyPXnr25YAl059oosA6d/b9koq+pL1lPYryHTmr6sHjdZTJfWK4atE8wtSKhIj/8uh2o9728U34VmfyxpdpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789648; c=relaxed/simple;
	bh=qzABmI1ei4zjcpitQ8mSvJ2mGaN3ok6N1k4LNBgoKpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAay37/2e5ddOyBrDC3nxHyCyj1tuQxYkweiGZdhvUcrJDq1vwDajhwxr6fJd9sIoe0CMBRiLr1+7KKXy791kW0+L5m/VX0JWvIYKZH3bwXiAhpHeEce0KvYcZ5KACbXCB22PCpBs4nkKJH6hJc8dkL4AaJdGP/dqYGhaR0CrR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhN+cxO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhN+cxO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9CA1F00898;
	Wed, 30 Sep 2026 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789647;
	bh=CJGRzC1lqjU3+79maToa7q0ZZW11RYlWJDhKxRSJlMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhN+cxO53ZNKmWUO1OA8CoB1uAcPKZtgiwrTdHHTzWtgcoCl0mX6RxS+j5hRnY5cg
	 o3AJS6+bBzJJ2sY+CfJntGIhE8UiF9EZ8Ve1bqGBl1XtguZyBB35ZTLwr7oIjHTIPI
	 1Zu7rRjx+YtZgwcnxMgB9HSQF0lPqFDb1AJ7rnN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 552/877] xfs: dont call xfs_exchange_range_finish for a dry run
Date: Wed, 30 Sep 2026 17:24:23 +0200
Message-ID: <20260930152426.553621934@linuxfoundation.org>
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

commit 8fc18580ec17f90beac4c933fbe4c74dcd3b7f36 upstream.

LOLLM noticed that we strip file privileges and whatnot even for a dry
run.  We also shouldn't flush dirty data to disk or trim COW staging
events for a dry run.  Neither of those behaviors are allowed by the
manpage, so fix that by exiting early on DRY_RUN in various functions.

Cc: stable@vger.kernel.org # v6.10
Fixes: 42672471f938cd ("xfs: bind together the front and back ends of the file range exchange code")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_exchrange.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -630,6 +630,9 @@ xfs_exchrange_prep(
 	if (error)
 		return error;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	trace_xfs_exchrange_flush(fxr, ip1, ip2);
 
 	/* Flush the relevant ranges of both files. */
@@ -706,9 +709,11 @@ xfs_exchrange_contents(
 	 * other file write would do.  This may involve turning on support for
 	 * logged xattrs if either file has security capabilities.
 	 */
-	error = xfs_exchange_range_finish(fxr);
-	if (error)
-		goto out_unlock;
+	if (!(fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)) {
+		error = xfs_exchange_range_finish(fxr);
+		if (error)
+			goto out_unlock;
+	}
 
 out_unlock:
 	xfs_iunlock2_io_mmap(ip1, ip2);


