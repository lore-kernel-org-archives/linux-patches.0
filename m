Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F5FAD4B;
	Tue, 26 Aug 2025 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214695; cv=none; b=PhSM2vvwzUmCmvH3Vndyh8e5apBFINKCc65i4NJn+viIK+I73Kods3pOoVTvTcjWC2SFezKmI2+CQ0HoNjRcvkx1La6jRpLA56uy4K3x2WVsHJ8I0Iw+vWkQe8tIa69dDX/wJw1J0t/CSoM/aWSVgNBXd0cMrjtnMbYEJf8qpOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214695; c=relaxed/simple;
	bh=bbMyZN5dKZvALjeDCT53Jcd9EUSdcaALESqPv6t0gd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCwto25T7m1/CxzvfgR5RuwWBuhJEHiaRKS6v3dzrUbjEWsITJobWLr46mYTZd8TGHphQ2kiJgcjeG8voR3NrrywKGgvMeABwMAXtizKH1gEZuQMYr49O5A5mHBh53Usq/aXasuXpym5L5mEmaaGUGBfVIGpifNLAFS8M5c0l2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQvuKWbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQvuKWbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBE7C4CEF1;
	Tue, 26 Aug 2025 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214695;
	bh=bbMyZN5dKZvALjeDCT53Jcd9EUSdcaALESqPv6t0gd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQvuKWbuSwQIXJXwJB+C9kwW3C70lnNZp2SntLA3cbLl0Q8ko/lmUHxZZApXrDRx6
	 GaytYROISN48RK5cTJdwJA2R5WtdFJcRqBayd8l+Wz8LQKtJ2ivLdiMM0Ieq8kQeNZ
	 0dNLMHRrNTZbi+lRRVKVe6GQmsuDYe5AW6j0KYhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/482] pNFS: Fix disk addr range check in block/scsi layout
Date: Tue, 26 Aug 2025 13:08:07 +0200
Message-ID: <20250826110936.553406172@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 7db6e66663681abda54f81d5916db3a3b8b1a13d ]

At the end of the isect translation, disc_addr represents the physical
disk offset. Thus, end calculated from disk_addr is also a physical disk
offset. Therefore, range checking should be done using map->disk_offset,
not map->start.

Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250702133226.212537-1-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/blocklayout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 6be13e0ec170..e498aade8c47 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -149,8 +149,8 @@ do_add_page_to_bio(struct bio *bio, int npg, enum req_op op, sector_t isect,
 
 	/* limit length to what the device mapping allows */
 	end = disk_addr + *len;
-	if (end >= map->start + map->len)
-		*len = map->start + map->len - disk_addr;
+	if (end >= map->disk_offset + map->len)
+		*len = map->disk_offset + map->len - disk_addr;
 
 retry:
 	if (!bio) {
-- 
2.39.5



