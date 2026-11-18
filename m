Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058847;
	b=ePAT1j6RBuFLJPwOAZPi2g5qY2XJ+mAyjrMRfNIkgfrUTE9hIh+1pwPxu7MfNlN+p/Hq
	 FCxtd7yhQEOrG+C2ry7+k9Ikt83ZVFoSb1mvoDAfyYrLKVteWyqVLHZpOqhW8W87DgSDw
	 mhBKHdoZ3GQ5JbS1u8qaRKpNXJNolUJc9sta5xBLT6Fxlu1PSuC4Hz9IGxWRIC7f6rwdY
	 yyeMZFSShyEHHKj/96lIVhRQI6SjEiG5G5iTQsuc6gK1MTWefj+xYp0KoPZFWl/lDR4D0
	 dxOHSGCsJTR4dRjeIpkW+cF8hN8cQ29RA3V5DPGSbfAsO3P61VgMinH+RKuClRTHdpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMEEuTn4YYKicTXkv/4bmejkeNPtsPXCYMZV8rj4X1Q=;
	b=tFuw5w9jY4BH1iR9xzayqZT/jAETtuLbY0NFq7QyWGgMm8l1vGju3NUZduR6kMwYNRuS
	 cC3b+pr44EW+jQkXNd3ONZZ+VYERqbve0WEYiooZxKsALh5neGonbFjecSp2rud7kOHtF
	 8M8EbFlVILum0zCU1wvkiCnyyt5qhuDKk8dlCcRDOp0o2yqoqA1/B4qEmcf53wyEogAEn
	 +o13voW5jl4quqdZlopesOItC4VywdeDIRVk0xLJEs+pZCxzlVpTchFviv6nLPR3m2kjP
	 uH0qIkssjz1qgxykPBKrp3AKvjnz/zf1z17856Y671tzOnM6Y4FLman8qWxyZ/BguHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p09fmQSe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89882606A333;
	Thu, 19 Nov 2026 03:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p09fmQSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969C51F000C5;
	Thu, 19 Nov 2026 03:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058847;
	bh=EMEEuTn4YYKicTXkv/4bmejkeNPtsPXCYMZV8rj4X1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p09fmQSe0ioL4QVRPe1amTmLzklFQibfYfFdCnCXD2bb0GnQVCvPsl/1D6JJQ1vSk
	 PScUp2uDHpy/2Tt1InqKw9GgEoRGoyTChIwAo9hSp6dC0RERh3tai2zrqCLkdCaaEq
	 tJd8yRAdtWLurUgyCJI49sSTXxVJok/KECI01lXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0633/1848] NFSD: Complete a cld upcall when copying its reply fails
Date: Wed, 18 Nov 2026 15:44:31 +0100
Message-ID: <20261118145942.153903559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index bdffe807d0404..6cbb8ea9f7350 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -909,8 +909,11 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
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



