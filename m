Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BFF3C0B;
	Wed, 19 Jun 2024 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803837; cv=none; b=mwynn4j4d+VLhzRp0HsXVG1aiQUxtMwzJxzmpW3JWN4aEg/O7/evFZYy4uyKNTKcGYH1EDj2QNTB2EV5bE8X8fq6C4Oan3yuN2ubldVTfgqL+96VL+iG8zE54jfyxdhSnuxknlusxU0vXiIYgE4o5rZXDYx0cBDQUtrBSpC9OLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803837; c=relaxed/simple;
	bh=noXEukVCxN2BJIzq8A3kaF1KAlLMkEVo2JVglrNIcgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opmdmQUMpRwiffgiYgjJXzDX8mJXzYhKcxj5KymtaJ9A9WNoDVL8yUKEfIDofwGq3B8bi5O/NHFZjwI3aesmw9SgAuxyQdi15e6tMOsaT8L+a+ZoeYdpQmiozLTapX7Y6su6gW9Kpoq/NlxTLAl90f7DlHkKNpEpee/2snjbQ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/cv/Z8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/cv/Z8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAF5C2BBFC;
	Wed, 19 Jun 2024 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803837;
	bh=noXEukVCxN2BJIzq8A3kaF1KAlLMkEVo2JVglrNIcgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/cv/Z8zPppbDy8sa4Kqq7DqIhC5L7W97EQ6xXGno+idIwdJqu1Au/8HXq0maG0Li
	 O5H62RrGLGcBOQW7jfvxhVSh9zm+SZqHQK1NX/GqJq8+r76+mq5tklDORglTC6CcIH
	 lzfxo7HZGCKVpHnrImHuTKh2GXCAlInQP0xyhXTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/217] NFSv4.1 enforce rootpath check in fs_location query
Date: Wed, 19 Jun 2024 14:56:03 +0200
Message-ID: <20240619125601.320394777@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 28568c906c1bb5f7560e18082ed7d6295860f1c2 ]

In commit 4ca9f31a2be66 ("NFSv4.1 test and add 4.1 trunking transport"),
we introduce the ability to query the NFS server for possible trunking
locations of the existing filesystem. However, we never checked the
returned file system path for these alternative locations. According
to the RFC, the server can say that the filesystem currently known
under "fs_root" of fs_location also resides under these server
locations under the following "rootpath" pathname. The client cannot
handle trunking a filesystem that reside under different location
under different paths other than what the main path is. This patch
enforces the check that fs_root path and rootpath path in fs_location
reply is the same.

Fixes: 4ca9f31a2be6 ("NFSv4.1 test and add 4.1 trunking transport")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bda3050817c90..ec641a8f6604b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4009,6 +4009,23 @@ static void test_fs_location_for_trunking(struct nfs4_fs_location *location,
 	}
 }
 
+static bool _is_same_nfs4_pathname(struct nfs4_pathname *path1,
+				   struct nfs4_pathname *path2)
+{
+	int i;
+
+	if (path1->ncomponents != path2->ncomponents)
+		return false;
+	for (i = 0; i < path1->ncomponents; i++) {
+		if (path1->components[i].len != path2->components[i].len)
+			return false;
+		if (memcmp(path1->components[i].data, path2->components[i].data,
+				path1->components[i].len))
+			return false;
+	}
+	return true;
+}
+
 static int _nfs4_discover_trunking(struct nfs_server *server,
 				   struct nfs_fh *fhandle)
 {
@@ -4042,9 +4059,13 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 	if (status)
 		goto out_free_3;
 
-	for (i = 0; i < locations->nlocations; i++)
+	for (i = 0; i < locations->nlocations; i++) {
+		if (!_is_same_nfs4_pathname(&locations->fs_path,
+					&locations->locations[i].rootpath))
+			continue;
 		test_fs_location_for_trunking(&locations->locations[i], clp,
 					      server);
+	}
 out_free_3:
 	kfree(locations->fattr);
 out_free_2:
-- 
2.43.0



