Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E4A16D9B8;
	Mon, 12 Aug 2024 16:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480345; cv=none; b=kpzf7EkLbziN8zpFRcs5nuI2uSg7VzsEw7XWYnu3Bw8m1Xwh20QFRcU61SymXJbTyyrMI/TaugGz03jRLUKpKMrg685/MnAmGd/9EXeElbIUqn6LYf5112YfUM268Tn4QsOjO/HSAtjo/bQajgTLX/EbYN0bmTBE4QkRSSilOy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480345; c=relaxed/simple;
	bh=nwN0YQzBYaVfIQFhJEblqE2kKPNRFayqkdMlQGzkbig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb+5JigemPMIwDP7rhOKYPnsiPXTm/E+Ie0qqd6r+rTYpY88zVwFh7s6v1jeH5J1gSQhWGNRWbd7wvTEBZTObMMay3yofVNdTkLatt7tayYTqp0DasVgcKFvWrS8SogWfa3eoyllBjLF3CYSItP6f516E8BFHIYzsdGdJz2PutQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/oeqLxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/oeqLxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184E8C32782;
	Mon, 12 Aug 2024 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480345;
	bh=nwN0YQzBYaVfIQFhJEblqE2kKPNRFayqkdMlQGzkbig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/oeqLxbXh0IlLbduDXSr8/dNO62KWlHfdVSdE9yoDZ9wqN1qqcSJ/LK4aERtZ1pW
	 g9LskQzYiItuc4bVod8OZbFderxLhrhG8fYmCrP8Hh0i6tNONOmD0/buMTQOQK8+sD
	 5iSzP4R47IC5KqGFsykDSvJ9BlDEmERH0zluQv34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Gleb Korobeynikov <gkorobeynikov@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 169/263] cifs: cifs_inval_name_dfs_link_error: correct the check for fullpath
Date: Mon, 12 Aug 2024 18:02:50 +0200
Message-ID: <20240812160153.017516350@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



