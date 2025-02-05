Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271DFFC0B;
	Wed,  5 Feb 2025 13:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763643; cv=none; b=tPNHbRpexgVmbGYVPGhFum3Q15qk78QzAZse59tCA4QeNaknjBKOG2HQJZwRVFhKlFwtKdRCk7wFcaSv+ymO9mspF7NJCY3D+/yk7NaGyLmvbWtdhMDY/LTV/H3xNtqCKlzmCMBtzrDokg2ZhLNxT37Rwh13TIo5VxTV4hqxzjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763643; c=relaxed/simple;
	bh=DDXDRDk/O7rp9GLkzuiKIvD1e52WosGtwGNLJxG2x/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fxu5Osd8w+n6OGazKFn7HZD558Q1mtZnt2xGLpeFhdFiQeYZRYpbY3P1DUjb08i1eV7DgVyoU5AkPC7mjcL1cSoENCT2R5+YGVBvXE57zGZmo9vPoxVj55s3mfZ28PYV0OJhJLGwixlEBniAj5xSIonh2St1Vr32s2gL2qtFKtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQBWcgfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQBWcgfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894DEC4CED1;
	Wed,  5 Feb 2025 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763643;
	bh=DDXDRDk/O7rp9GLkzuiKIvD1e52WosGtwGNLJxG2x/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQBWcgfnVsqS7TJkEgw+NBEPdh7zDYUB7TPvQJHcKKX4NPdtvcW+HuXcXK0qB3zvX
	 QD9yQZWSPOg06pe/Wv0AAzN5scROWp+7OT4cpVx/q1z/3L+c5f8yNk1m3xxT8XVA+A
	 KtZRiqS9IYvB0a500V5HVS/1Ka3DtKRfhmtldKc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 005/623] afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
Date: Wed,  5 Feb 2025 14:35:47 +0100
Message-ID: <20250205134456.435612122@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit b49194da2aff2c879dec9c59ef8dec0f2b0809ef ]

AFS servers pass back a code indicating EEXIST when they're asked to remove
a directory that is not empty rather than ENOTEMPTY because not all the
systems that an AFS server can run on have the latter error available and
AFS preexisted the addition of that error in general.

Fix afs_rmdir() to translate EEXIST to ENOTEMPTY.

Fixes: 260a980317da ("[AFS]: Add "directory write" support.")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-13-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index ada363af5aab8..50edd1cae28ac 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1472,7 +1472,12 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 		op->file[1].vnode = vnode;
 	}
 
-	return afs_do_sync_operation(op);
+	ret = afs_do_sync_operation(op);
+
+	/* Not all systems that can host afs servers have ENOTEMPTY. */
+	if (ret == -EEXIST)
+		ret = -ENOTEMPTY;
+	return ret;
 
 error:
 	return afs_put_operation(op);
-- 
2.39.5



