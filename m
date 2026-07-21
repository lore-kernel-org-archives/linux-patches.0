Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B7C415F15;
	Tue, 21 Jul 2026 19:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663336; cv=none; b=g4OXz9AzPsuS6xmj+O48pWoIzvQKfyGzjqAkGpsFeWsuD4Ub+zEmm4r3bJTSIF/5dKyv0Ivq4Y14P9w5ufqdesPDQRE0rKXu5MvEsNFrt6v0g1vnIH6RPcZvDO0FbDg8+XMH/iG7BJayFLOf4I511V6FFHzKoAFa9zu999gQe7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663336; c=relaxed/simple;
	bh=ZVDhTvRSHUCrxexqbkGT/f0YSqigKIZHKTr5LkO+7P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkOOPVeNF0/5ZnMAgaTQJ+WYmlORIjxrP42raPL7ckeTbwYBSZoyhtronN21QVX5nSDeir0O4ctEP6NIcqLge0pe0DBRwwebQTZl8fBVvcYBqA6tvcZ4niyew6InhRYnjijcAz+u8vNaIkfyt7XXVCkj9Ff/tZrtj1cDEcrGUx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSonSz3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSonSz3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336431F00A3A;
	Tue, 21 Jul 2026 19:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663334;
	bh=BMYkBR5v3spdcbFwX1FT0XIkP/z7jN/VtpQQQN15RNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSonSz3R6qZD1Iu6ZoJKYbvKnz96bEqDtHVtrf4Dwt+hdoONREB+nScYt84BJ4IH4
	 GITB6mqtXcHg++O661M4z+83wUzB80gJ31HjldYCHSpiT3W3Gp7mDYTBfuEMQ9I2Gw
	 ZFQLcU9WB2AnLgoiOJiHQt6Nh13CsiBFMYxARQNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0741/1276] afs: Fix the volume AFS_VOLUME_RM_TREE is set on
Date: Tue, 21 Jul 2026 17:19:44 +0200
Message-ID: <20260721152502.660932691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index af3a3f57c1b3f9..028dc954d0fe0f 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -39,7 +39,7 @@ static struct afs_volume *afs_insert_volume_into_cell(struct afs_cell *cell,
 				goto found;
 			}
 
-			set_bit(AFS_VOLUME_RM_TREE, &volume->flags);
+			set_bit(AFS_VOLUME_RM_TREE, &p->flags);
 			rb_replace_node_rcu(&p->cell_node, &volume->cell_node, &cell->volumes);
 		}
 	}
-- 
2.53.0



