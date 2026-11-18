Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037363;
	b=Ca0nrkhdaqJjZBTxMtqNFf0OTGPUzzwH5bRk2nzyRsfSAciqt309GWrqvC6/hkQFKdyu
	 3o8cLrbqoyadLaqN/p9mj9Gi8jjnYkTRgghMR03/NXQ2fBNH0kHnCxaEPm47U77NPSAjA
	 nkIqApbgzFR4y4l2ZSJr2+rh3nkXF8jAqy+v73+Er05ezKFAkBYl7yOMsbNll4aaECL4Y
	 oLAdjPPtgiPskZ185rA6rCgikeso5T1ZAFlD2ruglHEZmCPOPiNwUgGLNkiR57HQv7cG+
	 +BWzWHYQEvnaec+qPBmaDhrmegoIMv4TTjAvRTJUT3l0FfUy8hO+zpHtFB0fPmd8tOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CvcxZzOpqDUiSJ8hSTD898IVxHw/YetJO5WygcLVfpM=;
	b=TH53EU0SzYb8vz7Xtphg6wzO7vuShogsc+Nia8RDGIwI405aGgaJyBASvXT77bFeH7y3
	 9FxbNE7zFhDB8DF7+2WINmxrx9/gLmyMVcl9tohA2Ie8gltxqiMJagpBSVGH1hsrW2PsJ
	 kBSfPJnSvKmzdNwYHOpRSktd5O07gwQFuO9+cw4QwOI3ONKzjK/AMbjOftIFrGxfE/zbj
	 GnANBRXh7naUVyf+6wvDr4cLkJQJquhlqcwyG0HsikDjMFuzNvlvnjZMQZzQ+M+u18mVN
	 l/nSLLz3rbB2Fj1Fx776xzlB3hYEB2fmLS0iq2X9ElRlxdShRQJs7Cfl/DCaXPdArLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjGPkIrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D7C606A32C;
	Wed, 18 Nov 2026 21:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjGPkIrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDFD1F000C4;
	Wed, 18 Nov 2026 21:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037363;
	bh=CvcxZzOpqDUiSJ8hSTD898IVxHw/YetJO5WygcLVfpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjGPkIrRfcDSf/5P16wydo3R4QuyaST0GJ+haJl6jjxFPGJQaeK5N9tjsCYKxX+XI
	 Q6sXk7acPLAIXn3zg3Q2151rVq9qzmpBWA0LonwlCOXV4eSEIVeBUkA49Gd6Z1Pbch
	 rSExHBwRPRfyqJCNSjKi2qMIQ6rElCaC+dKDdZSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yu Junzhe <junzheyu1@gmail.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1375/3318] jbd2: dont advance j_fc_off before the buffer is recorded
Date: Wed, 18 Nov 2026 15:33:17 +0100
Message-ID: <20261118150401.764271827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

commit 9f359c031885bb50add7d23c7a5a0e9755b134c9 upstream.

jbd2_fc_get_buf() increments journal->j_fc_off before jbd2_journal_bmap()
and __getblk() have had a chance to fail.  When either does, the slot
j_fc_wbuf[fc_off] is never assigned, but j_fc_off already counts it.

ext4 then fails the fast commit and falls back, and the fallback path
reaches jbd2_fc_release_bufs() via ext4_fc_commit ->
jbd2_fc_end_commit_fallback -> __jbd2_fc_end_commit -> ext4_fc_cleanup.
That walks down from j_fc_off - 1 and put_bh()es every slot until it
sees NULL, so it also touches the slot that was never written.
j_fc_wbuf comes from a plain kmalloc() and is never zeroed, so a slot
used for the first time holds uninitialised heap data.

Advance j_fc_off only after the buffer head has been stored.  That
restores the invariant that j_fc_off covers exactly the filled slots,
which is what jbd2_fc_release_bufs() relies on: the live buffers of the
current fast commit sit above the NULLs the previous one released, so
stopping at the first NULL is correct.

Reproduced on a KASAN kernel with an ext4 fast_commit filesystem on a
loop device, truncating the backing file under the live mount so that
only the journal's fast-commit region falls past the end of the device.
__getblk() then fails for the first fast-commit block while the rest of
the journal is still addressable, so the journal is not aborted and the
fast commit reaches the fallback path.  j_fc_wbuf was poisoned to make
the read of the never-written slot visible:

  BUG: KASAN: wild-memory-access in jbd2_fc_release_bufs+0x6b/0xd0
  Write of size 4 at addr 5a5a5a5a5a5a5ab2 by task sync/961
   jbd2_fc_release_bufs+0x6b/0xd0
   ext4_fc_cleanup+0x97/0x830
   __jbd2_fc_end_commit+0x37/0xc0
   ext4_fc_commit+0x524/0x560
   ext4_sync_file+0x3c4/0x4b0
   __x64_sys_fsync+0x20/0x30

With this patch the same run leaves j_fc_off at 0 across repeated
__getblk() failures and completes cleanly.

[ Context: in 6.6.y, jbd2_fc_get_buf() still advances j_fc_off inside
  the if/else bounds check, so the increment is removed from there.
  The change is otherwise the same as upstream. ]

Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
Cc: stable@kernel.org
Reported-by: Yu Junzhe <junzheyu1@gmail.com>
Closes: https://lore.kernel.org/linux-ext4/7e4b109d-64c3-444f-a5dc-93c2ca4576cc@gmail.com/
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e0d82f83abdc0..ad3f522101aba 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -869,7 +869,6 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 	if (journal->j_fc_off + journal->j_fc_first < journal->j_fc_last) {
 		fc_off = journal->j_fc_off;
 		blocknr = journal->j_fc_first + fc_off;
-		journal->j_fc_off++;
 	} else {
 		ret = -EINVAL;
 	}
@@ -887,6 +886,7 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 
 
 	journal->j_fc_wbuf[fc_off] = bh;
+	journal->j_fc_off++;
 
 	*bh_out = bh;
 
-- 
2.53.0



