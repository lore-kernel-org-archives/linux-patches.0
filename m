Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EB2303A07;
	Tue, 31 Mar 2026 17:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976849; cv=none; b=p2AlCWmjkRI91GwtRn75T6cz0cAr7VcXALTYkexNAVEatykmG8wXRmhAjVllwdzqplWUPq4G1fXeBLp5461Y5Pipr2+suOoh49dPEfuIOHn6S6qgo2w8BikvGur+Mf105lk+qRF00xaheBSCgAmoJqyVfg7T+/6tyY/Yh8YaO4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976849; c=relaxed/simple;
	bh=Ps+MzcUDJscKmNNmgzAZAzw1jdLBmHq4BH3PPhoQA+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u31O0Kzb1nBiInZo7B+ZkLstM6PVZgvgffbaBlm1fPd1XgLIvY5gcx9rYRe7lfCNEIaq9o7BXJRscNZsh2JMhd60ruHBH8WBuxUTjFr+DpuHpSP1Gx/OsD1mVvsDqcmOmT9l1XB+4ux056rsd3c6TwVBJLbhdR6XEc4n5CXG5WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEHbUilq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEHbUilq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0F8C19423;
	Tue, 31 Mar 2026 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976849;
	bh=Ps+MzcUDJscKmNNmgzAZAzw1jdLBmHq4BH3PPhoQA+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEHbUilqFeQLMSkMJOFVFB4A1jPaddlwBxEZvfJ0K2aLmP6eyuEO/z0zcRyOUKutD
	 QNXR768ETcz2wDF04enLr/cfwlGYPLlcHVRqrDWPlr1NEjwXZLKKx5NYz83yof/h7X
	 PvIS7fOruuIuW1EfcR7n7/dz6e4AALFpcIGUtomw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 252/309] xfs: dont irele after failing to iget in xfs_attri_recover_work
Date: Tue, 31 Mar 2026 18:22:35 +0200
Message-ID: <20260331161802.848785912@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

commit 70685c291ef82269180758130394ecdc4496b52c upstream.

xlog_recovery_iget* never set @ip to a valid pointer if they return
an error, so this irele will walk off a dangling pointer.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -656,7 +656,6 @@ xfs_attri_recover_work(
 		break;
 	}
 	if (error) {
-		xfs_irele(ip);
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
 				sizeof(*attrp));
 		return ERR_PTR(-EFSCORRUPTED);


