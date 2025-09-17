Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB61036D;
	Wed, 17 Sep 2025 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113426; cv=none; b=lZhtorQxffqcuvRCb4bF+EuCVu8fIoMuHSHaSD88695XJi/7kwqLEm6sRsxcqKJDitsbXEqZFUprg7GrR6GAfVnQmNgzDatSpyrVRL3ZLtvYc3aZgIBC6VXw8LWJwiy2K8cy1mWDeRnyq9N8ypexJzHDLBCXYo1Hc/k3ujB91DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113426; c=relaxed/simple;
	bh=UY3UaUIwbhu8IbagbV3CiMsicHArkRe1lCZxFUKEhZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2ZQl3PwAEKWCpjhoQh0M/dF0brn6bE9BRxP17HIh9i6BOnIa8zlPoM6PucL+EOX1i+0YtdhalzHPIdPpQTac/hX0NfOkOZxXMx07hTJrdNOPBcpDRwAXSjv8Ba7Il1+8ZBqhlUXbnCcFp85f45ur517HvRmXNa9cuqIxHxFuxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOJ2av26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOJ2av26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69A9C4CEF0;
	Wed, 17 Sep 2025 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113426;
	bh=UY3UaUIwbhu8IbagbV3CiMsicHArkRe1lCZxFUKEhZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOJ2av26HW5BR+yEuMS0W/fbC+FMr5o/YXgZKMU6KJHhzVuqhQEiLkaDyJVwNu5YI
	 4/6W43Dc7+aXKJc2E++3MuJZMb/mnAZ5mhkaaBmuPiCWbaKAHA1wZ40Spgc6QxOBho
	 /k6AVrAfGXN5Zn+rY5TAtY75TyZ9HMRvAKg+yspw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/140] NFSv4/flexfiles: Fix layout merge mirror check.
Date: Wed, 17 Sep 2025 14:33:30 +0200
Message-ID: <20250917123345.238168080@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Jonathan Curley <jcurley@purestorage.com>

[ Upstream commit dd2fa82473453661d12723c46c9f43d9876a7efd ]

Typo in ff_lseg_match_mirrors makes the diff ineffective. This results
in merge happening all the time. Merge happening all the time is
problematic because it marks lsegs invalid. Marking lsegs invalid
causes all outstanding IO to get restarted with EAGAIN and connections
to get closed.

Closing connections constantly triggers race conditions in the RDMA
implementation...

Fixes: 660d1eb22301c ("pNFS/flexfile: Don't merge layout segments if the mirrors don't match")
Signed-off-by: Jonathan Curley <jcurley@purestorage.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 69496aab9583e..6469846971966 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -292,7 +292,7 @@ ff_lseg_match_mirrors(struct pnfs_layout_segment *l1,
 		struct pnfs_layout_segment *l2)
 {
 	const struct nfs4_ff_layout_segment *fl1 = FF_LAYOUT_LSEG(l1);
-	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l1);
+	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l2);
 	u32 i;
 
 	if (fl1->mirror_array_cnt != fl2->mirror_array_cnt)
-- 
2.51.0



