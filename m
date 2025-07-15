Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DD82EBBA4;
	Tue, 15 Jul 2025 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587631; cv=none; b=QJXyycNjhYaEISfWjOOdG7nJYgMZmhNTwjrTvgZKC1uJ5+rXV5EKTpb1UJDYiHOIwDVNtVd22l85a+LSrmEAR9FgX/3Y3I/NjKEenu4pWv34dSuVZEw0EWZULGLzW3J3L24+t6YtYt829xchY4J8LOwvw1bGOtFY9UyoRQKC/1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587631; c=relaxed/simple;
	bh=v+IrBRvMXUmYEn1jfl1Vc+Lj0TUpWghjhG2EcDzjqcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0hAB3rP4gl+fhCmwHrzz8T+ksnV2wCAZ7BMJkVx276TjUJHb61d2yi6C7t+CxerdwAHES/rcJoDM9Yd50bchB5L4QiPJN0zF7v2X4xYBUYHjFufDdHKGBTBibFYuCCnATkn1jP6YZxLP/sPdiHYHTj2A8SCaqpzwRyhe2M0F5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5llvgx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5llvgx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFC7C4CEE3;
	Tue, 15 Jul 2025 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587631;
	bh=v+IrBRvMXUmYEn1jfl1Vc+Lj0TUpWghjhG2EcDzjqcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5llvgx6sATqzAQyXHsXxmT0c2ygKrFEZhw9bZ0h0yvyriN89xad2HGNHax0z1OnM
	 RtGUu5mA22YiQCZ+fKRjnh7h5znfpEpG7pnpyQpICj/eihj/F8Ii8mtH8YrpUtr026
	 ZbsdiJsA71w+9Z6ggCwcPQw+L929BI86GYMSuuEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/208] NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN
Date: Tue, 15 Jul 2025 15:13:13 +0200
Message-ID: <20250715130814.306986679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1800836306a5d..758689877d85d 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1934,8 +1934,10 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
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



