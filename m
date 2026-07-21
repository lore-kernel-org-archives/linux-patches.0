Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E73E3DD870;
	Tue, 21 Jul 2026 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658091; cv=none; b=OPrNzQYzhi9LUN30f52QYABx+oEVLmMNQ0IGuISTIUmHAySc0QjoN4IYayz8LSyJu5NhZJGzB80pDK/1mgsuljqh3KRZ3VryYLxEl757feipmKQJpxKAvgqY0/kx4JKNDkUkrojwS5t10AQTD5uEd5gzo1J0TmFZau2KYDIZs+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658091; c=relaxed/simple;
	bh=y/lyUQFxHOKWIEMR2dlzT9vo8neFYVKI+aHp8pRohm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmcuunCRC3usW1Ik5yPy2WeFTAXhhu6UTIGZEiVCUrPOA2YBq6c/zq4pwdk+kK6XLSfZSn07Q+AD1of2lJVRL/h4bemGE448b/cPIkC5wKFngMDr2HVmhcCeJvqTnnNoP8EuwmAp5lGLpB2dfV+9rLKz6+dc81JipmgaLU3j0S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfZclnTK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfZclnTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A763E1F00A3A;
	Tue, 21 Jul 2026 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658090;
	bh=rS40K0i5hBdMUrYB3sf92zBKYCDhgbe6TMxyOOWKfNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfZclnTKGtMoHfSxhNwU5Uwv7NmyaWd5VMVFxSEwSHIbDC4XwCZMALPLVaZWSPHIY
	 7MvMNPhuFd4BNe5nTOc8e3L/GO7sBY6yHJ/71PaT+UtNmWoO1FqdI6UP/2J1U0RcwT
	 XibHbYQqM2vr80BoM/UWeUH+a1B12XDNFVc3hFjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1011/1611] afs: Fix the volume AFS_VOLUME_RM_TREE is set on
Date: Tue, 21 Jul 2026 17:18:47 +0200
Message-ID: <20260721152538.135243712@linuxfoundation.org>
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
index 0efff3d251333e..e76995ab30f021 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -40,7 +40,7 @@ static struct afs_volume *afs_insert_volume_into_cell(struct afs_cell *cell,
 				goto found;
 			}
 
-			set_bit(AFS_VOLUME_RM_TREE, &volume->flags);
+			set_bit(AFS_VOLUME_RM_TREE, &p->flags);
 			rb_replace_node_rcu(&p->cell_node, &volume->cell_node, &cell->volumes);
 		}
 	}
-- 
2.53.0



