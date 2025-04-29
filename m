Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787724113A;
	Tue, 29 Apr 2025 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947136; cv=none; b=FmiDqB/APvjy4PgsnY7ZQu/wwH0ulYTAqfscL/vuw3dGHZHBMDMGXSdTrYyZ9tWBnjFkam0fCL6MuZix2c1ejSuU0Ph+QxBV2XEjbiKo0UXe/EIVhNBA9itxrSO38ShDMdLjdLLCNp6MVcMlEv8GWnRTEldGJyw7ECmNVsykT4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947136; c=relaxed/simple;
	bh=9tURXtoWziVAGpV2qWMpW22oX12el0WHiLCotUssGBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKFtif7Fvsd1cM2IhCKACS/P4eGDHMTdSZfeoJDST/tiJXrZIfgDlIpzgvlhZQC1Q4qp+oDB7iNtqWy7cedilnCprjki7xl4Q64J8uTE4lEC1bFxlGpJCiYB3ZKlMY+xSSG1bfl6N0AG74tLWrdCWhrc9CyxypBSJjdnsIiShjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PR/yv6mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PR/yv6mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2593C4CEE3;
	Tue, 29 Apr 2025 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947136;
	bh=9tURXtoWziVAGpV2qWMpW22oX12el0WHiLCotUssGBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR/yv6mBbWr9+G9AAFgCRMEn4Et7SVnrIwcE3L1FsJ6q8xeLUQ0B20Ytww8FksERZ
	 r2wsaMR+vsOKJjWfgzPtaaD/NO8SZZAlnqMp2BNcqqnZFK/321j3W0g4DUMdyD2v78
	 zszmlmlLXPF9CYGU08Ua6/e6XAuqrkkCEEvFvkRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com,
	Pei Li <peili.dev@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Zhi Yang <Zhi.Yang@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 183/286] jfs: Fix shift-out-of-bounds in dbDiscardAG
Date: Tue, 29 Apr 2025 18:41:27 +0200
Message-ID: <20250429161115.499506769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

From: Pei Li <peili.dev@gmail.com>

commit 7063b80268e2593e58bee8a8d709c2f3ff93e2f2 upstream.

When searching for the next smaller log2 block, BLKSTOL2() returned 0,
causing shift exponent -1 to be negative.

This patch fixes the issue by exiting the loop directly when negative
shift is found.

Reported-by: syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61be3359d2ee3467e7e4
Signed-off-by: Pei Li <peili.dev@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Zhi Yang <Zhi.Yang@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1698,6 +1698,8 @@ s64 dbDiscardAG(struct inode *ip, int ag
 		} else if (rc == -ENOSPC) {
 			/* search for next smaller log2 block */
 			l2nb = BLKSTOL2(nblocks) - 1;
+			if (unlikely(l2nb < 0))
+				break;
 			nblocks = 1LL << l2nb;
 		} else {
 			/* Trim any already allocated blocks */


