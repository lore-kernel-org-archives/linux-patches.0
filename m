Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585333;
	b=OhfFbJBj/3MzPOHm51tSiFajnsfYhFfB1fNRMW7cRk1a1zaGSMSR+83ULbYQ9b9SgWHz
	 4LXtN/733RxtReQKO5OhOP5n1IjxOetNjO6ksHIsaGDwdZsK6eytUoyqKbN5//pJOiTR5
	 /EX4vkD1UcqAA4f1fMkHuDUoCt1pxIHI7wyjxnB+8AUp/EoX6uVekhkvLZvpG7E6/5TsZ
	 pjkjDFFJXVAQEsit8KRXnyCPbCyPi505WaV4kLyixRBWehaFUuuEHA/siiROuFSN46hr/
	 AZkaRBec44hAMAi5YmIlZ2+wKr8nwrke9o9aNdYKLm1dMtORkw7HIl44iiSUopEh5jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uMwQK0ngNKdVVK4XPneLamBnyk56PPqQwSyY9HwlKH4=;
	b=mhTTQ/lHWMvQj6FYazk67AN4uQgYS94Ii0PaF6zT/xhmNjl/ivr9TclT/5sROT3zPmtW
	 CKzZ+D6QzJYLFjdYpc/oOCjFdyqY4e+DrcR0S5eH+fgn+uiloBLNSjPv0+yip24K2F2z9
	 DCeynMdKGX7bpPTjNW9EKioEm1QpajNfRJG3/PM3q7XIcV1Yldz+g9iNj2WoEDBDluqH7
	 MOTCrnCl9BT09LEnd4aa40L7tz7Mv3lWp5Cj0CNDHkLiLsulp1t6CwvBwadCFRDO9UI1d
	 PkgD2Vad3fxNZzwHgkItjJeEBeUSzqw5kmVnLqeOGkdA5db1PPKwuXs+pK0DZapAQ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vb/nJZEd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F8606A8A8;
	Fri, 13 Nov 2026 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vb/nJZEd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3132F1F0089E;
	Fri, 13 Nov 2026 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585333;
	bh=uMwQK0ngNKdVVK4XPneLamBnyk56PPqQwSyY9HwlKH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vb/nJZEdmb2VKxMWm16zg9X0UJSmlDSHBw1MDhMAVYxttyYv96S350RoZgXcpSoOY
	 eeLJlw2fRzboqOV6FIfxApNXxcFLx8CY33uW3SzkpsXlsJvBHF9OFbHXhyUWx4oHT9
	 ti/bbOVLIz7nrj0de7Ba40rrnrp4JlJAlhQA2hTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 019/507] NFSD: Complete a cld upcall when copying its reply fails
Date: Fri, 13 Nov 2026 10:45:23 -0500
Message-ID: <20261113153754.064136489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0b033688aa0b5..907a914b04cd1 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -839,8 +839,11 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
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



