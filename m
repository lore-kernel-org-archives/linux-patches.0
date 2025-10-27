Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FFA35965;
	Mon, 27 Oct 2025 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592258; cv=none; b=gmc/VPkfLSTtn0hvQmS400LotJ1Lcf/5yXdpHbQAC+63oNnXpgkG3afvAEBbula8+XU+VVFaO0GfZTDAQ60tl4aGnSNdjJjBGY6J3raJ/e0IlNgzQf7Bpf43+wJdgcDonSpZm6AOzL3VWxgM31xxGjlPYJdBG1xyDfd14FUlnEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592258; c=relaxed/simple;
	bh=EyWW1nNWjZot+VK/xg4T4yKwMfBGD/ddyZCDtlha33s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdLBoK44Y31+NzZm8MRwqguKEGCOMCa98xO4EeoWtQ/Gtcu/cgD38ji7eBn3O3tEj1+dtfGmzPoTwH7LIqrO+U7vsqUnnivhdQgIZncuuzXS9NoZRw/zhWWiIeV4rWONy5SopF5RDZsuTVPBJa2lKsSYEsYQHONBsWA7gIbwvVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvfmh3x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvfmh3x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD065C4CEFD;
	Mon, 27 Oct 2025 19:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592258;
	bh=EyWW1nNWjZot+VK/xg4T4yKwMfBGD/ddyZCDtlha33s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvfmh3x2bVahRPGfN8J2GZoJGPF6igLqvc1/zihO/UOVy1fpx3HsZzHz1wv+SQw6z
	 vKuQgqg09JsBQN8wjLZlbVnD4hcEuSy//5Jo4KFMwshhbh7hh4x3k+GjCXIHQwajxj
	 0REztz8unBldYdtrmc5J/2dPoc2pLJkCrYQ5HjDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/157] tls: wait for async encrypt in case of error during latter iterations of sendmsg
Date: Mon, 27 Oct 2025 19:35:07 +0100
Message-ID: <20251027183502.530696498@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b014a4e066c555185b7c367efacdc33f16695495 ]

If we hit an error during the main loop of tls_sw_sendmsg_locked (eg
failed allocation), we jump to send_end and immediately
return. Previous iterations may have queued async encryption requests
that are still pending. We should wait for those before returning, as
we could otherwise be reading from memory that userspace believes
we're not using anymore, which would be a sort of use-after-free.

This is similar to what tls_sw_recvmsg already does: failures during
the main loop jump to the "wait for async" code, not straight to the
unlock/return.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/c793efe9673b87f808d84fdefc0f732217030c52.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c67cf1a06c0e5..0e378d7cb6903 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1029,7 +1029,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			if (ret == -EINPROGRESS)
 				num_async++;
 			else if (ret != -EAGAIN)
-				goto send_end;
+				goto end;
 		}
 	}
 
@@ -1182,8 +1182,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto alloc_encrypted;
 	}
 
+send_end:
 	if (!num_async) {
-		goto send_end;
+		goto end;
 	} else if (num_zc || eor) {
 		int err;
 
@@ -1201,7 +1202,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		tls_tx_records(sk, msg->msg_flags);
 	}
 
-send_end:
+end:
 	ret = sk_stream_error(sk, msg->msg_flags, ret);
 
 	release_sock(sk);
-- 
2.51.0



