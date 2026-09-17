Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22C75A9862;
	Thu, 17 Sep 2026 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658818; cv=none; b=ccfbtXSDwtpmLR9vHuvqnQL/kZdox7CRo6ZX4qkeKDCjnyFuoq6YzXj2eOu+Q/m3AayDan4TmCqpr/Ff1CpJklam24G+kvfh6ePnwZTn1qiTrVycgGkFMwH5LrSQQbs0B1b681iRxE0rkL1IERreHVnPpbhs/EEPSDvkMXyfVVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658818; c=relaxed/simple;
	bh=Amd4CmtqqQFyjeZx9jC3cNhtDFijevXvytLp487gN2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4dGoXNQDE4Ra36U4+pu2btnu2v/+zJ6onPHnhmnqSzZjxhSLi4Ga6kKFUardQrgIukPFgGPeGaqR1XluaLUXCy2saoGZm1aDSSw55oTJ12kc2lLKVTw38eU7RQP1RSY+jz22wsie3exGdLhsiqp1Xb7cif9eibeRNReaby+f4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSHWmEY5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSHWmEY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D251F0089B;
	Thu, 17 Sep 2026 15:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658805;
	bh=swb5/zrGwZS3IRespGr32iZruXUMIXsN6Ln7m0+7Vto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSHWmEY5H5CS9QF75p6p1OgrlR3exrTIU+mWLwv24pcc8S8xj0o1ghOB7EOmISECW
	 9/ZoCoiUlLDOAJuCuCYqhSyk3iw5izAstUK3BKuiieqlIxIoOag8KiVFoSMmFaMIY3
	 AXOMGl37Niyh8nXGVRT7CWsyFCf4Ennt4YBUoTD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 046/733] ntfs: treat any nonzero dio zero-range return as an error
Date: Thu, 17 Sep 2026 16:05:54 +0100
Message-ID: <20260917151351.918266755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 607a9478833db656e7ceac8e9e382fa4acfde545 ]

ntfs_dio_zero_range() returns either 0 or a negative errno from
blkdev_issue_zeroout(); it never returns a positive value.  The
zeroing failure check in ntfs_attr_fallocate() therefore never fired,
so a failed zeroing operation was silently ignored: the loop kept
going, the newly allocated clusters were folded into initialized_size
and the write could succeed leaving stale on-disk data.

Treat any nonzero return as an error and abort the allocation.

Fixes: 495e90fa33482 ("ntfs: update attrib operations")
Assisted-by: atomcode:deepseek-v4-flash
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 950fc1b727cb2..9e41ba97e024d 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5693,7 +5693,7 @@ int ntfs_attr_fallocate(struct ntfs_inode *ni, loff_t start, loff_t byte_len, bo
 								  lcn << vol->cluster_size_bits,
 								  alloc_cnt <<
 								  vol->cluster_size_bits);
-					if (err > 0)
+					if (err)
 						goto out;
 				}
 
-- 
2.53.0



