Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB0A26738B;
	Tue, 21 Oct 2025 19:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076483; cv=none; b=FjaIFTc7sqZGFJfKVewTqkZD0aRBwYTPkGTlfoWG/9ujMYKxFakcS5jedz+n8pM/U41Taz9PsoR/WAyoA9z1aX5V2I1biwa4LRoM1623dhZ2VmiPhEOpdd4qwO+Rj7WMJwoXUIIhM6oDcWrxYQHZU8X3V40UYuSr4YuqRQsh80M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076483; c=relaxed/simple;
	bh=X8SAAEI4SfSnezvY1rWPuyHhjolOlOkcLpEbICBLyic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRTbcx6QnaYP6cHWwi00Yx77OhEXcFeWCdrh17Rd9zM68V20wDCmMWRf5evPYsAVERu+JlOKE0kJcx+NnTZa2FC7rk8LTGCsv2vAgupknlc8LNb+xpek9yb58Y0cgoPtG/HvWssgJ5AC4dfuEGhaTw9T2zfUq+g6OGkAK83G69U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwSRdOIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwSRdOIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D7BC4CEF1;
	Tue, 21 Oct 2025 19:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076483;
	bh=X8SAAEI4SfSnezvY1rWPuyHhjolOlOkcLpEbICBLyic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwSRdOIf8181KswDQ77+E/WvY7aDnXZxTEUJzEbhbTUR2PD+NRNErFEX4bRAL31Eb
	 Mpi1z5nCGNabPdBpZ7Ad91Ig6pQl1iQOfMNFNJ6TWpMx7WE60F/nYZ9EZzRTDHK1uZ
	 63lVish/0s2/ZW/n6wI0jUwwDoKgo0p7hfjRFP0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/105] tls: wait for async encrypt in case of error during latter iterations of sendmsg
Date: Tue, 21 Oct 2025 21:50:55 +0200
Message-ID: <20251021195022.779872715@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1f22c7adf3e56..d3bf2dbc297ae 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1054,7 +1054,7 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 			if (ret == -EINPROGRESS)
 				num_async++;
 			else if (ret != -EAGAIN)
-				goto send_end;
+				goto end;
 		}
 	}
 
@@ -1226,8 +1226,9 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 			goto alloc_encrypted;
 	}
 
+send_end:
 	if (!num_async) {
-		goto send_end;
+		goto end;
 	} else if (num_zc || eor) {
 		int err;
 
@@ -1245,7 +1246,7 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 		tls_tx_records(sk, msg->msg_flags);
 	}
 
-send_end:
+end:
 	ret = sk_stream_error(sk, msg->msg_flags, ret);
 	return copied > 0 ? copied : ret;
 }
-- 
2.51.0



