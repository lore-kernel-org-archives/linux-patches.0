Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E41C6F63;
	Tue, 27 Aug 2024 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770982; cv=none; b=X9GjxFgf7gfnUHbjv2qzZLqtgrZWf+WDBQEPXbCXmtb4bXi7musrRKAReEXJuogLGnv647AG1a+O3Yx6S6AGlNQtZ3gdbKiToMCUi9iXbHPEtTf0ySsh3e9SrdkdOEO8AxgQMX0QC4vpsESncMymFSoZa7E4f7Z6q3aAEaHvBck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770982; c=relaxed/simple;
	bh=4pv8iWytCUa8WNgE470Bva0dHA7skyl1dCSOkhUxbV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I92Rc5Xjq7fkdhBh29RSwOVK9lOZVTDAH/AMHDypJT0E9g6XECuKWvasJUinqggrFHh4KtDwe9J+gOSsV9thsoZiQTTVytZ6AsGGNrc2IpK6u1uFP9JQG7dtq7Bsr/o1nOY0bE9iCwlZPI5L9EP408JEo7ZgfYsn0gqw+U55ouE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruiiFkG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruiiFkG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9372CC61049;
	Tue, 27 Aug 2024 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770982;
	bh=4pv8iWytCUa8WNgE470Bva0dHA7skyl1dCSOkhUxbV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruiiFkG40LH8XVnD6szOn2uxGHTUmT0OR+2Rh9hJlmiWh1Oz0DDebOS81G91fR1au
	 Ouwrsfg8Txhpq2dRZ0rS1ZSDoNUUtCZofm04qNowXOrmMo16Aftuf4tLHKCx5C/voc
	 PyhDwvUEJkXaslozP08wnKDwczPve+j2A5jOGgEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.10 051/273] selinux: fix potential counting error in avc_add_xperms_decision()
Date: Tue, 27 Aug 2024 16:36:15 +0200
Message-ID: <20240827143835.341307296@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 379d9af3f3da2da1bbfa67baf1820c72a080d1f1 upstream.

The count increases only when a node is successfully added to
the linked list.

Cc: stable@vger.kernel.org
Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -330,12 +330,12 @@ static int avc_add_xperms_decision(struc
 {
 	struct avc_xperms_decision_node *dest_xpd;
 
-	node->ae.xp_node->xp.len++;
 	dest_xpd = avc_xperms_decision_alloc(src->used);
 	if (!dest_xpd)
 		return -ENOMEM;
 	avc_copy_xperms_decision(&dest_xpd->xpd, src);
 	list_add(&dest_xpd->xpd_list, &node->ae.xp_node->xpd_head);
+	node->ae.xp_node->xp.len++;
 	return 0;
 }
 


