Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A90101CE;
	Sat,  3 Feb 2024 04:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933333; cv=none; b=Y2YRwren59y77SPxQw5lILeFEpwdSKWhX8qYLAghflNtKk/1bXpo8Vz1Ho8/b08WfmVHO9zGvjt0TEMC2cfvf/5i50TQjSoJnL99r3Q6yLrS6DYNEUhmsL+VUI6LzZCTee2IasIME2C5QzwcAtm/mv1co1rIGPjuj9Qfq5+MLw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933333; c=relaxed/simple;
	bh=JdaGP105BgIALyVTcvVA29I+A9lLy2E9FgxY65mf8yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPDSr89h3bg3oYxEx3joKp3itmKHljOszGNbdjgap1cuHnlwK6zxTfnpXPB/4PvyiSh02/oC860iTtJqSVdYn3UvqgwdlsUYfOSG7kJRECj/6K3Z72CubyL34fpppEUDeJs9FhKdmKqOnTDume8CwdGc4QIyPF041x3YrmgKJaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KSmJ17e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KSmJ17e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407FFC43394;
	Sat,  3 Feb 2024 04:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933333;
	bh=JdaGP105BgIALyVTcvVA29I+A9lLy2E9FgxY65mf8yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KSmJ17ebulUChj0iCJdNjP+lJIZgg9fkn8G0vooFjSHL/id5JQm/Cm96ezdawanQ
	 gwFVy3Mz+yWkIyUCuRlFd5EBSzrKW9wR9zyktIPPHUI6h0OZOm93WQvGS95BqMbdCg
	 Pvdp2LulONGXyvlAnIh9eRRnMA1LM/s1ixzJQZrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/219] afs: fix the usage of read_seqbegin_or_lock() in afs_lookup_volume_rcu()
Date: Fri,  2 Feb 2024 20:03:24 -0800
Message-ID: <20240203035320.720053637@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a484fa642808..90f9b2a46ff4 100644
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



