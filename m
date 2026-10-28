Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207425;
	b=qVcI/O5oLshxpf49CNtUnELvJHEunCKVXcwRWHifNw3TLVjfeDs3CQDgcFX0gm0ottjr
	 AWcS7BSnzKwiHoHNmUC/yTRjkftRYSVnTOx2F/qoFp84jU/SJ53jpNm5vhlfKPu7q+zXZ
	 FNOcM6V1v1uGU9hqXOHPJjIY4Qhhg7x0xnEWaHqWp8B9iRPIg1kwkQzWdmJy0HM1dh3GL
	 8rtEBxjzhfJJTeidI/gSWrLHRUMulevYXAhN2Z9KJNfk+Vbp3/+8cAR7kvqzYzwx6liku
	 ZV/mFv1adATOoUSGHmd5UimFGqCYOiAGzYFIqTvpSNLAwS4Cv/wvYlyP71xTpsgv37A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCa2jVl/fVVqt0MEpa5HWlnz2GeeCNC9BeizKB5+wAQ=;
	b=oHG5K6v5qB5rnYPtIv4gRvJ1CFk7xiu3yLkDNfRsF22R0AaFAXLBBoatv2JLDxW526Kd
	 T1JM0SPAl7Qd0WvZjeV+fvneTvoDROW31tFeazwQoQci+5+CSvLwcjgzETkvIUJclpgtc
	 BLeM+NceUVmnVlV+Uj+UswwU/MjdVeUu6p54w4KNiOeDONcEDljJz0z6OGfA0gqM3F1wv
	 XFTEWiY5JcuZvBSs0HBdzaRBcyMC0JQ7mHF+RCogB9d5XopezdU4d+ZaaIxIev4SOfSyt
	 htq0AfnlYyzsASThjd5Z7/z0wpKx6OlWdA0V2f+HRud89j7mWHerfWXTu5GngbaqADw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIFWp4DO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C743606A31C;
	Wed, 28 Oct 2026 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIFWp4DO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8321F01825;
	Wed, 28 Oct 2026 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207425;
	bh=bCa2jVl/fVVqt0MEpa5HWlnz2GeeCNC9BeizKB5+wAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIFWp4DOlJJHfTjHPCyB09DVLA8AuI8glqCpDeiEGTOPjg2jzMc5uoZdUcToYrwvi
	 D6/nRolYHchJZqq8hvNXg6aUCjKRWze+IKzBiE+LW/SK9+He4vj3zA3Hkw24QnmBLt
	 3fAj6XoObNGgcty4+vVwvAPGBz4veIjnHGYc3FHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdul Wasey <w453y.me@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/247] mptcp: move the OoO check back into __mptcp_try_fallback()
Date: Wed, 28 Oct 2026 17:56:56 +0100
Message-ID: <20261028165947.672036696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Abdul Wasey <w453y.me@gmail.com>

The 6.12.y backport of upstream commit 1bba3f219c5e ("mptcp: do not
fallback when OoO is present") put the out-of-order queue check
in __mptcp_finish_join() instead of __mptcp_try_fallback().

So the fix itself is missing, as fallback still happens with OoO data
queued. Worse, the passive side now refuses every MP_JOIN while its
OoO queue is not empty, which is the normal state of a connection
already sending data over more than one subflow. The joining subflow
is reset, so such a connection can't add a new path, and a path that
comes back after an outage can't rejoin while data is in flight.

Move the check to __mptcp_try_fallback(), as upstream does.

Tested on 6.12.113 in netns: 6 connections (5 uploading) over two paths,
then a third endpoint added mid-transfer. Without this patch only the
idle connection gets a subflow on the new path and the other 5 joins
are reset. With it, all 6 join. Same result in 3 of 3 runs each.

Fixes: aab400cf8e35 ("mptcp: do not fallback when OoO is present")
Signed-off-by: Abdul Wasey <w453y.me@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -74,6 +74,13 @@ bool __mptcp_try_fallback(struct mptcp_s
 	if (__mptcp_check_fallback(msk))
 		return true;
 
+	/* The caller possibly is not holding the msk socket lock, but
+	 * in the fallback case only the current subflow is touching
+	 * the OoO queue.
+	 */
+	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
+		return false;
+
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_infinite_fallback) {
 		spin_unlock_bh(&msk->fallback_lock);
@@ -943,13 +950,6 @@ static bool __mptcp_finish_join(struct m
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
-	/* The caller possibly is not holding the msk socket lock, but
-	 * in the fallback case only the current subflow is touching
-	 * the OoO queue.
-	 */
-	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
-		return false;
-
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_subflows) {
 		spin_unlock_bh(&msk->fallback_lock);


