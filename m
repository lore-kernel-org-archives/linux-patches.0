Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888548F5B;
	Tue,  8 Jul 2025 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992227; cv=none; b=Jeq8QPLNGGhRfZaKYk6cJ7oYU9GIJvwdmlKhzJmj6jAAPcHFnI7JHT5jSuyZ0EUm/c7tItOj3xTSFLKwJfmNauw7NKMwp8Kd4Htf6pHcdt1pvoFRwjzvqcrbchMMuZT+JnCcczYXv6uGV6lrRDPuntYYfm9y79FwlKz6I7DEdj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992227; c=relaxed/simple;
	bh=71xmVwHypRx57LaJMLkwnKFv5242dTvqI8Pp2DvESdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2wc0C8SiFKUt4P9iBEmwPQrkiyvZHKAKh7rRDiHdwhmTNdiAEVoR7lB2ZKHO6dH9cXPQr6iaTum4CSw9Ipf81NzH5k85EmXn10b9OyPvou/Pict1at9B3VpUsEw3ApjjvKYSrrs0aE/nBk2/WGi24zQYq/xSgxBsWWRh4u6Xwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkwjnYvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkwjnYvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD1EC4CEED;
	Tue,  8 Jul 2025 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992227;
	bh=71xmVwHypRx57LaJMLkwnKFv5242dTvqI8Pp2DvESdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkwjnYvMzgCvTgLmSXx3JTXiY2Yyg0t/xj1A5pnmD45UNEUuH9fPh39JP+fpreV4G
	 5I/dgFnXNQlzlG2pJoFGKDcc7eH8XfTz0MClf4LE/pSzcZf4F5JTKzbsZ20glbtYIM
	 ppS76DcPxsdfS00NkZwlHSeENbI3+d5OGK8/9RdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/132] NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN
Date: Tue,  8 Jul 2025 18:22:13 +0200
Message-ID: <20250708162231.373688830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit c01776287414ca43412d1319d2877cbad65444ac ]

We found a few different systems hung up in writeback waiting on the same
page lock, and one task waiting on the NFS_LAYOUT_DRAIN bit in
pnfs_update_layout(), however the pnfs_layout_hdr's plh_outstanding count
was zero.

It seems most likely that this is another race between the waiter and waker
similar to commit ed0172af5d6f ("SUNRPC: Fix a race to wake a sync task").
Fix it up by applying the advised barrier.

Fixes: 880265c77ac4 ("pNFS: Avoid a live lock condition in pnfs_update_layout()")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 73aa5a63afe3f..79d1ffdcbebd3 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1930,8 +1930,10 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
 static void nfs_layoutget_end(struct pnfs_layout_hdr *lo)
 {
 	if (atomic_dec_and_test(&lo->plh_outstanding) &&
-	    test_and_clear_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags))
+	    test_and_clear_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags)) {
+		smp_mb__after_atomic();
 		wake_up_bit(&lo->plh_flags, NFS_LAYOUT_DRAIN);
+	}
 }
 
 static bool pnfs_is_first_layoutget(struct pnfs_layout_hdr *lo)
-- 
2.39.5



