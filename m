Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585726;
	b=mnx4GAHJh35kYlFQBa++jb+aHqUom1snsO3EM3sExM+1wUolBt3dH6HL0bUzacLdzir0
	 BiZ5SSHAMg869KuV7jPWEN/KGmLtGKHRPY8zSPec5d5OeGSfhOtBh12WwdgfyrZ/6elp0
	 3VDX6tBrSBtlejg5SBViy6hb/+r5rd+kuvb7D2OuWk/69rxjMPE+RO5JPgdyVEzhYvYOq
	 pP+2u0u+ILb2f3Rya3/QjoNdoCylsb11xi97nCUuIFeCVDHPWcb7XSYHo6MMGa5+4Mfwm
	 gxdSmCHgjaBPQU0AgprcUONCvN5+XdKJfuDvog0pVlxpRKeMOUU9W2VP7qEE1XkJqRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4bt3u57o8b65XOXzzbyW49Ss76RDyAdSM67JGlHmRS8=;
	b=VuuwbWbG/oYrQnPPAYOMv/SAu6R2DDMNvTk1gvMOMO72TvGMQ1G5lHUjsBfEHFtyJimB
	 hZPn8OXRKFz4Izw2oTjv+4WbbCplPzRrL0EVDS+fZ2J/xJ5gOQL3K/SzgGZhD4hyn+wPO
	 b8g8M2Furr1hLUQPKP+W2tZB6abLcGvj8O5NWmjx8bhUQcLwu0kFiMdk60lsBVNajf+d3
	 Q+WiTGklxxylFye4aNsOnozOt54tm76lvL0+5vXbyig7GNRny9hX3P1vDuTVeBbtSPn7z
	 +mp9UudNCpwgN7CLyxOTVB6z/91pFI0AnZfz0ZpCBYyL/LEVIDqJuINaiBVh1MTQQzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEm1qob0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE1A606A8A9;
	Fri, 13 Nov 2026 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEm1qob0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFEA1F000C4;
	Fri, 13 Nov 2026 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585726;
	bh=4bt3u57o8b65XOXzzbyW49Ss76RDyAdSM67JGlHmRS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEm1qob0+7Ncwt3lWUQBgvbgw1CqEUqAgaxD8AtQy2nbMQ5ReizvuadTkhZ4a/SmT
	 WdRkQawK98oOS2t4s2DRvgW5VsI3VfUxWQbo//MZFHmWPNlbGSenllPYXuwMPnHNph
	 cifpW1h1PbYX8PDc8aU5cJEA+lwh7w61FeIrwn3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 284/507] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
Date: Fri, 13 Nov 2026 10:49:48 -0500
Message-ID: <20261113153804.836601579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit d8c2bc88460f89e543ab3af622fc8f34c7011d71 ]

xfs_fs_commit_blocks() adds the client's length to the offset before it
clamps the end to the file size. A large length wraps the sum and
reaches xfs_iomap_write_unwritten() unclamped. With the previous two
patches the LAYOUTCOMMIT then fails with -EIO and converts nothing.

Clamp the length first.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7ff83274a5135..19eb18e1290cf 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -328,9 +328,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
-- 
2.53.0



