Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66794582FC;
	Tue, 21 Jul 2026 22:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672135; cv=none; b=RKplSBfiJSaJk2HavEOejbPUGzXnEeqjpfNfOCcYtDBgl/twzdJtPV6Bqd7RSW9GNUS48NvHSZI10UlrsOINGHvetLi9N4Sxb8CRzyUIY4SCYHdGkiFOWlSGvE5hxJ9PHoDvd4Q8SpwfbSWnLAgQ++noCf67ANDcOvJjejrR9nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672135; c=relaxed/simple;
	bh=cwfLxyDosD9JzXQZ/K2l81rtC7I6EwyjDBnZBd7hIag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivmqQ0+xJcbe4wji+I0RNDHsQG2U/x8rc/yFxc7R25mye49thSuHEZkOAeX8/v1thtor4P/F5QYhoEoKiQUYKQ2HHwgs6ft3EyfcnTtdvMlQpcYf7PrnblUbwsES4T/u7mrEnMNhVAFA6ZZZNcT35jOssVW8YY4qtbM6zNHvHjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnYxVLwM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnYxVLwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DE91F000E9;
	Tue, 21 Jul 2026 22:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672134;
	bh=NUmM+zXFLyEuwFrk4r1DV5Lj0czzIspqY0kHaXjQdlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnYxVLwMLAZ8mhi78osfEow8ct7GiZpVXK1hhXRrv0cDxD9xT/fELQItorf+Pa2tm
	 TLOkJnRi93kmfMRz5ZG1HGk9akya8CSPN82+uF6G5is1bb0VEPoo3JXHmKwsgehxdR
	 PvVUudaPc1DEqcDifNTmYlz9BR/rUOuiR0FJc5ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/843] afs: Fix the volume AFS_VOLUME_RM_TREE is set on
Date: Tue, 21 Jul 2026 17:22:26 +0200
Message-ID: <20260721152417.525984100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 56b4e4b26f84411d880f968a539207b0a8889c8c ]

Fix afs_insert_volume_into_cell() to set AFS_VOLUME_RM_TREE on the volume
replaced, not the new volume, as it's now removed from the cell's volume
tree.  This will cause the old volume to be removed from the tree twice and
the new volume never to be removed.

Fixes: 9a6b294ab496 ("afs: Fix use-after-free due to get/remove race in volume tree")
Closes: https://sashiko.dev/#/patchset/20260618074903.2374756-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-21-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index a0c440324babac..cf0c267d4f52d7 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -38,7 +38,7 @@ static struct afs_volume *afs_insert_volume_into_cell(struct afs_cell *cell,
 				goto found;
 			}
 
-			set_bit(AFS_VOLUME_RM_TREE, &volume->flags);
+			set_bit(AFS_VOLUME_RM_TREE, &p->flags);
 			rb_replace_node_rcu(&p->cell_node, &volume->cell_node, &cell->volumes);
 		}
 	}
-- 
2.53.0



