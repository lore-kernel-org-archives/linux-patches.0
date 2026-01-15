Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004DE2C029F;
	Thu, 15 Jan 2026 17:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499249; cv=none; b=icSjQmkYN+XVvIhW6OuACkoxyxCUSox90vOwkWmo0no2D6BweWhWwfxzv2dEqApzvC5vNS8qKJOAw4yupKGMnIFJW5nkIDWRHOSMBUh8bpoRKvITPlCVvmMXIgaRmoM556sKWdTL7g44iLGSLiQ4A7YvaihwqizKLQevZfhJRWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499249; c=relaxed/simple;
	bh=wlRipzAQLJNL/CnBpMJqFU5LjrtXPR01GtCzoauwsYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxMkhXFbDpN2BOzXeaezXGhKL7bNmptyqsYKpkbOd87lpPBpqx+rRm9b5AJDFxAEndin5IuW7ke4HItF3DLOZIZMZGV9HC0VX6i/Q6bZN9j78BMoBQpxzeVpPNXw0uzH04DeLZ4AePBMoxH0y4Qg06FbxcpNCgJo/EBm35pHk4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lx1FFB3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lx1FFB3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F39CC116D0;
	Thu, 15 Jan 2026 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499248;
	bh=wlRipzAQLJNL/CnBpMJqFU5LjrtXPR01GtCzoauwsYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lx1FFB3/kEZJu324kqbcea5tBKJJcj+KIoliJOCArYZ2vx1YkigDtNHDUsKpY0yGG
	 fk2MciBKTQCw6BntbamYtaqeoshBcRCzStIZGkaNHBCWfbOYxIDap/1an8eTUXu8M5
	 KyU20twAD8+iLTETwgQO/NGXiAFFLH+v/ZaRMpoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/451] Revert "nfs: ignore SB_RDONLY when remounting nfs"
Date: Thu, 15 Jan 2026 17:45:28 +0100
Message-ID: <20260115164235.516047873@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 7c58a1688f7f7..27923c2b36f77 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1000,16 +1000,6 @@ int nfs_reconfigure(struct fs_context *fc)
 
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



