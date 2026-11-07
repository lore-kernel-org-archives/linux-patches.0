Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061659;
	b=3LQ3R0WjdaJw8oTTtlsH7WyrS7AOILnK/iEaQdoXaTPivaXd6rQhKNsXFZX4cFlPt2rY
	 Rn9eoXalqLc0Z9xzM8iFMybhIgkODuQKAv/1c6Fid2Azoq3kpsi1GvMYCqlj+LbGkn5hG
	 FbuJgEEu2NYnnfo98i6SZcVWB4RbuK5sPc3LWCWXI2wLwpp7Hut0GggRaz3dnzQ/O1LVm
	 bQu7/c6zeclSw3BXTZ9drVeSxTPQBfzOxPI8evty9oTXguScAuPuQwXdxfzejSUE3HyRj
	 ioIEVKUc4Aqf49lT0aIiZ/dWPLVB8WNwVWoSW8DjK2i47M0E56tUdRAcSF+YHHZ5avQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h1fxGKvj6yxWv3aS2N7jsKhUNxiYWCEGaojo2jpMEQY=;
	b=gff8dHKxkYgEj6KOsJi/f2IurKLroxVr3kAFIZoM5zYF11oH2w5WOVQdWKb0uUkRPZB9
	 EITGURzeCbeSpUJXI4uMyMmwpE5yjY7uGTVquW+w8Enm9IcWA19wjkA4KovLGObTtq5Fs
	 DeOGbYqiZounuyNxx1QapByMFPEYC9J/9WLy2qmbV8RGskz3hPrcIASEUSdsCL05/Btjt
	 oR2wzKxgNNyuYHGmvOLv5jN5LQbtV0oK2nTR/v78RG8jUBBRLBqGzQCPdm532sojjObvq
	 6InH6sv6MQ59CP66FSslZwGRenmzWwTCXARlcvjFplLB+6yUmrxmTBHs4Leip9mVViw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppn7BbNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF83606A32D;
	Sat,  7 Nov 2026 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppn7BbNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96C81F008A3;
	Sat,  7 Nov 2026 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061658;
	bh=h1fxGKvj6yxWv3aS2N7jsKhUNxiYWCEGaojo2jpMEQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppn7BbNmmIkkjmu07JBhdyaGeRT8J8flT+TRlxFn8XrNcHEzH4qH/gLKFf66YzMWP
	 Vu3kjmc8o6PqkKR1qirEFvucGs1FPMrxei5yVOCmFuH8A22JYx+4mHAL5LZqEiDAiD
	 afS4iZu46DarTy6FirOt0Q3sN/i71M4jGp8iSQ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0717/1536] ksmbd: fix breaking_cnt leak on early return in oplock_break()
Date: Sat,  7 Nov 2026 08:45:33 -0500
Message-ID: <20261107135017.637233078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

For leases, oplock_break() increments breaking_cnt before calling
oplock_break_pending(), and returns early when the pending check
reports nothing to break: the level is already at or below the
requested level and, for a lease, the state is not HANDLE|READ
caching.  Neither early return decrements the counter, and
wait_lease_breaking(), the only place that force-clears it, sits
below those returns, so breaking_cnt stays elevated for the life of
the open.

A stuck breaking_cnt makes same_client_has_lease() skip lease
upgrades forever, and every subsequent same-client CREATE on that
lease is answered with SMB2_LEASE_FLAG_BREAK_IN_PROGRESS, so the
client never resumes caching.

The ordering dates back to the original SMB3 server code, but the
early return became routinely reachable for leases already broken to
NONE when smb_break_all_levII_oplock() stopped filtering out
non-level-II leases in 17699905a381, "ksmbd: fix lease break and ack
state handling".

Move the increment below the pending check so the early returns
cannot strand the counter.  This is the minimal equivalent of the
reorder that mainline made in b0148dc5625d, "ksmbd: serialize oplock
close with pending break ownership".

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 7d78d4ae43acb..90cd8c962f785 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1012,10 +1012,15 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 	if (brk_opinfo->is_lease) {
 		struct lease *lease = brk_opinfo->o_lease;
 
-		atomic_inc(&brk_opinfo->breaking_cnt);
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;
+		/*
+		 * Increment breaking_cnt only after the pending check
+		 * above: its early returns would otherwise strand the
+		 * counter, as wait_lease_breaking() is never reached.
+		 */
+		atomic_inc(&brk_opinfo->breaking_cnt);
 
 		if (brk_opinfo->open_trunc) {
 			/*
-- 
2.53.0



