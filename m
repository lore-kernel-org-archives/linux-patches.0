Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061732;
	b=p6GQD5VyoSPHTHyoxBgza7hFeNLtsVfXTzEjenE3kLjT0uqO/gBmdSkaBn1h+7ZHLFb7
	 qqt7ubZFWWeteaaLwuucNUQuAV6oQjzRvzPhbIwtcTSiReI3kYe9VI+vHE5e1KiO7/PQs
	 WFE5KHtMFu34tNJE260pJoYzjv4ljJrVJkFpQQQIfBgEv8+uQKBDLFv5VfaCFWWnIyqEo
	 f0gj17Q9alrut/zvwxJeUiYW2iDKLxc1V5efD5FLEeRK7pZy993Ao9N7sts7VZljwBheG
	 0o2QHYEkEc6qPyJwSiXwwdWgmJXFhsxALdVAi7JBq5yW0nUcQIkcVGxnRQ/7dTEIw+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvOVIqybI3uVfq7H979AF+15XTNtbb7V+h4o3Fcggxc=;
	b=oHoLYEtZcsnZfTyfze5WwmsFQBQOsb08D0Fh40feF4IyhMdMTGWsG7mUy0gtqdaoPIVi
	 6DKgma6umLxKQa5DIE356JruWMevSEYwsh21JvrIjaMC5TJvYoaPhf6QHb3XLddkJLFGr
	 T1l+J2zCNbF06z1H9cCgxhjFRm1ShzckEFQhgaJPzqqB0PIwc+geHcNx5O89z/ldmJ0rT
	 jRNqH/3lz3ku9q+17Fv9DCaref/AAWeAIu8gQkZNjckLUEZHmUJy2Gosxl7cNKBlHac4I
	 BluHiBlicQgfLynu2wDbrb9gz5dP0VvN0hso/UIMl1bxY8cxUp7guepdy2iuAIS2Q/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzxKUq6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FB0606A32E;
	Sat,  7 Nov 2026 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzxKUq6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A821F0089F;
	Sat,  7 Nov 2026 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061731;
	bh=PvOVIqybI3uVfq7H979AF+15XTNtbb7V+h4o3Fcggxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzxKUq6u03CRQC09mdsKXAxfsVrMELrXaU+YWBthBcDftw7IdSSXdVafaQTHg4x5z
	 hMXF2sP7nk1X9PFVISQsSebzBLeNNC8K/4uqd4bHHNv4WeW5Dk81s/NCfudD/y8j71
	 mdXq2hfm9YApKBrNypxTI7kMq3TVuBqO//3nplr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0773/1536] NFSD: Reject an oversized principal hash from nfsdcld
Date: Sat,  7 Nov 2026 08:46:29 -0500
Message-ID: <20261107135019.243077193@linuxfoundation.org>
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
@@ -809,6 +809,11 @@ __cld_pipe_inprogress_downcall(const str
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


