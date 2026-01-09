Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BB1359FAD;
	Fri,  9 Jan 2026 12:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960039; cv=none; b=cO+s1kbnme8Tsh0KZbzUWVIrubKFQmVwIRBTabN8rqCBL29zSg6aSKw+aflfNeC/Eh1xImDFIFA3P48FcXBRTOlmOU5cv1F3PM5eoDEqfi/OLK/weYvfItkLYdrHZi/b5t6hCE49ZEak7OiKPdwkVq/KfmjTsnF2wqOvH8FkEeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960039; c=relaxed/simple;
	bh=UyqFWlCnJylVBiOIYDz3BuQgMWHzDqT7fOiWHr5J8Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaWQb05PDs6teMHt6Eee41GsF0E30LKlNGXk9Eb3W4Q4I1xDhI9dTnjpkpKfQ8winZJKiDVPA80q7KKqIIxw0Fn/S0qEiUAynfGQRTM+Vwx/qKZc1MAKcVVM6TMNtECyCKUe0HfSns7+z0P2oABIwLU9F45QXrszbN0oHdeEMBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhZQB5bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhZQB5bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B0CC4CEF1;
	Fri,  9 Jan 2026 12:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960038;
	bh=UyqFWlCnJylVBiOIYDz3BuQgMWHzDqT7fOiWHr5J8Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhZQB5bg412LEyUvp3fDbp//TYrdScauS+JUrwWP8S+D2euiYj43TPU96R9n74jkn
	 pz+14vtBkMLBxVfJ5kOQ6CYprDyiXi9oV7Uy1FMCppX2BQ8gKOG8vyaD2NZCaih1aW
	 dLH6gbQt0dgTcTmw3tIpzpvaWwH5eq2KVy4ucyxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/737] Revert "nfs: ignore SB_RDONLY when remounting nfs"
Date: Fri,  9 Jan 2026 12:36:43 +0100
Message-ID: <20260109112143.923809770@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 4e72ee57fc8fc..59bf4b2c0f86e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1020,16 +1020,6 @@ int nfs_reconfigure(struct fs_context *fc)
 
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



