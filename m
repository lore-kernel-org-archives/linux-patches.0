Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5431F9E8;
	Tue,  8 Jul 2025 16:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992747; cv=none; b=Fzte6dLL1T6fZm1le0l201z8u0UQr9bfl/fPf8kY6OKJonnVG53u92Ct2K1frFuDLir8G4fG0wqzB/59baUXy2nNfDPBwLSIWvRGYVjZCnmzL8NTwMW2snuXT4a5sIemKy/UuYmZI2GbU4GSEsiUQyUt7UwniOl1pLUvdFSGj3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992747; c=relaxed/simple;
	bh=skEK/WIJh8pI3I6/nRa8zP9i5Q8O/iynHJRjBJHon18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlPAz6KjOc6BYT3gp4BTvGhHnUamsNMLaq7KHprUWlkP1ny6X8DqtfbJ4e4Lo5eq/5WH5nFfBSoRM9GrHEn+Wln4iEtuWI882uZphdkaR/q/Gy6q/KsHyvraHbwCbk3uEvPIr28GaJNA9zNwkqS/pgDC9rcUl25LhF7fysGcgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDtvJmUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDtvJmUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72DBC4CEED;
	Tue,  8 Jul 2025 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992747;
	bh=skEK/WIJh8pI3I6/nRa8zP9i5Q8O/iynHJRjBJHon18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDtvJmURsgKFrrST09nuW++rM9thNJEP7e4EkqGu2WXwUkCKfBxymQ65HOhysikya
	 Y/S4GfY7rBt6w9xlmprXabqAPZ0y4NtZTT4psJzvjLdbnd9SYd0NTQf00f1l34jdTX
	 Z5xh/5D+/8EeSrwzglRtGaDIao26fpdAwwEb5XEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/232] NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN
Date: Tue,  8 Jul 2025 18:20:32 +0200
Message-ID: <20250708162242.376346903@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 683e09be25adf..6b888e9ff394a 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2051,8 +2051,10 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
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



