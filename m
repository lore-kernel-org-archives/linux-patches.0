Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F7C356746;
	Tue, 21 Jul 2026 19:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663198; cv=none; b=TZZOHvs1OUYh4drgWxGoefUO+lL3/Vhvo5aH3Clh9DaUjR3Ib6WSGxmzqPyvOy/0TVAuwodtYr2+flvDW+ULs3vwTi5p89p1UXbPZApmpCK+sY/C/qHi9+x/ymWEW5taKF4CVMQW8CmTrpD6aBl3pux4GGjYVACUOb9AtxMPf2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663198; c=relaxed/simple;
	bh=/C9BOB9dnKaCugf69zgUU3wSVHi78uyZFbz/aTxBNO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzCbNRxsiTY3/zfMFn8Fbj9SyUyfcuWxW+RL1K/e4uCNi8X5nIu7u642kT2c2qMEtSvwkeMa+N1x3Rzv33ZzaGnMCONuv8UuqgD7Jja3EdKks74tE4x5rj/SsIprHiNdBJEsJllpMQGRLjuO5RrRtbJvduW2vZcEP61DDJ3fX64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELW2Oo3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELW2Oo3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68C61F000E9;
	Tue, 21 Jul 2026 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663197;
	bh=9f8Cm5klhDCB9zHVmwp97OW3HUiBK0fNxiNt89E/owg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELW2Oo3iB0ShtOte73un9BebcKEq8ztX/v/nqUoA4veFxrFzatTu9NEdg96PynkA2
	 12HB95M1d9L99BT/YjHBaSL1R1PlZvNTSAY9hrqQtLMUlVNoIVJ8IgzptqD/ctPlE/
	 zWNJXaCOh8Lrev8fNKy5DQNL3uVNljviM99oSgOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	David Howells <dhowells@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0730/1276] afs: Remove erroneous seq |= 1 in volume lookup loop
Date: Tue, 21 Jul 2026 17:19:33 +0200
Message-ID: <20260721152502.419962211@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit a58edda50a3ec08e6adac1d04dc3e488494e412d ]

The `seq |= 1` operation in the volume lookup loop is incorrect because:
seq is already incremented at start, making it odd in next iteration
which triggers lock, but The `|= 1` operation causes seq to be even
and unintended lockless operation

Remove this erroneous operation to maintain proper lock sequencing.

Fixes: 32222f09782f ("afs: Apply server breaks to mmap'd files in the call processor")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-9-dhowells@redhat.com
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 99b2c8172021a2..462b10fa46e1aa 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -140,7 +140,6 @@ static struct afs_volume *afs_lookup_volume_rcu(struct afs_cell *cell,
 			break;
 		if (!need_seqretry(&cell->volume_lock, seq))
 			break;
-		seq |= 1; /* Want a lock next time */
 	}
 
 	done_seqretry(&cell->volume_lock, seq);
-- 
2.53.0



