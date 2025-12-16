Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E783346A01;
	Tue, 16 Dec 2025 12:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888482; cv=none; b=WFgnNlUvmyz0mlAEI80auadGK5AWAd3aqR7ok4uHoBNuygMKT3xeoKTvif4W78MaJINpQrK3FNUKTSr0YrJudS7QQOsW/C2mDhI7YmAhzVWEUb56AH5WcbrTYh8IcJPegydIwq9LNBDXfhf1C9CuPseli2y7myzeRPnEOQ06pDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888482; c=relaxed/simple;
	bh=DPDaRbXImkI3vNzne4bbnBQZKew6TjCdpZhU2EiBMyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTGZzPIVHZiFpBcNTtLlF263DEOss5EIEI+AHjq+klqvxQuDeQXiJIr28bHIBppqXw9Yr5lM3jPuexJVk0rG95rBlHqxVNYRxBpka3TbvjKSWPSfa2/aMNPkaOLWky/DNf7pSD8p890tLcAtePweIYQhcKXWKYhTGO9ZzzfGFh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQdWM+R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQdWM+R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0575C4CEF1;
	Tue, 16 Dec 2025 12:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888482;
	bh=DPDaRbXImkI3vNzne4bbnBQZKew6TjCdpZhU2EiBMyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQdWM+R3/Zajq5DNifjtbAfpacq2UK0NJV7wDbtmIKHIpOgunxkxx05uDWwP+dg0v
	 udEXWD66V+C/ANB7Xi3vycPWRycpu7Z9X7pZfzmcZiZq5CSfwCYUQXDVK8LQX1aaTC
	 7H3tRIU/TW1ezj+ofqdDRtV1j+oemov7e0TGvq84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 547/614] Revert "nfs: ignore SB_RDONLY when remounting nfs"
Date: Tue, 16 Dec 2025 12:15:14 +0100
Message-ID: <20251216111421.198844379@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 72dee6f3050e6..527000f5d150c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1051,16 +1051,6 @@ int nfs_reconfigure(struct fs_context *fc)
 
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



