Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0439C13AC2;
	Sat,  3 Feb 2024 04:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933749; cv=none; b=KnAfdth+iBCafaHt1bqp0XxlH2i+kAxyHna7gKaOyNUQTZbF3pbA8LdVWMOiXyneIwO3vqLteRdMLEDZa0jC3cDCj1DnLgmkZ0bXrY6bTrwtB//w7hG8XDlx7XdgXVp+iTbimvtNBQGKmz38GrnJkoYif9KVj1+xhTKPZ8xWa/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933749; c=relaxed/simple;
	bh=XxFxIk2pXdImkhwoTEFaLXlxs4wouqvMwZ27itLSI/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJJry+0EIFvmVhpfVyx/NdTN94N++GglTyOvKhaffkbRxcaT5hQvtM9Ifa/x5EFA1Tb0W6/6Qg1LVyDYlAgGbfrmNyJHEmkSquZAqPMewIhfqan4j9EThIvdCc/gsighTYykxZmS+m3keXmcNlPgtoabROoU259bTWLERagiKqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2Pc62Bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2Pc62Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4EBC43390;
	Sat,  3 Feb 2024 04:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933748;
	bh=XxFxIk2pXdImkhwoTEFaLXlxs4wouqvMwZ27itLSI/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2Pc62BcA2hGQr7nt885bWLHR1VpDYfL/vlyuLTMIVaa4I6zBQnwxii9i0bIwAMfj
	 fcwCXN6gXSQKkhPCmAxsnhyY0PxercABieAZpYhWQrzE+Dk9ioggQVtOzQrAV6b/4G
	 /svVzZPmySu2sQis1u0f8tYhTsz2u5e9wNbkPi70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 043/353] afs: fix the usage of read_seqbegin_or_lock() in afs_lookup_volume_rcu()
Date: Fri,  2 Feb 2024 20:02:41 -0800
Message-ID: <20240203035405.170465083@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



