Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209028;
	b=hE6KK+mdnLKRpG10m7ztwWx7mxhCmUZMLejm4zAtT35eojEXJz+Gk7Hs73BO6qNnRPoW
	 Ztko3tBO9uBq86rv9Qhb0u+hU0LDU1QZg3VgDuQoT/4uwKT80IIg2P8ISdCLRWA/7cMsb
	 a/X/kn5pSgDd0bDVsRInBE/AEkxxVFdqmwRrwBjef+yu7EI5GmI0JG2mFjEC3rFA6Ptx5
	 ITMopHe5EMDItpvAn1M37be4jG650e+XYw0e5kj6que8l9I8uuodpuRP49AsO6gcNGq35
	 bPTth5RnFvZJoVo2X7M8uK4XOTCPD4y8f6FSpCouCCkKVUTOtN8bG2qgist1bgMHMXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IvYE15aiLDDWLTBopwk9ReV8l6/21pJzs/zDyL6piCA=;
	b=e4Y3DqrkEFjfJUagjjvZ4RJJ03byVNBcVygTO+OVsvIvDq7pGW0P7NrCCEKlfGIG7Ocv
	 ZKc1s38dTDgjB1bG2PBgY/zXc4rQBtD8yHb3rU2Bw302xhg7BOYfdbjIi6DcGJoKviwlw
	 PEUuVU2noRiM5cAytnLvXwiydGkS7vmvHs7VT14vUrRS24tpGnCoQi11pU9Ho6ZYqRdTF
	 CnglA/nqgrZOI64BeW+0h3LbvzbYoMxVq5WTeqjhRec7kRaiepY2OtGt8b4viM3IEqOJJ
	 Koh5T4+k2gOIUzmywFPZwbTPgBE0k23LHaawQHvaYR1LKrLLc2mPmeb9GRnXolfadDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrHFgTao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802EA606A31F;
	Wed, 28 Oct 2026 17:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrHFgTao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F9E1F01828;
	Wed, 28 Oct 2026 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209028;
	bh=IvYE15aiLDDWLTBopwk9ReV8l6/21pJzs/zDyL6piCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrHFgTaoiW4JE2O4ew5GZy4NUEhLjUUCOuyWaqeJ17VuXf1SUduSgTeqWl948oijl
	 DpzsslcAFJ7LYzuqthYHM00C1TL3mUclt4dtrVUdW4QV5HxhFhscPXjpidjEYIXuSz
	 vwo6H3hkbmsEB6eAc8Gl7v0kUb+MxuLZmvhRFK6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 325/516] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Wed, 28 Oct 2026 17:57:57 +0100
Message-ID: <20261028170011.187417884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit 538b529509c7ab0d909cb65bb7264edca1788d30 upstream.

When an SCTP stream output extension structure (streamoute) has not yet
been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
variables params.sprstat_abandoned_unsent = 0 and
params.sprstat_abandoned_sent = 0, but then immediately jumps to 'out:',
bypassing copy_to_user(). As a result, when an uninitialized user buffer
is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
success (0) without copying the zeroed stats back to user space, leaving
uninitialized data in the user buffer.

Refactor the !streamoute check into an if-else chain so that when
streamoute is NULL, params is zeroed and falls through to copy_to_user(),
copying the zeroed stats to user space and setting retval = 0 once before
returning.

Tested in QEMU against Linux 7.3.0-rc3 using an uninitialized
sctp_prstatus user struct passed to getsockopt(SCTP_PR_STREAM_STATUS) on a
freshly created stream: on the unfixed kernel the user struct contains
uninitialized stack garbage; whereas with this fix applied, getsockopt()
copies zeroed stats into user space and returns 0.

Cc: stable@vger.kernel.org
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Hui Peng <benquike@gmail.com>
Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
Link: https://patch.msgid.link/20260930044611.204739-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7405,11 +7405,7 @@ static int sctp_getsockopt_pr_streamstat
 		/* Not allocated yet, means all stats are 0 */
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
-		retval = 0;
-		goto out;
-	}
-
-	if (policy == SCTP_PR_SCTP_ALL) {
+	} else if (policy == SCTP_PR_SCTP_ALL) {
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
 		for (policy = 0; policy <= SCTP_PR_INDEX(MAX); policy++) {


