Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7F11CACD6;
	Mon, 14 Oct 2024 15:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918987; cv=none; b=gpbcelEYD2zhPs5+xPtsVfT7umHZz46nS9nyiZJlFdGqqV6HBcFxQMmgZ0pkam6MeTglziH6pTXfLLkGpyHm6h0wLWbZ/Km+fyxKET5Y+/G/ZXgYY16U9SEA0JpxS/MPXr0MEKWpNudOm40UDKjXKAcVyAD8WaG3Y/iIrjAFLrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918987; c=relaxed/simple;
	bh=Dg201RG5G4P30GCy/ROtTvOKJqo0Rwo14kashv71yLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQk9LpPxYWfQ8hEs38B7PI28IY23CJxgazmbTjvkoXEmMA7oQNjvXbScDdpq78eYCSB/pTaEsDvCKio5ur9Jbfo7WmO2o3CksF3qut/J52gMVCJe3Bu9EScI/uOHnbaRpxgGJP0t5z7h5Kh1UvaI2MWiHfGz767f/LR3J0BIVH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GlddXMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GlddXMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAEEC4CEC7;
	Mon, 14 Oct 2024 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918986;
	bh=Dg201RG5G4P30GCy/ROtTvOKJqo0Rwo14kashv71yLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GlddXMdhmLdcJTiDlYAZubPa7WNFIXaXM9xVVCRXqzrxjW683c6Tu75p+k3ItgBB
	 ykI5iqbMY/fYgrPhq5xWjhIxi36cLB5v0zjXgUOYvBhzPGWGTi3AE2TDfOgCO/DCdK
	 rNTRRrOTJuB0FBl9sYNLeOciecQYC4xOKxPBTDy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 480/798] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Mon, 14 Oct 2024 16:17:14 +0200
Message-ID: <20241014141236.832258761@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Remington Brasga <rbrasga@uci.edu>

[ Upstream commit b0b2fc815e514221f01384f39fbfbff65d897e1c ]

Fix issue with UBSAN throwing shift-out-of-bounds warning.

Reported-by: syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com
Signed-off-by: Remington Brasga <rbrasga@uci.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index bc645014b2849..b155e18297316 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3022,7 +3022,7 @@ static int dbFindBits(u32 word, int l2nb)
 
 	/* scan the word for nb free bits at nb alignments.
 	 */
-	for (bitno = 0; mask != 0; bitno += nb, mask >>= nb) {
+	for (bitno = 0; mask != 0; bitno += nb, mask = (mask >> nb)) {
 		if ((mask & word) == mask)
 			break;
 	}
-- 
2.43.0



