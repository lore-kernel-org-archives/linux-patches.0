Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829077;
	b=xxgfjKgIB7HHOpvGpFXxE75kuPGizD++/9ITBzjLqjTzDk4xa2n4QqejVY18GLdl1623
	 G/c1fpDnGf/AJNOoLpPw5mqiGvcAHvVv5U4TrvvWnQh9HMzVs8x8inyq1qSHO+zbBcJvk
	 oFrVu5BBa9DQfxI5sNmu7WJiPVXOnOklUVVWanzBIl3Y4P5LRHIUjb+ZPRacKRDejf022
	 arhsxH/MYqFaFr0amDn6sE5PFY2XkqJaNPO20X+PKjifskYH3rv10f06E5vVYOvPmnnfY
	 iUGRWwVhDAsEtbxWTdQf4fRDWvK79/q4goGPfrmGdH24pUOh0SDcffEh7aNTqrJ58uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l4gJh6X6/B9h4qkRX3iZlW40TK8h7l/X64k1AXNo8lY=;
	b=yIHqOwl9SdPxlTqrC/Z8Da1C0n+78nuZq993qXClF+t2wlOhs+6VqFgkr+l9BX7xZYnx
	 KPkAiQ8bjb53lE+zWwkixTHHrrpMhy92K1MuXgbz0zAIS1BmxYMyGYXS19iQFQRdakDjF
	 IhpBUBGWUfkyOwVzbYqdoE1nm/OYmB6RPHIJxTZU3LZvTQEPnzAFdxoiF18Dg3sN7jJhk
	 v5uiTrIRw+F47J7zF51dqjpo7aHtg0XZ8wtJu2Miq8EKNoXOd9B9UbSeb1aeI8xV94571
	 UOCBnxQ7EZ9b7E6Etu2JsC8OJ4APH6heG/IrD/YOXSdpWQxfZsgh94gwP1rpmRUVk9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXeqmn09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6A56072F80;
	Wed,  4 Nov 2026 21:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXeqmn09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2C81F000C1;
	Wed,  4 Nov 2026 21:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829077;
	bh=l4gJh6X6/B9h4qkRX3iZlW40TK8h7l/X64k1AXNo8lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXeqmn09gvsn28eQSTQMivvwZTKtUnMaibkV39M8+VUbhY/bJ7NF9qfD7EL2tyWFX
	 usIChnABRv3M6rzJR6sFDrz0rCuw82aZTkZ3NYDjqPt82UDkbaKrjwEMilj9TbbjNc
	 R6JiBVXCsxc05qFeUMgrmSsFNqCOaFlChPpH5keA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 428/547] NFSD: Reject an oversized principal hash from nfsdcld
Date: Wed,  4 Nov 2026 16:10:12 -0500
Message-ID: <20261104211050.505696959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

commit dbed9418c48906dae1a7bc328fb3bc0d0d0020c8 upstream.

__cld_pipe_inprogress_downcall() takes the principal hash length
from the daemon's GraceStart downcall without checking it against
the cc_princhash payload it describes, which holds at most
SHA256_DIGEST_SIZE bytes. The length is stored verbatim in the
reclaim record, and nfsd4_cld_check_v2() later hands it to memcmp()
against a digest array of SHA256_DIGEST_SIZE bytes on the stack. A
length up to U8_MAX reads past the end of that array, and the stray
bytes can only make the comparison fail, denying the client its
reclaim. The pipe is mode 0600 in rpc_pipefs, so the trigger is a
broken or hostile nfsdcld rather than an unprivileged task.

Reject a length larger than the wire field, as the existing check
on the client name length does.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-4-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -728,6 +728,11 @@ __cld_pipe_inprogress_downcall(const str
 			name.len = namelen;
 			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
 				return -EFAULT;
+			if (princhashlen > SHA256_DIGEST_SIZE) {
+				dprintk("%s: invalid princhashlen (%u)",
+					__func__, princhashlen);
+				return -EINVAL;
+			}
 			if (princhashlen > 0) {
 				princhashcopy = memdup_user(
 					&ci->cc_princhash.cp_data,


