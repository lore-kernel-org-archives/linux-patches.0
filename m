Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C271C5F18;
	Wed, 19 Feb 2025 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954103; cv=none; b=WnGvKNlBsI2ZdRP/RY+sPIyQUAOb2uZMh/fHp7mT4WXGPl/4zwvro+BotYUi1KRt+G/dwX/pyc8d4M33Qk6kxM/iSYl11Wn8zpnu8y3gan0JxIh7Gh8y/WnC4YyHxl9kYu+xhtW6BHnWXswctsW32xG2SeldCtutrRKawt/Mdww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954103; c=relaxed/simple;
	bh=kFeryQseXCwANRYhq+6Z+5rJcQ3yB6X261s9FZF8EaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Loy6Ss9mfHnvt9C/4dPIU8h1WIMh1Zn8z8MEEJMHsqHlntxErCBKl8TqouTXLSfmrdIoNbyBZA4nNjRKiTFNMBwr8ggMcXlGi/rp7YLxfAmQjzCoYcXJMKhZYGD4ZAN63ol+xq+bfoN/YNB79VWEYZyXVR1wgaE+dYr03XjkiVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ul6EAkJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ul6EAkJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F3DC4CED1;
	Wed, 19 Feb 2025 08:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954103;
	bh=kFeryQseXCwANRYhq+6Z+5rJcQ3yB6X261s9FZF8EaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul6EAkJCtr34aXJ90ZCPGbaTmbBOnIJf8ofcvSX8bGI1eaD1aLftZCC4rJUWJAs/l
	 J0do4mZl1Mz8ckyDhUjJEDIbz3dPAvSPBJaN5SAtvgLM0yvBgFCnPO1lo10DJa84w6
	 fqYKmj3PzzEVqapDKVgLz/jBGW/mqhRZfoKXGZJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 097/274] NFS: Fix potential buffer overflowin nfs_sysfs_link_rpc_client()
Date: Wed, 19 Feb 2025 09:25:51 +0100
Message-ID: <20250219082613.419037332@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 49fd4e34751e90e6df009b70cd0659dc839e7ca8 ]

name is char[64] where the size of clnt->cl_program->name remains
unknown. Invoking strcat() directly will also lead to potential buffer
overflow. Change them to strscpy() and strncat() to fix potential
issues.

Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/sysfs.c b/fs/nfs/sysfs.c
index bf378ecd5d9fd..7b59a40d40c06 100644
--- a/fs/nfs/sysfs.c
+++ b/fs/nfs/sysfs.c
@@ -280,9 +280,9 @@ void nfs_sysfs_link_rpc_client(struct nfs_server *server,
 	char name[RPC_CLIENT_NAME_SIZE];
 	int ret;
 
-	strcpy(name, clnt->cl_program->name);
-	strcat(name, uniq ? uniq : "");
-	strcat(name, "_client");
+	strscpy(name, clnt->cl_program->name, sizeof(name));
+	strncat(name, uniq ? uniq : "", sizeof(name) - strlen(name) - 1);
+	strncat(name, "_client", sizeof(name) - strlen(name) - 1);
 
 	ret = sysfs_create_link_nowarn(&server->kobj,
 						&clnt->cl_sysfs->kobject, name);
-- 
2.39.5



