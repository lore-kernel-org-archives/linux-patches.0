Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F0318A6C5;
	Wed,  5 Feb 2025 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767343; cv=none; b=FANmo54v4n2MqH36dfQKF/enB7NqE6/3ftvnq8NLDaqMurTcP8I5gpX6Bl+2dZvcoS2U0VSbma9w5a941TowS3q5fa7D58RUGEgUptIzwMxOKX+YdECFlfPyWAK0221ZAwX9kcO82RLd66x23AKUKzAC9wSVcT8lmzQFM68FtEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767343; c=relaxed/simple;
	bh=Tpm9IB3dr/GJkIVMWT+fm6DPFxsncWYiUoucRzaUtlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMwpYdZEogVPALlzpTwHwbQR3kv+8xkpyEbShwzwJmrcy/0lDXh3MO/ie2X633nWF9t1quOfOCnHHuKv9BSqTR7QG7kMtWQI8T/OUg6vF8PN/zMJOVboHrV7VAa/W3PMmBH0nyK01GQJFP90yvXFW+J61VNzQjcT8yrdIe80HRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7kpFIw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7kpFIw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B980C4CED1;
	Wed,  5 Feb 2025 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767342;
	bh=Tpm9IB3dr/GJkIVMWT+fm6DPFxsncWYiUoucRzaUtlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7kpFIw1F3LwmF9FLR7Vp2nP1BNWYE2RH9SJ4b7rWehELiPEEyYNHT2RWCILRiJwP
	 liu3gwxoA5u+J84vz639P2DmwNC9/XKIG9Dq+v06SK3brefHMTDeXWJ+0Krbnxd6nL
	 +HTUAVVcHM4YfCyC6D62dwDpRYPu+WnIuuDU7VkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 442/590] erofs: fix potential return value overflow of z_erofs_shrink_scan()
Date: Wed,  5 Feb 2025 14:43:17 +0100
Message-ID: <20250205134512.179279170@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 6be6146b67d9c..a8fb4b525f544 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -923,8 +923,7 @@ unsigned long z_erofs_shrink_scan(struct erofs_sb_info *sbi,
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



