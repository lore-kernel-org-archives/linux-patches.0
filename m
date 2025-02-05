Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6742D1519BF;
	Wed,  5 Feb 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767957; cv=none; b=EzD8syJW+q3+MdfOwHwODgzo+4RNcI4nJE1WiYVN93NXzN8xnkp1FCx+XnT++qglnkjtSYII9sR6KK6NdZDafbdKIB0453AnlYD9QVaOUsHotMcDDeqixtvalWrnsN7U2RMrDTHTT9AI/3x/QVFZqs5bmaPW2p1HxO1n1xpybrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767957; c=relaxed/simple;
	bh=ii2YBr65DIvLJpDCYz5gZ4rjM/U+z6F3BqaqrOFzaaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwRxwImm35ByA8TuB5o6PUWo2nGDTchTL1SEuYpTdysf9JAqMu0KPEKvP8a55t4HgAAgtkVDi8GQp64+GR7CmwlHmgr40AEAF/wZQms8wbvPPWybK4XUjC/FJ6t6Tkn8Kzzdj/1yMPESdifNk0bny6mzXLf1QJSa87M1TbpZAbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B92dw80X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B92dw80X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0EEC4CED1;
	Wed,  5 Feb 2025 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767956;
	bh=ii2YBr65DIvLJpDCYz5gZ4rjM/U+z6F3BqaqrOFzaaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B92dw80XhQswj1GGPt+k5VXc7QzT5ijqkg9TP8t8sPP+MVrUTuBN+Aznw2eCOZ7Al
	 coxbQJTGSn9Mph/YTa6PQMKbXNq7WMz3vQXe6pqlJxYyAHY2zFQF8adwMFfaf6rlV4
	 UZj6wZiLwd/FB1wO21sEqVTiVAPbodTV5sAwmxls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 477/623] erofs: fix potential return value overflow of z_erofs_shrink_scan()
Date: Wed,  5 Feb 2025 14:43:39 +0100
Message-ID: <20250205134514.466291004@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit db902986dee453bfb5835cbc8efa67154ab34caf ]

z_erofs_shrink_scan() could return small numbers due to the mistyped
`freed`.

Although I don't think it has any visible impact.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250114040058.459981-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 19ef4ff2a1345..f416b73e0ca31 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -927,8 +927,7 @@ unsigned long z_erofs_shrink_scan(struct erofs_sb_info *sbi,
 				  unsigned long nr_shrink)
 {
 	struct z_erofs_pcluster *pcl;
-	unsigned int freed = 0;
-	unsigned long index;
+	unsigned long index, freed = 0;
 
 	xa_lock(&sbi->managed_pslots);
 	xa_for_each(&sbi->managed_pslots, index, pcl) {
-- 
2.39.5



