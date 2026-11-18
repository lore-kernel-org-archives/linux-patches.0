Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046009;
	b=mLKPmUqjty9MlaOFGgl1eZPB9nKbUKGZaKV7gUk2/c6QodCZ29eqSP6amLVerg55HGT+
	 QB+kdh1cdYb7Whz34qmxicsT3ZD5wFR3C1l7hKYyK9+KP/zI58AzEgO6tmMXssIfDarY9
	 PL2ZWi8BekoJLjZdKdr+wAAcEKSQ+KBLK7LWpjEBLV32wpojU1n2P5BBB4T8chb0goxHY
	 FWM9HPJw6MoQzMOrf9VWwD8IOzjvvCSisZMCA8hBx2ASuARvB8QKThpurbFomYrRaYXB5
	 ZAylB0F6bTaQ2RI8Df41e4Jov9SPHW3BG8hLxxA4GusmTi0KpB1+ec6ANi10dZW8izA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ztdslmwp9PS0dZ9m0nvLiuajdZvL4+XJMxeZAlgot/w=;
	b=38BXjFXjSA13baoB3deal18HuHhgnsnyWtQBUCVQCR+oTpJyJv/tJGYOA7m7VZd8PqUl
	 dia7lAKXUF0IjuIW0fPVByK2TmfQ4u9NPMy9VA0/CSVeapSkT/PuACLYZpLSHk/dNLUBU
	 rDVv2xYnIeAEHSnr6f5Py3v/046Oq9B9UkeVzAoUW87hpGjySymnv4qsr3Y7RQa9sNxci
	 PSnQTI1tAylxsGhfxbZIes+byyA1M/H2d/DKMu1RAtP25DV5G4nTgRkIr/GQL94Og8XgS
	 CmktchcUjZRF8NfxRFQvpqUxpNH07USODXRw1Jr4Xq5yDv0L9OvxZ6QIWj9wnGQE45g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o3vG/hUK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C834F606A32A;
	Wed, 18 Nov 2026 23:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3vG/hUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF711F000C4;
	Wed, 18 Nov 2026 23:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046009;
	bh=Ztdslmwp9PS0dZ9m0nvLiuajdZvL4+XJMxeZAlgot/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3vG/hUK5YCcRUeH5Lo3daJ7QXMi21Ss0W+9+pKzdb/2I/MudWFv5ECBPSBhPxYQY
	 nrS0Lac0rFsnaJauo+0nNZ0rQu7eA6wWjHkNwm0Haaswl4oMRc7Ao5+d2ZN4UqwjNe
	 AdaaMZVLTFbMiXchNzRO9a0r0xItkevJNxzN/Nwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1129/2857] NFSD: Complete a cld upcall when copying its reply fails
Date: Wed, 18 Nov 2026 15:36:03 +0100
Message-ID: <20261118150242.253358462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d14854d9d2741..f3622be9d9cf0 100644
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



