Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590833;
	b=kP2fEY4p/DwtuX0zGt2SGywhnFZV/PCt/2ywwV2bnvJKws/DIAM9SqUDCKAop8C19WU9
	 heOkwDA/q84kwsQSX3C7BJK1smRgn74GSrouYZWZ0lcV15TmlALGh7dJLTwxfsXnTHFfk
	 ahVJXiGgGCKKK8lwrxPYssux0/uJ+pHZu3gT1of+Q/oXOiJfl9G2eoH04UIVR/V7mJP9b
	 oWe/lo95xaRPKMJLX/L+TsbJ2MjZLKyrGO1EMhFPnA7+9ccV3zzRwrC2GHX+Jw7cQm9p6
	 o12FE4Ety5XI0Ajarvj3HFCt2SNSNnmoW2wmg4v2XfJiyGza9ZHX38CWyy4fgPeXChA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FE81qHkr6J2GW283KvPMtqzkBCFXtAV5dF7a9SxsqI4=;
	b=CSleOrXQiUNwzD9+Fk3k7NBlG/GCtWzrNaG/wFEOr/0+fW3xwQ69N1Xgatqtg+s8mO/d
	 5VIZ46nDGgRTbvPchFVM0wXVfZ+qb0am0xp8Nk4JAQr1dyuOECKjzQ3n2CUNLWCmDhT5x
	 rk36kIiH+3hhBMAOYTCDmeLjS38S87BSjxfYXY4FqfC5l2z/vNXGL4s9cKt+S4QDYpNgG
	 MCAfQcrE6ux2drIqDngEp1oSJ6AIKlN1yFbO3TElUyKdQ/lTQO3J49YFAmXv1OPuj7uHG
	 aabUG8GFjeAAKJCUUl8WFOHgg5L3BDdiJ9P58cpg3trynSeVR9wuDokUUR0FihqYkqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18aiElZ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650D4606D483;
	Fri, 13 Nov 2026 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18aiElZ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128C11F000C4;
	Fri, 13 Nov 2026 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590833;
	bh=FE81qHkr6J2GW283KvPMtqzkBCFXtAV5dF7a9SxsqI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18aiElZ6iWW7rVpAn8q44wXa5YY3LYSb0NWAv/g+W5R/twBRpzByyIDHJRwjo4Suk
	 xu7iOERK37MEjsPqysJo64S8iWEkDaMy0px8dXNchS9uSbwLC92nlNLSIIXPNeAGo0
	 GZKbK88LGQvRfXWGOU0WC9poHXbAPF1OSkkyEaGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/670] NFSD: Complete a cld upcall when copying its reply fails
Date: Fri, 13 Nov 2026 10:43:21 -0500
Message-ID: <20261113153812.408869602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 8cef2b0a01d28647facc57501a3df7ccd8d13ccd ]

cld_pipe_downcall() removes the matching upcall from cn_list before
copying the daemon's reply. When that copy_from_user() faults, the
downcall returns -EFAULT without completing the upcall, and a
retried write cannot reach it because its xid is no longer on the
list. __cld_pipe_upcall() waits on cu_done uninterruptibly, so the
nfsd thread that sent the upcall is stuck, and nfsd shutdown hangs
behind it. The pipe is mode 0600, so only a broken or hostile
nfsdcld can trigger the fault.

Record the fault in the upcall's pipe message and complete it, so
the waiter returns the error to its client tracking operation.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-3-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 9c7f6d90a1b99..ef0388d92aca5 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -920,8 +920,11 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	if (status == -EINPROGRESS)
 		return __cld_pipe_inprogress_downcall(cmsg, nn);
 
-	if (copy_from_user(&cup->cu_u.cu_msg_v2, src, mlen) != 0)
+	if (copy_from_user(&cup->cu_u.cu_msg_v2, src, mlen) != 0) {
+		cup->cu_pipe_msg.errno = -EFAULT;
+		complete(&cup->cu_done);
 		return -EFAULT;
+	}
 
 	complete(&cup->cu_done);
 	return mlen;
-- 
2.53.0



