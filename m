Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C4B2E49BD;
	Tue,  8 Jul 2025 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994139; cv=none; b=pAnayHiDcSgwMLJXrxW8Sv+FfnBBKu0gsWDk9hlj3z1vjXIC7/RZwJz4lJFwV79Dex7/EVb3wlmQIRu73wigfG5sNe9iYH8N6R/RFmxEzd3u+KYW9mRArtGeE8vZIhBfpMebruAGd+lgqt6K9Iy6h/JUrSjEUg9xQzjgmHiSK1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994139; c=relaxed/simple;
	bh=mqWJ8wAeSEC9NkFV/r99Go2c4ly0xMb8H240P3e7NnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mn5mLq5giMigiscrv3rfyKdxtqS6+Xbn1+nJ9SzYDw9pjxQoqWgxNyeuG7Gkh8EGMp+z4GyLl8c3OCRrS8DKVArQDncZPg2nXaG36Ap4MpBcY4pd7UOFzt9UWzqHgmQUGldjaGFLTz0ITlnA/LrEeQaIdI5qMc5Df1R8ipaiYDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh1qrsWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh1qrsWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AB9C4CEED;
	Tue,  8 Jul 2025 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994139;
	bh=mqWJ8wAeSEC9NkFV/r99Go2c4ly0xMb8H240P3e7NnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh1qrsWYLLUG15P1j//KkFvKiSBRyaEmJzkHt2m1C6pDp/D15V0545znQ8CVAbCwE
	 /2bTalM4ltswdgHzYtqLWtqvXOJAxzrB43GG3aNWt5Kvb4lVEHmQc+FnE5JWXACGmP
	 a4s96JvpU+1HxW8K9lRI/DB4SGMoDWGgV3+FfP2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/160] NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN
Date: Tue,  8 Jul 2025 18:22:25 +0200
Message-ID: <20250708162234.470956944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 83935bb1719ad..b41c6fced75ac 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1927,8 +1927,10 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
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



