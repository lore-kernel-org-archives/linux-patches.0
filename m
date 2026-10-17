Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D505D3C4B8D;
	Sat, 17 Oct 2026 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260803; cv=none; b=Hp4krcutOaGa5tUWhBNdNonMfHYnfcyoZXhPDLO39JrpoGprvjoSqCsojvmPQCG4HcaNHYwXlCMpkXuWZx63GzFLEtRo7eZB7c7Z/iM9ZKr6m9kc0yVzir0n3GdXJDPYLznFiLU+S02u4dUfQfmz5WfLoB70yVvqAUJn8SVx1x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260803; c=relaxed/simple;
	bh=LiuRATBUfrnF97td4F6fl/qR2XCjwKG8lsHAlphTiDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMOsFJnb8/y4g/ytIQSegh8k/y8VcVu7KK3etVRYSq28rY9QqAj0dnFrdK7KSSZrXIv3+kL5DwW+eoYqaULSOQ2KbS1ikGZ7w3f7TSraciOFwPyvXNF4gvC2uMkQGlcqzGtcbNprKqZ/sfXRagAROYdYW+IRKJVImGkAki4Rsuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gy9LKc4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gy9LKc4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3921F000C4;
	Sat, 17 Oct 2026 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260802;
	bh=mPTEQZ0UktbzDq9SuIyvZ/0HagRpbxbMXVurefv2MR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gy9LKc4YAmkdlNlsU4e1vZIo+pYSNfVZC9lAFshBsUus9+avylA1gbXDuEI9vL4kw
	 /ByjQFQSB8xTu7ehcM7QqUPJdcBfiFHQvxUag867t4Faa3/KI3aPesGF/fKpRVwZPX
	 41R1Qe/09WlaxTf2Up1U2gy2+iaHesmpaUQvHO0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1664/1674] Revert "mm/filemap: avoid buffered read/write race to read inconsistent data"
Date: Sat, 17 Oct 2026 18:05:36 +0200
Message-ID: <20261017160513.780732388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4b944f8ef99641d5af287c7d9df91d20ef5d3e88 ]

This reverts commit e2c27b803bb6 ("mm/filemap: avoid buffered read/write
race to read inconsistent data"). After making the i_size_read/write
helpers be smp_load_acquire/store_release(), it is already guaranteed that
changes to page contents are visible before we see increased inode size,
so the extra smp_rmb() in filemap_read() can be removed.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240124142857.4146716-3-libaokun1@huawei.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5a340cad44ed4..7ad7202ad65ed 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2704,15 +2704,6 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			goto put_folios;
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
-		/*
-		 * Pairs with a barrier in
-		 * block_write_end()->mark_buffer_dirty() or other page
-		 * dirtying routines like iomap_write_end() to ensure
-		 * changes to page contents are visible before we see
-		 * increased inode size.
-		 */
-		smp_rmb();
-
 		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
-- 
2.53.0



