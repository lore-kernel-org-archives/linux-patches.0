Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F6F1DFE22;
	Wed, 17 Sep 2025 12:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112606; cv=none; b=FhWbRF6OBrMPBbXOJHukR2qIgtG2KDGs50dH98pdvgfNzOoJn/y3e3A8B974XAbOd4uFfjvYzbgV3o9Oa1KmdvAQ/+AWkP2etGSOghWxP62E7q07Jj7Y7JTPy/5OpRLYUsksYGGzZ/KCh1n9BH9lq4c/GUOuBd8koOTUUfLoXrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112606; c=relaxed/simple;
	bh=bSMsDYPjCSV4BPuXdHhZn2ya7VqKnzMTPm2Dsy67Uno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH56B1sn6k9qdMl2cu+WSJKmrSeQ80Rsro5VSAOPDkS4/wuNpV04cDdkX7E/dPKgc7eQnITGnh6VVbaE6uJ5GlUg0oA5AfNlyc+KThOwUeNGA9BMkhL2f65IWdm6Snz8v/PtHdg+mX+1zSfvccwiC8oQ1SJIHjvIIWPN2y+TtFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkhVtup6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkhVtup6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07156C4CEF5;
	Wed, 17 Sep 2025 12:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112606;
	bh=bSMsDYPjCSV4BPuXdHhZn2ya7VqKnzMTPm2Dsy67Uno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkhVtup6rEXjwR8uLr6QLTAblVrhtHPrsbWGBWuLUKv7obeloyDgP7DlTfUmoVKrK
	 GY5DTCLWu75otBLsMWgI3Xc/BgGH/QmI6AQK+yq10owSxNqePYJLNZ1mzVxN4Yoj9k
	 QUPU5EmA72vk/IWP4/nSDPMNnF7I7wvQbpiD48aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 022/189] NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set
Date: Wed, 17 Sep 2025 14:32:12 +0200
Message-ID: <20250917123352.397439439@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dd5a8621b886b02f8341c5d4ea68eb2c552ebd3e ]

_nfs4_server_capabilities() is expected to clear any flags that are not
supported by the server.

Fixes: 8a59bb93b7e3 ("NFSv4 store server support for fs_location attribute")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index fc86c75372b94..ccd97dcf115f9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4007,8 +4007,9 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 				     res.attr_bitmask[2];
 		}
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
-		server->caps &= ~(NFS_CAP_ACLS | NFS_CAP_HARDLINKS |
-				  NFS_CAP_SYMLINKS| NFS_CAP_SECURITY_LABEL);
+		server->caps &=
+			~(NFS_CAP_ACLS | NFS_CAP_HARDLINKS | NFS_CAP_SYMLINKS |
+			  NFS_CAP_SECURITY_LABEL | NFS_CAP_FS_LOCATIONS);
 		server->fattr_valid = NFS_ATTR_FATTR_V4;
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL &&
 				res.acl_bitmask & ACL4_SUPPORT_ALLOW_ACL)
-- 
2.51.0



