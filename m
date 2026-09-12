Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3383A428470;
	Sat, 12 Sep 2026 08:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202502; cv=none; b=KLklNBWHA73jS1TDUxN8KnhnoXdhyy2oXW0F7yGQGIP5/dIhA8nepoVgg3pk5jiR16u70x/L8Us9cBkvO+sV7/xfXeX8s2GoJezb+UIaDbVciX5Y3da7rSu3YaZlXlzmy5XLii6V1zwBtyO/3cka0hJ2BjWghyrUoF+KFJ2I//4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202502; c=relaxed/simple;
	bh=TPI7VnGie1eObgL46O2Yle+3SqMJV4jksJTKsU2M2TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSkuxpFqGSpFPF6qHrosmD1SZNEsZaCF5Q4IbFubmfPeIByqSLEmg/T3unWHWUzeRskUbICAGNeosIEOIXr/VUQA9fTkA3M6wptKTa3vP+HD0TR0jR5xpiy41iXm0o98KtQw5d9Cnj3/y525I7GngKMDjk9+C5vMbQguSZ7HR0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBSY5i+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBSY5i+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D111F000FF;
	Sat, 12 Sep 2026 08:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202501;
	bh=i82I46rsunRGyejGZ9kBC5bf+YjweKAL8KtUzZuS16I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBSY5i+1tNRfDI5bPUmaT1/meGf1aiGbhu4XBlcXfkTrCZUaFTNY6x5vj3bJftIl6
	 TYgwuqRGcTxuEymoDnfZJ1FaR17U/N4zUsBm903DVrf4/FETtVyTPaTmcNygaql053
	 f2d8y02EfB34iaQQ9flRX/IZzUE99bTzDrChU/H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1189/1815] md: wait for behind writes before destroying bitmap
Date: Sat, 12 Sep 2026 08:48:59 +0200
Message-ID: <20260912065716.923336573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 2a79365b2278f16e163e4024086105693b421601 ]

__md_stop() destroyed the bitmap before calling mddev_detach(). That made
mddev_detach() skip bitmap_ops->wait_behind_writes(), because the bitmap
was already disconnected from mddev.

This was still safe for the legacy bitmap because bitmap_destroy() waits
for behind writes itself. llbitmap keeps that wait in its
->wait_behind_writes() operation instead, while ->destroy() tears down the
llbitmap storage. With the old ordering, RAID1 behind-write completions
could still run after llbitmap storage had been freed.

Call mddev_detach() before md_bitmap_destroy() so the common detach path
can wait for behind writes while the bitmap is still alive. Only destroy
the bitmap after those users are gone.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-7-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 17f9d494dc48f..1603856c644b3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7076,8 +7076,8 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
+	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
-- 
2.53.0



