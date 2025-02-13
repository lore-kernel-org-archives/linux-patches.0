Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A79D15689A;
	Thu, 13 Feb 2025 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458212; cv=none; b=ovN3+O+4mdnocGaQ8q4hzsiZhA7TRE5Dx5HRCRfWkbx/3zuHOcbfL/OAzWUi+cipFJb7V6m3DcQy58Mmum4A/N+lQtCWOgy067wYjzeJawiLI+YyejJGWE8/qrDcSq+G8DMHeq9zWphTQH/qgbNnC/FwBKw4YXIVwiECaF1UBIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458212; c=relaxed/simple;
	bh=HKpG4hj7bA9Pk0YdYouRxe08V8JRfrh2tTA9WLTASVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snIGMx+AQUo31zc+IMd8b49pQjMk8PR5h/3TkiRk+UME72zZdGXpjTGw+DhHJvNhoim1y+Z7zL+hvWwXTZWJFC9yW4Jpg4DVag3Bq2fMF2TajX5+KGfHTdYphEk17t+Ic2gqUvpHo9xnOpoALAmPn7L7LSqRzQyKusUiXtxV1bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNe7dpSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNe7dpSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FB1C4CED1;
	Thu, 13 Feb 2025 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458211;
	bh=HKpG4hj7bA9Pk0YdYouRxe08V8JRfrh2tTA9WLTASVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNe7dpSqUEQuSsOA9OWpFWJjaNVzM88+7/6B2hlNJ6vkOjt+eoKks5Kq+s7Ru2HMQ
	 j+L55HeEr+D8QQvk3zy0l/A2/GUQTFvTNj1UDMNezw4oafvarJbnbClYeef3HiPrQP
	 /b/6j9NzhCV9vBVMx8XDodAJ3kXdiLffxWuuz+UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 302/422] xfs: Add error handling for xfs_reflink_cancel_cow_range
Date: Thu, 13 Feb 2025 15:27:31 +0100
Message-ID: <20250213142448.195590661@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1392,8 +1392,11 @@ xfs_inactive(
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


