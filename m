Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051864;
	b=S5SumuiZHWftUi63O9iNHW/H0YF3Fr+H/YG7ZRMXEkAYWrdiLtO+5ToGiY37yrUelgvj
	 MxfJYvwXCiZa6xssk9Mg9wcy7Ryc+zHmrnPadT5g3C7n6olxTVU6jbyqJiKo/5OcMFEFA
	 W5rhGEj0ZIHfadxaG/n1Rw1/aJrPcAxywxcE78GyzP6YlAKH4DuLEMohQ1hWgS70f9x1M
	 rag1Kce7ZSHZkwjFib1elBFGcXk8F/wvt5YzaTMYBvqtt8KJnVj2vga9i8Pwc0fUrM5of
	 1UcR7hKu2sEnhO/+fu1w8k2xyqXA2jjQachXmAUxl0nAfFLjOh8xQzHdM8k/schaQ1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0xiQMPul/ooxAyN+d0nGkUdFBywWtxdnepw/jT6iRho=;
	b=FNYeetYTHfeVIHzFzQ2CN00iH6BYe+7D79M9E//0AbPDNwTTfCapHbU4NV7i4Ja+OzyG
	 zzpLl+qgvc/MRH5p22Cbd0nE/yPwyDadTwNHrx3HqKlmlOu4AccOVoRp9k/lWHABkUt/m
	 CBimUv5Itnkfzi57lCQFy3IvndYscAL/5HLi0PZTuE62jB5c38eSkgSZnndZzVm58AUXa
	 /44zVc2PtdG1FTKeUG/9RBNEVODRorX485lQiRe5VkrHBaL/yWZFU9qGjmxbPwY2gDfxi
	 WTdZsuC/yoKp20IzaBOvu/uVdJOBw5AKfdRVP/2hnsBfzlb1tP8iOMRSJHEdEsqP89w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wE8FA5E+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B82606A31C;
	Thu, 19 Nov 2026 01:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wE8FA5E+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFF01F000C5;
	Thu, 19 Nov 2026 01:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051864;
	bh=0xiQMPul/ooxAyN+d0nGkUdFBywWtxdnepw/jT6iRho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wE8FA5E+LQa/4rRLaTI6oUId3E0VXRih32KskFk0fnfKT6FkkRzLTkMIo14MyUdvV
	 D12RE4Tm9puUFP7vPCWymKYBn9SLP0TQcZ5OqgdHwG2FFs7JZx2w39t4jMG5OgrKHB
	 i+EpTKHVNGSft4DM2CJs9cORGr4/Jn0EN2wb7wl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0358/2214] NFSD: Reject an oversized principal hash from nfsdcld
Date: Wed, 18 Nov 2026 15:33:54 +0100
Message-ID: <20261118150025.017630334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -800,6 +800,11 @@ __cld_pipe_inprogress_downcall(const str
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


