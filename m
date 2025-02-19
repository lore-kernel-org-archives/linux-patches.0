Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A711D88DB;
	Wed, 19 Feb 2025 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957086; cv=none; b=ffCgYbi5HJF3HvfES2yqVPZpPUU8VVukKKP7TZHonuJzQfDdXNLfu5yyGP+kwDPhqonpQxKm3zT731Ir33p/RSK0BObLrzogJ6husWGx0DPHiGhR9XYUj3SaPQhvcVAjLgM/Ea+OFbBho6ypdn2yS4rniUmdvBDVOj4bzeJLyzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957086; c=relaxed/simple;
	bh=35QcJ2G61Gf6CiF3cdTfMpRQiTEWu+QXCYP6dUilEYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5vpB098mB2Ko6FNL+vGkmlwL+vcpNRFjUq94eQLn3RCB9XkZRkELEz6izvmw4/56qgB0BDq1pL4wiYi35eu49ivgEXvhQejNdOTI9ooI9b1EjMFjZmfkMPn8U8Q20Mx6KpWx8wJ+Fo3jrmmnQuTehIQepi/8ihpryujnQsiJ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17a+HK0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17a+HK0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E39C4CED1;
	Wed, 19 Feb 2025 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957086;
	bh=35QcJ2G61Gf6CiF3cdTfMpRQiTEWu+QXCYP6dUilEYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17a+HK0ODizyEhBqfTYDBQYgPbEZ1HquKoXyEghuoBtINaNWKOIyUr0pPTKpG4CJG
	 vEzGuY728G8t2d+dVN9P5gRYrNXOy65TRcAiC2VBZBU8DnxdZlQfL6ieVix+HFVaXn
	 hL9rvJblJyqxvoJYSFKC5BiTvfFTBuVZtrrr7F/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 403/578] xfs: Add error handling for xfs_reflink_cancel_cow_range
Date: Wed, 19 Feb 2025 09:26:47 +0100
Message-ID: <20250219082708.878793423@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 26b63bee2f6e711c5a169997fd126fddcfb90848 upstream.

In xfs_inactive(), xfs_reflink_cancel_cow_range() is called
without error handling, risking unnoticed failures and
inconsistent behavior compared to other parts of the code.

Fix this issue by adding an error handling for the
xfs_reflink_cancel_cow_range(), improving code robustness.

Fixes: 6231848c3aa5 ("xfs: check for cow blocks before trying to clear them")
Cc: stable@vger.kernel.org # v4.17
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1726,8 +1726,11 @@ xfs_inactive(
 		goto out;
 
 	/* Try to clean out the cow blocks if there are any. */
-	if (xfs_inode_has_cow_data(ip))
-		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+	if (xfs_inode_has_cow_data(ip)) {
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+		if (error)
+			goto out;
+	}
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*


