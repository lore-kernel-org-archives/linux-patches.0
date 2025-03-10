Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CB2D023;
	Mon, 10 Mar 2025 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629465; cv=none; b=ghh/oww4DpThejSTs5xO0O07BBy/vAuVhX6oCTi7SV8z8E/YfTvxlnvBACcveAM/gmZ7lnjnasSma2QYuUrZeC8xg03oJm0XGfaNryK7I9bCcMqQOTfbpY1rbzAfNSa6jx9+PpMFdArIinRVQd7cQrGZ8mziQDXA6YmFLUkSijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629465; c=relaxed/simple;
	bh=qQ0/BxGQpypXz2eFhbnk+2HOECKoy6sZn36U9zgETOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7n5GxZAMoNLtK9n29K+HJPLZEJwVt/FPuLTY+UD/boioTPKkwKrr3yzFUtvkC9uNFaZI57u6MetMWzsFAWUJmJ9uQil7uB/6CfVhpKYuegIv6PUMWyHF3FJdtwJ8DtVYfZBL6f2YOgj1+29wxZ7ArX6Pnwn4FpR3fI48IzFebE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oxha4U+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oxha4U+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29458C4CEE5;
	Mon, 10 Mar 2025 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629464;
	bh=qQ0/BxGQpypXz2eFhbnk+2HOECKoy6sZn36U9zgETOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oxha4U+bhJJ7+KfElqbGjEk27J04QHBIRpv4wGxM0lVQ+trGrj2Gx8Iw2suwDYDU2
	 6xfimHvRuswo4BKqDO5FJAVweyZxroX2w0w5AUakmQSonhJObSJsr76VJcDKnGGel7
	 vJiHz2poyQEy7UDqOpAeVcbs88kpEf0FdsekrADI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 303/620] xfs: Add error handling for xfs_reflink_cancel_cow_range
Date: Mon, 10 Mar 2025 18:02:29 +0100
Message-ID: <20250310170557.580924341@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1748,8 +1748,11 @@ xfs_inactive(
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


