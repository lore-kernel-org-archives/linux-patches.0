Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E1A342CA7;
	Tue, 16 Dec 2025 11:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884825; cv=none; b=u7g9adwObyFaCH3CmmC2QbT5LFeywV9UGRHinx0mDRvtkmx0BH2nczwfbhWiMm5fQIghZkwv/zTZ5p+JB7PZfBAg3X9lYpcGG3lwsnSCuj0LzlYfXLLQoTD39ah1pGWhwIfG1VOExpAy8y7esZxtc6bEs1Ae4KWFQFxlQ6s8+Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884825; c=relaxed/simple;
	bh=99eWctWIK1W2JgJjnAuHsD3mXPFzlr4GX0dv7qBpsd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROE7T/3YRCzWcbkIDWCGHRYPka7dPZyE4rgrLn9qdVmhIsq8GFyViShbrNs4/Pdw7WI22b7bs7O+pjYUKvCdRG6Ol5yibB7u1cj3m8j3OTWFnIsLNGEH1V2OpNyXhlOZC5DKQpr6eBw7WWV6FQVBTgXeh/VKt2hfw7lYRzLNKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SesbAccL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SesbAccL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B170C4CEF1;
	Tue, 16 Dec 2025 11:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884825;
	bh=99eWctWIK1W2JgJjnAuHsD3mXPFzlr4GX0dv7qBpsd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SesbAccL4f80f5r/URBpsI6LuOeFupoEDLoKHKXBUkQwiso3wByYl+dTgOZ/Qigjy
	 kbw0Fabwq4ZF0hYlC+LYIWaFv0gYW7Ds5aUnHZmcBBp8tUftNPLEyxMiuhCKqrBV8o
	 +618CWKaIpUjs4D5s9aC3oQLW/G1Id/H3HVMR+UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/354] Revert "nfs: ignore SB_RDONLY when remounting nfs"
Date: Tue, 16 Dec 2025 12:14:36 +0100
Message-ID: <20251216111332.106655401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 400fa37afbb11a601c204b72af0f0e5bc2db695c ]

This reverts commit 80c4de6ab44c14e910117a02f2f8241ffc6ec54a.

Silently ignoring the "ro" and "rw" mount options causes user confusion,
and regressions.

Reported-by: Alkis Georgopoulos<alkisg@gmail.com>
Cc: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: 80c4de6ab44c ("nfs: ignore SB_RDONLY when remounting nfs")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index da5286514d8c7..44e5cb00e2ccf 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1046,16 +1046,6 @@ int nfs_reconfigure(struct fs_context *fc)
 
 	sync_filesystem(sb);
 
-	/*
-	 * The SB_RDONLY flag has been removed from the superblock during
-	 * mounts to prevent interference between different filesystems.
-	 * Similarly, it is also necessary to ignore the SB_RDONLY flag
-	 * during reconfiguration; otherwise, it may also result in the
-	 * creation of redundant superblocks when mounting a directory with
-	 * different rw and ro flags multiple times.
-	 */
-	fc->sb_flags_mask &= ~SB_RDONLY;
-
 	/*
 	 * Userspace mount programs that send binary options generally send
 	 * them populated with default values. We have no way to know which
-- 
2.51.0



