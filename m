Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037188;
	b=t73QdyHwiTQ/1GiUHL8pGUu6tSiDmnea2+4BRdBwa5hh+AsBGp9P4K/y7osl7AYsLcJb
	 foFjxeJYG/iv6jrbG2G9PLZxIxtRlZNtcUdiBbNlsijK2RivGAnImnzTiPHFT4eEb/G5r
	 8bNgOMT5yXuoHu04RHg4Oqja3SAkAr5Fc4cEH6BeXkCpfT16EFLk3TpSUxHGAwLbw6ujr
	 loHX78rpvR10aNHwbZtEWv5P4FSn5+WPzhPaj1fHkV1K0FMpFF9y2cJYdmPOIvABVE8CT
	 yF6ctJW1y+eUm/qo6jD+eztWHROjMvsXfWF/cvMc6YdoFbUw2c5RPTMk5k1Ah2vPVnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6EqNYgoNzZVtLzEGsJ38GsIKt/ICMsWGBX2Pt50hTnw=;
	b=oS7EwjJslWCYSnnG0SxsnvDO0Ct3iETpmp7mPRTLdQDsXG08y37SjNLrng6ISelczWy1
	 /WX9TCOnfUsTKc0bZA1WrMp4s8rQr0KeimPLLVjT3MUr7pgs4IaREzXXYS9NTsy5VL4cr
	 EKO5xb2EDAv70si9WrmNlKsqHEcW26wgQ/xhQGu5i6fW9QtoeWpYV+1QsAYa1qy84ZPB2
	 +UjFXN2UEo9h/Lesul1VeIL42ixWbTLSI5MnTwawBB9UgzeJWA4FSjG/E82woFMEhaefO
	 IDj+KDbSPbd7lNiQCxkw7tiafyIL6Ago69KWQUuvq3yvfdU4caJThY8EikaeO+eeWhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cM0jQ3a/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D114B606A320;
	Wed, 18 Nov 2026 21:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cM0jQ3a/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B941F000C4;
	Wed, 18 Nov 2026 21:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037188;
	bh=6EqNYgoNzZVtLzEGsJ38GsIKt/ICMsWGBX2Pt50hTnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM0jQ3a/ZMVFK5PKNp++Ng+qGB7XtUfT50IbazaF3HOSwjSVZv7tmiOgz1ZjhGV3p
	 t95ObejtswWWT8WikCfVlpbZt1ytZontprpTpH8CQCXzoXoAKCTlGmkh9h5W/UAVKI
	 NBPlon6H2cv6fW7Om/ahn4VnOFxhhQf6iX4a07Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1323/3318] NFSD: Complete a cld upcall when copying its reply fails
Date: Wed, 18 Nov 2026 15:32:25 +0100
Message-ID: <20261118150400.009680300@linuxfoundation.org>
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
index c7031c61299ec..3c700b20aafba 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -915,8 +915,11 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
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



