Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5707B3EA;
	Wed, 21 Feb 2024 13:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522506; cv=none; b=S9hpz+3h9BGfJSW3xZ2Tt/FEV0x7kqmtSH42ulu8baSf5EzF0WQZxYf4XwptBfPzfTWVj8zHyCVPQcigTPaO+oLrWYwDqjH+pijlcVbRh3VwIOIhng2qycCA5pG2qLiuk8BKv6/ZkgZ1denMvA2YJ5H+lWQ4a5wXIMhLSF5pJ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522506; c=relaxed/simple;
	bh=XJ6iT5fpnVqc03g48RUfmksKJP/n6Xyq0EUvfd/xEQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPTSXRRgyB0pX/I/V/oTZHGdi4vGdulSQbJNP7qgdTov3hZmJKkB2btdJERd2yZLeofCRWUeMFeZpHAp3+Vw013RGeI3W/6Uwhlm/QrXZc9wImlwbUHTPA42Y38PQMepn/ERrYWR4a5PQ0tlH1QK/FBj3o9Inr93DsZWhw0aRjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYxP2mnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYxP2mnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5825C433B1;
	Wed, 21 Feb 2024 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522506;
	bh=XJ6iT5fpnVqc03g48RUfmksKJP/n6Xyq0EUvfd/xEQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYxP2mnpACqHIqCWSerifbpGps/khuyKXSN3cD3RdPRHTVpR3VWIb/uNFR/TAp12I
	 ibXetR8Y7IX4A5SHeUelsPhUHq/5bjBahkka1qEzPe0z2O9XuwUdI+UMdiyY88teWR
	 5D31i3coPZ5attY2OiwvePD7Lq8P/IbAFuhCI3kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/476] afs: fix the usage of read_seqbegin_or_lock() in afs_lookup_volume_rcu()
Date: Wed, 21 Feb 2024 14:03:23 +0100
Message-ID: <20240221130013.559921767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 4121b4337146b64560d1e46ebec77196d9287802 ]

David Howells says:

 (2) afs_lookup_volume_rcu().

     There can be a lot of volumes known by a system.  A thousand would
     require a 10-step walk and this is drivable by remote operation, so I
     think this should probably take a lock on the second pass too.

Make the "seq" counter odd on the 2nd pass, otherwise read_seqbegin_or_lock()
never takes the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20231130115606.GA21571@redhat.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 1b4d5809808d..e0f5dcffe4e3 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -110,13 +110,14 @@ static struct afs_volume *afs_lookup_volume_rcu(struct afs_cell *cell,
 {
 	struct afs_volume *volume = NULL;
 	struct rb_node *p;
-	int seq = 0;
+	int seq = 1;
 
 	do {
 		/* Unfortunately, rbtree walking doesn't give reliable results
 		 * under just the RCU read lock, so we have to check for
 		 * changes.
 		 */
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&cell->volume_lock, &seq);
 
 		p = rcu_dereference_raw(cell->volumes.rb_node);
-- 
2.43.0



