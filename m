Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA9D2ED843;
	Tue, 25 Aug 2026 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666492; cv=none; b=YLO4YZbeQGT3NrhlykaTAIqB7DvV9tb81xAdQlKtzSP+f4E+zu+5er4R7+RtzK7dNUUrVf7RZQsNy4bYf6UL2wInTp+Q9lR7iegZ2xAEXSQZ4EuJt+eCb3bbUQFUkH4A5hhkzBq9yTZ9mnNNFk/qEV9ySqNKLWMSXloWBLvR980=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666492; c=relaxed/simple;
	bh=vSPVtfTu9N0u26BPoFwRbAK/PaYyhoATgJnDJc0+ja8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCIiW4IhMhS792cav0pROW9PlxuenVb6Qmlq1dQdN690YAJhih3vshxqiGI3yAYQMJPyROWvgKMhh7q5cetO1G9MvJpNA3XgKyBGOO2Pxx5TiYqzuy2AMj7IAj3gQWgrQ6rw/37JYPtP0M4fFvoecgpwc8DvlNSq0dTFqt4dLGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlE+v/NK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlE+v/NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5453C1F00A3A;
	Tue, 25 Aug 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666490;
	bh=mySLWQeQn8WbsBC8AA45SWHkphdGL/dICwvnCpCt4C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlE+v/NKY1wXaXxBDTnoPjG9acLSG8otv+Gm5/Gdgtpv+ClnQRdYV90C74jAo1kQ+
	 OiLsaeAISyDvQTe48XCkvF/2+1OESeGKWjh6ngTs+jNUvmx8W71CLoRpZs/XRd3Z1T
	 k5ifU8P0XLz9v+MnRMjYCTCMrlPb27xgMTtPQbqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/57] xfs: fix ilock leak on error in xfs_dq_get_next_id
Date: Tue, 25 Aug 2026 15:26:47 +0200
Message-ID: <20260825132542.287798287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 63320a0f70f66f311f4bccff3af0719c2119f46c ]

xfs_dq_get_next_id() takes the quota inode ILOCK before calling
xfs_iread_extents().  If xfs_iread_extents() fails, the function returns
immediately without releasing the lock, leaking the quota inode ILOCK.
This can leave the quota inode locked and cause subsequent quota
operations to hang.

Fix this by jumping to a common unlock path on error instead of returning
directly.

Fixes: bda250dbaf39f ("xfs: rewrite xfs_dq_get_next_id using xfs_iext_lookup_extent")
Cc: stable@vger.kernel.org # v4.12
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -745,7 +745,7 @@ xfs_dq_get_next_id(
 	if (!(quotip->i_df.if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
 		if (error)
-			return error;
+			goto out_unlock;
 	}
 
 	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
@@ -757,6 +757,7 @@ xfs_dq_get_next_id(
 		error = -ENOENT;
 	}
 
+out_unlock:
 	xfs_iunlock(quotip, lock_flags);
 
 	return error;


