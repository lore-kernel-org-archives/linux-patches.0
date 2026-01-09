Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D8231E107;
	Fri,  9 Jan 2026 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961947; cv=none; b=BeUyrB0jKNaUNKy5VQ2M0C1Gxb+PS45KaoFJRQd+Z3y+mEcBC4hrsiu4sKWG3Wytk2Q2wzoUxCL1stWgYR6hZhDTiqaTdXOu8QuU577F/FAaYffE6XH2ZcGNLbsUqlE0OBWEBMC1Ekq7usrcQiYhstTt6nNMxlqSaQD1ley8b1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961947; c=relaxed/simple;
	bh=ltzMetuDcTErsJ5UuCqqZ7/LxmVEE0JkTEBt+oDHbu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laVhUjNnoB7Lft7nCEIq2cN0G1O9z7lbKOOALL24cq0DS2T/YxRurXPbWeSOo9OLOADBctSh865Uvic46DChJ27UuGVnM4d+TUmP3Lyh9IFz7gBEShlNlNNGDQSzs0d8BKgeW5RsEchWHn+yUF02YEd3DwRoDQCQgcmfUvz/rBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTqJAEBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTqJAEBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A5BC4CEF1;
	Fri,  9 Jan 2026 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961947;
	bh=ltzMetuDcTErsJ5UuCqqZ7/LxmVEE0JkTEBt+oDHbu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTqJAEBYoGA2fKEgUCEslh6ojHK3e2wMI3tIvOIl697OQmHRT8nmYebde/WYgGGfI
	 WH+sQqtKZEeByLqInEAs2FTfsH5jfYIv7KNrTE420/invx0u8jJ2X7qGt6bx8ivASk
	 gnPEwAYAWnuZnCfDuLkw2hjPJQZE37VBBlYMBDFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/634] Revert "nfs: ignore SB_RDONLY when remounting nfs"
Date: Fri,  9 Jan 2026 12:37:50 +0100
Message-ID: <20260109112124.662106910@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2dca011da034e..a4679cd75f70a 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1017,16 +1017,6 @@ int nfs_reconfigure(struct fs_context *fc)
 
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



