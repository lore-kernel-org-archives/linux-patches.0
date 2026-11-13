Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590058;
	b=OqLwAeAWelURaI3JfexW6q38Ud0pS/0EliE5lSbloZKkbkeSWdiPhfWTGwv0WvceIF3V
	 tstKlQimbqKLaYdR79o2hVA555Sq76plDWPHXSDNsImgvWggpqO2yX13m4WKw9hceD+5g
	 blQeykzA7yE4wadqu0eDcZuc34m10PBEqGjM2xzRnYJ6OW49s52LNjwhgkoGYzlEMAWym
	 xZHrWcMcZjtWg6M9L+kVlh7E8ZeBAoQ7e6m1e8TsXrcgtpToMFIhJbocDiXXzRdBUJfLZ
	 fs1453vk+14vSB23j4LpO6XqB0FVN+NiBjRzjMZ7gqN/wUl17N3GJq7J2y9vmYhpXuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CX9Tb8SqnKhEb7CwnR6UXCTUo7AYhVTwTnDW2LCORp8=;
	b=S/VHcQBCiyrZ05I55c3D62VGB/701OqcHy86KcfgGPEWzUDszztiCEPCbZ5rFN+zvurK
	 KlDxiSM7byRTcPHZDf7WyTfvsaetV0KwBz7xYbZh0Q6tr14Hf9TYP2Z2zlhB+gV/btO2f
	 3yWEqW+3qOCSOY/MDGR15tVYrHjpU3YdkGv1CsUxKnGLFNfSR63J4y7CD5eJPD/dy9p8x
	 CQRqKGEurWDVR0rZu5Y9ako03cX9M3vksUbRdzS5lPrUP2TNgMlzw2Ay8SEeyEE09tpuq
	 YKMulYXJKybLp7gKLDp02o59LcUT1Zo/se4/uoBOC+F6KnReO8cLrHnUh++R3vMwbHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQLTjJ4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D6E606A88C;
	Fri, 13 Nov 2026 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQLTjJ4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060ED1F000C4;
	Fri, 13 Nov 2026 17:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590058;
	bh=CX9Tb8SqnKhEb7CwnR6UXCTUo7AYhVTwTnDW2LCORp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQLTjJ4Z6dPWCEBF/GKziq+uCnAopasBTA/vyEvJxZ+kI3zmzQmY9HqiJqpfDqetq
	 X1rwtSITH7ntntdviubsWxcUPM5Mb9+Nu//9fyegIWMW3/FxZ2/Tyx61o6rdpKeOOI
	 d66pnweFojt+IiVAFRrdk0jdRIpcb+90gAGXa7ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/686] NFSD: Complete a cld upcall when copying its reply fails
Date: Fri, 13 Nov 2026 10:43:02 -0500
Message-ID: <20261113153822.622313601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index e810ecb144950..83aba7ad39081 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -901,8 +901,11 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
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



