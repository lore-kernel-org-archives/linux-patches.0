Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062637;
	b=jVe/aybSbVQtW7YeHdoNPEQU68XYiP+jmWTeFHNkJEJDY3BzgoBP6ycQ/pFM52PtoHYi
	 KR2W/qY0Z03jp08pCDlSt31Icr1vsrsdTw7HcdbeqFiLp7ytgfwBhOsTdKelXTsqpaHJ+
	 HRsLiTmPaZREOB1ptiz91aYlwoM7ZTo5ZG4s3wt/w/S8PjLxag1dcp/EuCUmTbtWiAE/M
	 W4paQTuiIEiF7g/dRsLE7nRlRdC7HNsgXAcW/sDNDYcxUFwG1dSpbRTL56HMaK6kp+Bgg
	 R/k0jVnqRePrdlHbEZpLxwxDGXD8LCvklvSmLq3ZCzyaGawPGxnXUe0ODQVEU5uwGcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApXtuz6bM7immOnJEUaKsx5sdVfTCjyAU2pge+WvvdA=;
	b=K+XWG+EltShjPXLUwYjMRptVYRhiH118bgic6mDhTeWWbDfMjSdS9o9n1feBtQHd3VHZ
	 R/Pldicj+mRcQWfB7XYOR1iPKgveyKfbOa0VC7ob2aO6x2SpfnCgbdej1Ts16kypPaq/K
	 kyBauYm654n+jmxgLlB8usjNrjKOWZquehZPFYMcdSZHom6xVqqvEmtDyScjjRgYzQ/ug
	 yQbryTBh0mWRV+2aQpLWEDhBKZJGzoGhj/xSSG+re06nigoR0q6dz72jBXnVbUgm21E46
	 SvyqHFiC75UD3dVBUuJSL1Wt5/ibj/AEKGTv0e9wMTbmnHrhKTq4HXRVWvdaGQbygQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aT432FU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C408606A334;
	Sat,  7 Nov 2026 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aT432FU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00AF1F0089F;
	Sat,  7 Nov 2026 14:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062637;
	bh=ApXtuz6bM7immOnJEUaKsx5sdVfTCjyAU2pge+WvvdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aT432FU4VuPBwnyN74guI1mxgU3jWQCBtv4NrCAiL6RbWfcEf5qRLMxq0fOwX1Km2
	 HltYcebzrnYnwN4450jttJLU91bjRiwPa9Ce4IAFK+fqqRhWz0RnoU51lTT4dMXmlX
	 RpjrGzLWEgi0BOxbs1fGvE8mMIwi4CrSvepWQdWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1505/1536] ntfs3: fix mapping pairs bounds check for alignment
Date: Sat,  7 Nov 2026 08:58:41 -0500
Message-ID: <20261107135040.136058069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit f517cae6333121783043d9ba5142b50f5d1cf75b ]

In the UpdateMappingPairs action, the expansion check compares the
unaligned new attribute size with the available record space. The new
size is aligned to an 8-byte boundary before the mapping pairs are
updated, so the check can underestimate the required space by up to
seven bytes.

Use the aligned size in the expansion check to ensure that the
subsequent update cannot exceed the available record space.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 5774fc1bd0683..2a1f1a7f5b012 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3438,7 +3438,8 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		if (!check_if_attr(rec, lrh) || !attr->non_res ||
 		    aoff < le16_to_cpu(attr->nres.run_off) || aoff > asize ||
-		    (nsize > asize && nsize - asize > record_size - used)) {
+		    (nsize > asize &&
+		     ALIGN(nsize, 8) - asize > record_size - used)) {
 			goto dirty_vol;
 		}
 
-- 
2.53.0



