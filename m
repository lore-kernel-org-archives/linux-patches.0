Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211DA2A1BA;
	Tue,  8 Jul 2025 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992072; cv=none; b=a4+nqkJRmtuj6p9lN+tBFKoQzaKtromNOO7U3IbmatQ4sa4YXscK/z/atI2NmxnoHwAk/UP3EJE8Xb/L1T8EICLxl/oEkPA40jamyUZN6F7AYyu3PuGP5b704An4FIHpnWg2HspL2tiBFvOwUpDS3gfLznHkqOV9vrWbzlOz47A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992072; c=relaxed/simple;
	bh=e7FZ7yYrAY0mWCesh2Jwc+euQ1MDJonlPK5deKtx0ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6MPUySGVEpm+GbyV8jR5kY/WNYxAMKfwdd19NmFyBQxB2UtHir16K7KwvyqI6J7FCRckgvTbQcasDM1G2l1dRo8eEjR4/RB91omQBRix0WX3SZl9Md570/uMBuZ5EAzSe0FX6okr1h3/+W75+fHtWrvpzPLWHTxBXHCe2Ab+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLTs5diG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLTs5diG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDCFC4CEED;
	Tue,  8 Jul 2025 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992072;
	bh=e7FZ7yYrAY0mWCesh2Jwc+euQ1MDJonlPK5deKtx0ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLTs5diG/TVI83kmYbbFC7C3Sm+pPKuP3Cs1ZIoqNZKu8z/Bn+c+9s0o9JPBjF1Vj
	 kjbEhbkVoZjJ6eglsHFPm9fpi3gPCFgJGR6vyahGm6mIYwbe3M0feRj81V4CZqrE4o
	 YTCj91qk3V3zJDRmpW4smCp5pyR1ywfhAlyBCT0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/81] NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN
Date: Tue,  8 Jul 2025 18:23:11 +0200
Message-ID: <20250708162225.537674968@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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
index fe0ddbce3bcb2..7f48e0d870bdb 100644
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



