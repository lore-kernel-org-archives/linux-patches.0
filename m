Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825993D9027;
	Tue, 21 Jul 2026 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653570; cv=none; b=gd+NNbthWXHU5QuHB5YRPjfj0DRyyZT7hPuDCjcG2oMEIR+FMn+MQxsJ0/B/KrXff8YkkvWFPOhyF3MoGrCxHXNaZbDH+cfUELBjYDbUM8cjeILTZqq0w6YBFxdf2MChMK/ZXjtSxsySXfZr9aOPIsKQYg2bBga7FDFvltG11mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653570; c=relaxed/simple;
	bh=diVygBLywkfR6LV/C0Qf6UZZpOC4ZqZnnSxqxo1zrYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCtvNWNV6K5g5Jr5tTIlGb6gG5tOU1nmfV4BPxKi+dtIqzKJSWHw7Og3kMW8m6FWWZSeGNm5yvSRdiVMy9YUrBq8FfIt9ZPCTq7BRe1BOSBOLOHIfNv4B6BJPXA3w0bfaV4MO4CsGf/4000I3VrRkUfGfyNE8NPQaG7t7np05Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMv7PTTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMv7PTTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95681F00A3A;
	Tue, 21 Jul 2026 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653565;
	bh=i8pTF79tL9emy4KXgY/I1gWyE/y59UfF0b/sA0q56RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMv7PTTB3q0s5krPVtr358nLsJXZFU30NuLe1plz9EnzKlPrEQdPGKidbEFIEXCv5
	 a5aHkqG7CoZ31+DpWYh0bZxoiYVqAAhKAqB/6sWtDN4XGToOrhZ9LTOJe9ftV0bKl6
	 RQhfIqxxel6AI3vy3D0FmniOibkj16gcgwA4WuOo=
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
Subject: [PATCH 7.1 1374/2077] afs: use kvfree() to free memory allocated by kvcalloc()
Date: Tue, 21 Jul 2026 17:17:27 +0200
Message-ID: <20260721152625.222547886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c0dbbc6d3716e0..20801b29521d1e 100644
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



