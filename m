Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0781E1A25;
	Wed,  6 Nov 2024 13:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898393; cv=none; b=sRCmkwBNmXV9qlHb5T1W/S0W9P0b7ADlCZ/sqf5nrmmYdac1VxP0jf+vcUzwpBUTL3pki+Y8MTB04Nptr5pD2jIGHSriZhA/Ifc0Bc4cmYuKXFZKmoIlshkcHuslumhfd3eiJOdipuAi+zs41zjvSO/QOsuU9UsFGGO2f4voScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898393; c=relaxed/simple;
	bh=AaOA1LsBuSu5i0dlIXqXdPCr8WnzYXUCPW1Aqi+yM8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azkQH9jJZ9vMOCRWIZ2lrvp4emxc5S4Z8zHGo4RVuiFYDdRNMkQy/Dj8G3cIT8JtgSyGUo0rgMPLt6YTf5YOG7u3uVNY+ybxVBgySYxy9AWQbyl8J4T2K6fkUdn+rf8oLeMbjm31G4xhCUrs4HxkZKlwlNRNJjTzoxcULNxlo2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/fxSxDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/fxSxDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F83FC4CED3;
	Wed,  6 Nov 2024 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898393;
	bh=AaOA1LsBuSu5i0dlIXqXdPCr8WnzYXUCPW1Aqi+yM8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/fxSxDEFzJfFpEsBeyort7OZSV3nF/0mTsc4XJtJZoFEY3W+R12r3a6BnKi4yUUs
	 a/Hujvmgz+RVL20GybFN+eAFmT56diHwTkslWBEK/WoysKrAe/VnjJv3m4JvnCYV51
	 A3pn0059G9Pn1WM/n6KxGz3cAsZZOP9s3lwh99js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 222/462] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Wed,  6 Nov 2024 13:01:55 +0100
Message-ID: <20241106120337.004698181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fe0b5a91356c4..ab90c7561e20c 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3084,7 +3084,7 @@ static int dbFindBits(u32 word, int l2nb)
 
 	/* scan the word for nb free bits at nb alignments.
 	 */
-	for (bitno = 0; mask != 0; bitno += nb, mask >>= nb) {
+	for (bitno = 0; mask != 0; bitno += nb, mask = (mask >> nb)) {
 		if ((mask & word) == mask)
 			break;
 	}
-- 
2.43.0



