Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035462;
	b=kzpzXwXVChj60nO5oiiKFGSu7kJK2KnTDMbXELhWVcHcMs5WHfgXv9XwDoa/K927hSyX
	 RWkW/xDolQyY+cF1NBhDe42IfFSd/eAcDDhVKOPmlZPE0XhUmRW9vnaZSaY30Y/554G8P
	 hsO8amPmxyXUGTu9usnhdV9h2IWDsWiSXLwCr9FXhdLIy6Xk0RhifYfZu7FjTfHBjzHDA
	 tmLoyjx/M8/RrkFWeGVQdOph9jRwrGipybNvy6HZpkGr85mZCYGDaSyN9eTcTsEYSiCMO
	 vMDTiOXoX5b0Bf6JfdzrRQRkt+0aXvrlpBsVtiqNt2HyfnQ3i2fwBEDzOOyq+ss7rBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hZS7D8l21tPEG0IYsXoqlHF2gI1KXO3UsfYaLjPPCGE=;
	b=y3l/p9psFkMSOO/Gm+QJ/a5Ntojl/zi/6lKX0lBNbn/MV9eaIexPK2D/qOZq8Q6Zhe/b
	 lNuq1TRDB4I1NEfRguM4tLKRSTFXUOd+p1k3Fw+xciP/nkhoeQItSTnM/NTUS39lyGydK
	 CBTIUawI7a7y6KQT3QZBSZ4iEmUzupqds8JpM38f2R2oFWiDlQvdAptQnaHcYORzmEruT
	 enOXKKd1DTjvI07xARNnq3b8JtbjnpMWGbRVaxJBmtLLMz7Dq0Y6f+9hOUgstul7cRqyd
	 PLHYDmTYhBA1fH/UJi2gGDliAxRXFcb8qbuq4Ughkph5dlQXJCwtLvLjI+2CQZvxdew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiXKMbTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3960606A31C;
	Wed, 18 Nov 2026 20:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiXKMbTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF891F000C4;
	Wed, 18 Nov 2026 20:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035462;
	bh=hZS7D8l21tPEG0IYsXoqlHF2gI1KXO3UsfYaLjPPCGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiXKMbTdLZ5xBillAUvPsdbShGZPBbehheql4afPYch9JHR6vY9+aUbptWgrhIATc
	 3m/mlkLqP+CdzUhHdklr1GQrZpWErshvVpe2U8ewQwCoACyzwXZdzKFdxTYAe9ZkUz
	 z8u2na0lYRjQNELgKBUzO+E4aU5W7cCa2YP559eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0696/3318] NFSD: Reject an oversized principal hash from nfsdcld
Date: Wed, 18 Nov 2026 15:21:58 +0100
Message-ID: <20261118150339.213343896@linuxfoundation.org>
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
@@ -806,6 +806,11 @@ __cld_pipe_inprogress_downcall(const str
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


