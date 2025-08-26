Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C548341ABD;
	Tue, 26 Aug 2025 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217522; cv=none; b=ZyUPDF25fxyU92H2VGr//mnuoV0mE0eqCuF8m8fMCa59H//4tUiyRxiys/6G8GUcVCJFxapAgUmicLrmEgIbImGY7k6EA3qJbx58P9vwke7gOvI9PTNZmQ1lkNFVjmwITBYA93zH+4Rtq13GXtNVhBR9y/l1kpeFpqGMWAlVYIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217522; c=relaxed/simple;
	bh=ou1CpRk05wXi8bPjPZs1XGOac/+VcZc6m8T/jBFFhlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrvG9AzA1nXWbkxrez2SJZOxOR8vYLvctEijo1Zjfj9WCJz4XE9meVRtL+Rgfv4vgsjVZGvSvEM8RC5rQDnkRQikJqI7cLIibxGdbrnVEkOmpW2H96M+0Z9WGa6nLe9EdmR6YIl0ZF7r61RMaymg1KdxLJzsXBMjLxgkiUssX6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2FpaKKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2FpaKKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB9EC4CEF1;
	Tue, 26 Aug 2025 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217522;
	bh=ou1CpRk05wXi8bPjPZs1XGOac/+VcZc6m8T/jBFFhlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2FpaKKkhZxnl6ZWpvo+0qhvgw/PjE88NhX0tiQ8xnG8kX4GFd9pCp8BKzmUCGPfl
	 DiiDjbY8YyU8MYFtVdtK4BEdLH0voZi3ntVDoJtySJcTZ8a5lM0w7Hnc9VUHvdXiGI
	 edh0xsFFuZ+VpmAqHILi1rVOkpFRuanORyP2rgNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/523] pNFS/flexfiles: Avoid spurious layout returns in ff_layout_choose_ds_for_read
Date: Tue, 26 Aug 2025 13:06:17 +0200
Message-ID: <20250826110928.587889143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9bfffea3524b49d0268d01f8e7967f06c4d0a942 ]

The callers of ff_layout_choose_ds_for_read() should decide whether or
not they want to return the layout on error. Sometimes, we may just want
to retry from the beginning.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: f06bedfa62d5 ("pNFS/flexfiles: don't attempt pnfs on fatal DS errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index f8962eaec87b..a053dd05057f 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -740,16 +740,12 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
 	struct nfs4_ff_layout_segment *fls = FF_LAYOUT_LSEG(lseg);
 	struct nfs4_ff_layout_mirror *mirror;
 	struct nfs4_pnfs_ds *ds;
-	bool fail_return = false;
 	u32 idx;
 
 	/* mirrors are initially sorted by efficiency */
 	for (idx = start_idx; idx < fls->mirror_array_cnt; idx++) {
-		if (idx+1 == fls->mirror_array_cnt)
-			fail_return = !check_device;
-
 		mirror = FF_LAYOUT_COMP(lseg, idx);
-		ds = nfs4_ff_layout_prepare_ds(lseg, mirror, fail_return);
+		ds = nfs4_ff_layout_prepare_ds(lseg, mirror, false);
 		if (!ds)
 			continue;
 
-- 
2.39.5



