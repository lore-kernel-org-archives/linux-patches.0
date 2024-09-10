Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70AC18F2F9;
	Tue, 10 Sep 2024 09:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961646; cv=none; b=syiO24eaJOuJT1bkZpZU9IdYrty/44n5tRqZPjYiTR+3GhLt7FUL6+UDdUnX3VF52joSyTcicGoCexC1DM5uaJysccq+hVnuwOXFZljmGQJpkyTt2XP718unMErpjjBeh4L3sA+D8HIvuMiiDIItnMaQKPgOaf6QchzmFp40LFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961646; c=relaxed/simple;
	bh=nGl+EPYMZJt4rXSrEpEQ3SSmQyk/6+oUDt9D6i7P9mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBV61QoSWV+IjkagaUqLL8svxrUUDjHR3Dk9N3OxLMdmxCyrQGYCBa7kYsVATQH+FBUqf4IPQUSKkSTh3OTol+dHjGz3WXFCxocCz8tGNBFVquaizug8pBAb1GjfkPZyk924syq2EFEbe/lysS/fD2GnC9p5NEfQRVhBb7FnCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4moKbzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4moKbzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47135C4CEC6;
	Tue, 10 Sep 2024 09:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961646;
	bh=nGl+EPYMZJt4rXSrEpEQ3SSmQyk/6+oUDt9D6i7P9mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4moKbzfk9wW9P+dlJ5Ym/ndmPLsx5efVbYFF8TELfPbLPyDTFqs06YHPxx3O7dlG
	 IZu7937acPBCQmxdRSDpKtdNb2L/xQiM4RpvYLPAIJ4C6KTRGRWRv+Xg9TozPvnjOV
	 RUujXLc3zDzNRdGWBcBjwa8wsCwPWUk2Ext+LqFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 133/375] fs: relax permissions for statmount()
Date: Tue, 10 Sep 2024 11:28:50 +0200
Message-ID: <20240910092626.903119072@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit f3107df39df123328a9d3c8f40c006834b37287d ]

It is sufficient to have capabilities in the owning user namespace of
the mount namespace to stat a mount regardless of whether it's reachable
or not.

Link: https://lore.kernel.org/r/bf5961d71ec479ba85806766b0d8d96043e67bba.1719243756.git.josef@toxicpanda.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 57311ecbdf5a..4494064205a6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4906,6 +4906,7 @@ static int copy_statmount_to_user(struct kstatmount *s)
 static int do_statmount(struct kstatmount *s)
 {
 	struct mount *m = real_mount(s->mnt);
+	struct mnt_namespace *ns = m->mnt_ns;
 	int err;
 
 	/*
@@ -4913,7 +4914,7 @@ static int do_statmount(struct kstatmount *s)
 	 * mounts to show users.
 	 */
 	if (!is_path_reachable(m, m->mnt.mnt_root, &s->root) &&
-	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
+	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	err = security_sb_statfs(s->mnt->mnt_root);
-- 
2.43.0



