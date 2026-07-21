Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030F3161BF;
	Tue, 21 Jul 2026 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653709; cv=none; b=T2QkgwNGWOx+/UVT3GvOHFQIXel7C1ZcXuaXlQSdSbi1DPUH0delBLweFhohm1kyUsjWksZHK/VjHSqPDenJuduj7PvJxyDAnBLz3lTK+oe8BlaDvXDYRLAHYqXxvL1pHj97JvNI1tIszJ67htWOewqQyjpzv4JdWgNDZ4eeUBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653709; c=relaxed/simple;
	bh=Z0TyRaQWnJiPQ1Eg7FFvOeXjitCWeBGOcmSnU8zCz3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qALXniTrE3PGHISc700K5cFAmcybafMzCPqf27lmPKBYu2EhZRqZW789nYvmhx+ZLEb6hiUJpNF5HLO4pbEeyZq+zd4HvjO8k1g0Xe/g+UU5BvmzWwUrb1sZ/V+IESnims0xE+vchXIOXJD7Z2E8EoYqWgqyfh2nk134NOr4k88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEuXAdds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEuXAdds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FB81F000E9;
	Tue, 21 Jul 2026 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653708;
	bh=Z/AE6Gt6Z6DqQv4JR4vS1LUaxuyI4sP4ztL3DsGEVMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEuXAddsApVhmkD4JUNcK7uHhZFjXBLx3DNEcxpgLUTRkqT0TSy38X9A6MCOF418v
	 3UdRhgnYaGj/OKrptPvguTF7+jokyij1S8XvTrytINgR0bDCY9o7MOizlN+u7wfdNb
	 Lakf9OkmKlmv2JiRhpq4gSnRCDT5m+7kJAK/3fos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1386/2077] afs: Fix the volume AFS_VOLUME_RM_TREE is set on
Date: Tue, 21 Jul 2026 17:17:39 +0200
Message-ID: <20260721152625.506698976@linuxfoundation.org>
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
index 9ae5c8ad2e04b4..4f79d25ec37f4b 100644
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



