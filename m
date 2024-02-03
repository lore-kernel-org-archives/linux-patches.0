Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0A3FBF2;
	Sat,  3 Feb 2024 04:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933511; cv=none; b=jSFSZeLWfZQfPYI+OyEqt47D2kn3sAKGuep0fOdtqWbVsKr0enEEwFR/8K06nli/BZVAFQar/x2RGcWlimEzMUEYlQy3Tqd4MnDBVIPVOOb4CruO54Ubyd3oKzZcTrO/A0wen45VpMep0TxKgxAPlY32AH4x6egrcg/9TU3igIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933511; c=relaxed/simple;
	bh=ck9X6CuWtItL+1gMrn+Qcy+1H93JIf7m63831EoFgAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avdp4nSeOYpZd+JYCND23B/owI0YTchp+EYD4hR95lL10GoPP9DwuVEceqW6RP97atXWQvMqxffwtizTHazCd3hwfRXIdi2z1YkQ8KPjCJfBwm1Gj+CmorJWm7iHlImwScmCKIm8tw1TxsjDi9ug9qGKxGrzvaH7RCboZjAf80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkRi32sQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkRi32sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA096C433F1;
	Sat,  3 Feb 2024 04:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933510;
	bh=ck9X6CuWtItL+1gMrn+Qcy+1H93JIf7m63831EoFgAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkRi32sQF143wSPZcpeKOGfxG+Lkmx+1OICLbNYk1V++r3zU5qB5DDhaftjH/PGlh
	 ReMejc5gOiH4wCOpo2VVPrJcNaYao7MauigGSMIhLZMwfMcCKWoe9HxWh7aHcyfNNA
	 UjYMwZ5Laojc2N2uHDC1gpVF78Qx9BURqPYuP1WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/322] afs: fix the usage of read_seqbegin_or_lock() in afs_lookup_volume_rcu()
Date: Fri,  2 Feb 2024 20:02:16 -0800
Message-ID: <20240203035400.346869940@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



