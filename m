Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209591;
	b=Fy+kLV4dYdurwXhGx/gm0DovSa9LJD6Xh8/yt7Cd0LyMEVvmd3mTxtJKXrnpo74A7yD6
	 4gjdvuWwSHD0DWeiC0hco+3p4Ah9c8S/By4OyPMjklFcg62DzsBLu22BVRR2J504FMxWr
	 kjdATyRjkaC6wCfCRYHEDCmXVNLfd9ckAquXtA/Dxnalk5qSnEf433a0nlig5BdT8WTxD
	 Kqw/zBmqWthYniQIhqN8JL/rugSoDnUDgFJD4G0HWH1Kj1jeLQlt+DzlRyDuvAWASJumK
	 0mk8S8eBCGd+xoR2ZlWiNKSMsTnK44aS9HCPwQ7WbUZ9nxQXWUdo/oyW7osHZZ5dg5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8YjlawSs8GnVn7P0JDYBLi/hOHo4FxtE3meKxgoTI6E=;
	b=D6zxnnmWEpW3sh06LbknDKwmqB9l3cRcCsV613+sm5kqEzLmIe13E0YYBaH1cBYNtHXv
	 O6B2H/pNSbopcv6FafQD4OjfY9oQNKV4qFPAVVQkmFjJc0ttRcxhsqVKbt96kig08nxKC
	 t+xKqZa6O1anXBOSVQCew/COjpS8tif6ayvXC5LUOZ5AwNBd+FLu6+ywX2eAvvO4SOIWR
	 Iw2tJpvXpA2ZuL/l6+yZDVk/DmVUBGgGdyqtdwY09aZBjco1oUJFt49UAZayybInZekp5
	 WOo/gduoxCRw3DoZz8UN6D2zEMioxvDy412+rXtlciEMOJnHmOU3c9tulB+Nnsyr0bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHE8ckeu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B3606A31C;
	Wed, 28 Oct 2026 17:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHE8ckeu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9EC1F01825;
	Wed, 28 Oct 2026 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209591;
	bh=8YjlawSs8GnVn7P0JDYBLi/hOHo4FxtE3meKxgoTI6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHE8ckeubpwcmXdOuESm4RccBda4VQ0MdlRIKmlLho9NuOml6aeUHyd7XdbBi7BJt
	 wxoU24dx0z4x9ZxfPl+6KUbcdo+cCyBOgB5R/icRUYQyL1PqyWhTeDFXy/meMpJunE
	 m4cLg/Yf2bl2wObHMp2iCASy38+ZcohtB6Strago=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/109] eventfs: fix SRCU read lock leak in eventfs_iterate()
Date: Wed, 28 Oct 2026 17:59:45 +0100
Message-ID: <20261028165942.393568245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

Commit 2b80707b9e27 ("eventfs: Use children field for rcu head and add
memory barriers") added an early bail out to the ei->children loop:

	smp_rmb();
	if (ei->is_freed)
		return -EINVAL;

Upstream wraps eventfs_iterate() in guard(srcu)(&eventfs_srcu), so that
return still drops the read lock. The 6.18.y backport instead brackets the
function with srcu_read_lock() and a shared "out" label that calls
srcu_read_unlock(), so this path returns while still holding eventfs_srcu
for reading.

The unbalanced reader prevents the grace period from ever completing, so
the call_srcu() callback queued by free_ei() never runs and the
eventfs_inode is leaked. Every readdir that races with removal adds
another reader.

Set ret and jump to "out" like the other bail out paths in this function
do.

Fixes: 2b80707b9e27 ("eventfs: Use children field for rcu head and add memory barriers")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index a992c2919f79a..e060dfe7cdac5 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -678,8 +678,10 @@ static int eventfs_iterate(struct file *file, struct dir_context *ctx)
 		 * Matches the smp_wmb() in free_ei()
 		 */
 		smp_rmb();
-		if (ei->is_freed)
-			return -EINVAL;
+		if (ei->is_freed) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (c > 0) {
 			c--;
-- 
2.53.0



