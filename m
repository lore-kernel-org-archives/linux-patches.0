Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F190718454D;
	Mon, 12 Aug 2024 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479494; cv=none; b=OSQnqryuShtrWmZ6UVnhKfV6yPVBZeRo/ZuIoBuO3j5ZQ2U0rU1ZpZKxPPFW9lr+6YC/49gjSUOPFREByi8tzNEJPFhPZ4sSNpSmEtAx5IkNZVzkXqUpcoOM/Be4qzHkkrmZYQmkoqQm33crNah6qfRUVPqaYgB0uveqQHDOahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479494; c=relaxed/simple;
	bh=prnFRAPI5e48lw1aj+cqDQLbqabaSoO6FoLVk+NIc7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ky4K4xCd+1oTTRS/uTFsc7IC5ANS1gHN0dUeCBXjuq7ItyLurbIBzJa/pmmbVEaGLB2rH/X3SorTHsbfUgnAiDbUzt7TAXeCkNjY3m8vCBWj5fQrRj7jnpkHUO2wBXNrjjQPtGUUlOXa4jUfovMC2gJP1QmyakUBeEtDS6ArlqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdXItE8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdXItE8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74663C32782;
	Mon, 12 Aug 2024 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479493;
	bh=prnFRAPI5e48lw1aj+cqDQLbqabaSoO6FoLVk+NIc7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdXItE8ZAUCh88an4cCZtDYw77dvudA6DTByq6hCFyJJoRvc3qfuP+VqEPliDS3rr
	 kwnK1ukYEi8Z3KnaOd8t0H+l8IGW5g0mSvDkREiqKQPCGNpj41Gyp7HOw8vvOAVOBG
	 I8ILxGpznW2/SgAJ6aNTZnJTCKV89WC2RVszzuIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Gleb Korobeynikov <gkorobeynikov@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/189] cifs: cifs_inval_name_dfs_link_error: correct the check for fullpath
Date: Mon, 12 Aug 2024 18:02:41 +0200
Message-ID: <20240812160136.182978947@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Gleb Korobeynikov <gkorobeynikov@astralinux.ru>

[ Upstream commit 36bb22a08a69d9984a8399c07310d18b115eae20 ]

Replace the always-true check tcon->origin_fullpath with
check of server->leaf_fullpath

See https://bugzilla.kernel.org/show_bug.cgi?id=219083

The check of the new @tcon will always be true during mounting,
since @tcon->origin_fullpath will only be set after the tree is
connected to the latest common resource, as well as checking if
the prefix paths from it are fully accessible.

Fixes: 3ae872de4107 ("smb: client: fix shared DFS root mounts with different prefixes")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Gleb Korobeynikov <gkorobeynikov@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/misc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 07c468ddb88a8..65d4b72b4d51a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1288,6 +1288,7 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 				   const char *full_path,
 				   bool *islink)
 {
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_ses *ses = tcon->ses;
 	size_t len;
 	char *path;
@@ -1304,12 +1305,12 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 	    !is_tcon_dfs(tcon))
 		return 0;
 
-	spin_lock(&tcon->tc_lock);
-	if (!tcon->origin_fullpath) {
-		spin_unlock(&tcon->tc_lock);
+	spin_lock(&server->srv_lock);
+	if (!server->leaf_fullpath) {
+		spin_unlock(&server->srv_lock);
 		return 0;
 	}
-	spin_unlock(&tcon->tc_lock);
+	spin_unlock(&server->srv_lock);
 
 	/*
 	 * Slow path - tcon is DFS and @full_path has prefix path, so attempt
-- 
2.43.0



