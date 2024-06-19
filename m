Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D9282871;
	Wed, 19 Jun 2024 13:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802258; cv=none; b=COsU4523DjjX0SZPNcpCwZhgyI5obZRKCM9jIDbqQUfOEsnLl6Rhi56pBeyAZtuQGmnvNyovrfO2JzMX0400ti1bD1WTiCvNKPuP/InxFDgE/yKMtNoFp3In57O1qIbsmy5HyMZrHRqlOrxRBzK2b92Wtzs3ZICKIXZd6OyYsac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802258; c=relaxed/simple;
	bh=Rmdr5F59EYzK5gBNEpzEyM4Qa6Rh/wckkcuL4ccjDIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g87TvgW23psDB4jdfO8DfXvTVU83hq/c1FF31Rb7h8p4gvPA/c1FO4KvZEsIH8A2/CZcoQbdTf+c25BrW1U7BsjkdGdgubLI6wOAknNlTH5SKGMfkSP7APV6jCtNsm9asxNV53ZexUwrF7lW3fwEqHBV9SrE8sYfTg9x36p2ysI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjMTtCGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjMTtCGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD475C2BBFC;
	Wed, 19 Jun 2024 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802258;
	bh=Rmdr5F59EYzK5gBNEpzEyM4Qa6Rh/wckkcuL4ccjDIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjMTtCGvN1ThbuiTOcMTbJyEmR8QIktGEcU3xCJGpoydiNjAVxPLoeDdNkT5C+okI
	 4qp0x8zfml4ZEs8BDs5Y+8I75o9zMhFEeNEaPUisxUauEIJRdaQ1qFYqB3lZqEIc1o
	 uOaayW4JDYN1/dxegwp2IGa4UWqWrwCngtIHL3+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/267] NFSv4.1 enforce rootpath check in fs_location query
Date: Wed, 19 Jun 2024 14:54:29 +0200
Message-ID: <20240619125610.879770582@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 41b7eafbd9287..f0953200acd08 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4003,6 +4003,23 @@ static void test_fs_location_for_trunking(struct nfs4_fs_location *location,
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
@@ -4036,9 +4053,13 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
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



