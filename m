Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7E61CAA9C;
	Wed, 19 Feb 2025 08:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955555; cv=none; b=F+US9rcpFhE0Xwc7L5TBdR7xsi4wSWbDKBaHEMClcIDeHoTeS91f81Kya7KHq6/PE8JXxF8QD3//hKcMd3hXAPuCicuXuTzNWlvoRzZ4bFdVUJg61kOg5kSGpAO+qYUjOJLgzPSSQfNmvGm+wpy7VF2ZNUJoRT+aFCxkYjEeBl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955555; c=relaxed/simple;
	bh=1nXLPom4hN1UNMI6/RPZVKqkuMInlguXhJIRY7Ut0JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COMfJp6ervkdOyuORJfmrx82rEwHSDFjwmrlMlSSdhknxDestY8rMGKGk7gtgbEKhJvJ48gYFGGYUPhIJI09MczuCxMbOX4vA222U1vOFY4bUsTzTsL41ly3zUlbvdwPaG7hQvvVSrBZKZFL4ymvFyK0wJ4P2qKHfKF8Sojogt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okIBmcPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okIBmcPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F236C4CED1;
	Wed, 19 Feb 2025 08:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955554;
	bh=1nXLPom4hN1UNMI6/RPZVKqkuMInlguXhJIRY7Ut0JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okIBmcPPPNokQAOO0tSl5d8w7yWip7tq7M8KFNZsWT9rq0tXMMN1c8FPHJ8/yw+7X
	 YW3FG7xvXoeHpThurchVdHTsN6t7qmMtS8lXYrXKyk7lKnJiTUYCyPCjSLg+xz7lsc
	 m9ckFzqbHS5Od7RhbO+nRDOCR9mNCTyuIssZz6HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/152] NFS: Fix potential buffer overflowin nfs_sysfs_link_rpc_client()
Date: Wed, 19 Feb 2025 09:27:35 +0100
Message-ID: <20250219082551.706797101@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



