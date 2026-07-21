Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60232415F19;
	Tue, 21 Jul 2026 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658062; cv=none; b=jZhi6w35sx7I545+nS9A0Bkd0ll8jwBmd0ttj0L/Tb9pXeWt8jGT4bUg0j8E4NzC7fX4zvZ0RCJiYqzfeNRC/+felVajPTX5+Zhy6QmUIl8p3qL6sud1A3kxgBZ0wgGNHV0lFiY3ZVPE7hx+eN/8XjWpf2VkNlApRswDkCNhYgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658062; c=relaxed/simple;
	bh=XhW5GrYXAJ8RVz92DtGv8C9RjgwgS0oxSaB3oAPwv3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b56I4borZP1QQqop5PXn2T+9IkOIUcUjyY+sx1NJoh30M3H/6aTyee+x4RgWRB399aSFpyXY6GU5OoLHyu38rOKeGSUQtJ1+wco38/RN3ycZS+eSna0/Sar4lo6t4Pi6aNytormzXvJNZ2U7OtmyclB4cIrOL6ilqd8RdZo3wr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saw6S4xE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saw6S4xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF2C1F000E9;
	Tue, 21 Jul 2026 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658061;
	bh=IftGqxYsmmMUcmpMU1wWweGv43PtEkyvuyNfly+bbOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saw6S4xEIvAtAWQejTolfL2NomyJ2Z8v1CobvF1Sc4RUAJLzMKba5kqwafHlqIIer
	 cGmC9h7MeT7yLS28d0jjv4VmhjYnNUVzNqx3E9Q3y8m77WkCLc/seyzKxXnuMcfdee
	 Owk1OZqrY59ehzm85ZkOdeoRhtNxwmrzgeZDqYUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1001/1611] afs: use kvfree() to free memory allocated by kvcalloc()
Date: Tue, 21 Jul 2026 17:18:37 +0200
Message-ID: <20260721152537.909623678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit cb39654926f8e7a08ecc1dcb3941628855275940 ]

op->more_files is allocated with kvcalloc() but released via
afs_put_operation(), which uses kfree() internally. This mismach prevents
the resource from being released properly and may lead to undefined
behavior.

Fix this by using kvfree() to free op->more_files to match its allocation
method.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-8-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_operation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index 8418813ee04339..ae0c9750c6b6be 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -348,7 +348,7 @@ int afs_put_operation(struct afs_operation *op)
 		for (i = 0; i < op->nr_files - 2; i++)
 			if (op->more_files[i].put_vnode)
 				iput(&op->more_files[i].vnode->netfs.inode);
-		kfree(op->more_files);
+		kvfree(op->more_files);
 	}
 
 	if (op->estate) {
-- 
2.53.0



