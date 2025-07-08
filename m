Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53DF214A9B;
	Tue,  8 Jul 2025 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993362; cv=none; b=loDkjaZ6NCREZUXQYwkR/N8h56nNSlnPvG2EZ+beJ3ELaOgmy+/G9e0F5YDwVC4dC/8DJriraztVdEndGTLkIRzhX2vk6+atUmpjftYMNyjR6Y8Euu+WdOvurzLJNInE8cgh/2f1laBbFUfej1jhJwFfV3VlS1aHmE4W4OHuE2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993362; c=relaxed/simple;
	bh=3toTYYyqMO3UUuBE5k4NnA86CeJkXXqTMs8tc0F7mAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzfDBXrN4lsMamWV/F14FInioDh0HomlKhxsGJJxC3kDVPtYok/phHIATF5E5Uhq0CVeV0lM8rKj134pWFGzgBb8qG4mj3eNpBnhOFtO7a6NmymT2Z+MiNR3LQdD4JJESXAUlQ3c5NlIHRET+XD+Bm7npkxVK9/DXK0hxO6r3FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYtSuMzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYtSuMzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3432AC4CEED;
	Tue,  8 Jul 2025 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993361;
	bh=3toTYYyqMO3UUuBE5k4NnA86CeJkXXqTMs8tc0F7mAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYtSuMzggekomzu8lLj5VxVevaHC7+ZzzubQiZgX8GqXcf1D4CuBz4EHvspF3Pb8n
	 w+h3cITMEWmD8FQ1hWv1pJMFVNc9ciTkeORi1CYDmigB6I6ZsMhL8LX5xpweMcquIp
	 on2nDx/2QNKGdHDbbEKooWbey8ln6y+aGl3YYnuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 048/178] NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN
Date: Tue,  8 Jul 2025 18:21:25 +0200
Message-ID: <20250708162237.939443141@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3adb7d0dbec7a..1a7ec68bde153 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2059,8 +2059,10 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
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



