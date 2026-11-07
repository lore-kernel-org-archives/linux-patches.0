Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061768;
	b=t2c+a/pOu7nbLASEJWXuSYJXJ3TmSSn+17/EsvGDHMxHRpZeqPs5eoMtJ3D/im7cR/qP
	 cqMDJQXYHGIjF7gOxqK8CnLdZkHrH9ZLI5OjLOz7V1dyy1+1DZ/X+WS793d3Umc+OTwo2
	 0cPINmToinU81VnylgGc8qKKKwxoN1XPD4q0OrfP7/bNG1vowzfRdvR0JR7k8jcZ4pDk4
	 b9Uyy5mLj7dlBb0+GVJ/eP2+gs0/HkZ7KknSdKCNwYoye+lEww50XTDnctn6fzLxDXxO/
	 XDggfWMDejUKhZInpY4/GfRo35k3GqiodVrsKUR76L2C/CoW7QW0pUjoIE8H93NELCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wMtKGt+iu89XTTm9/mgXJ1+cKk6HzODIGjK/U9QY+00=;
	b=zlE4jAp7csDvN4jsFqTHMiIF3fvpeEnCaaUpU9dVnQzfrkxX+nq89XlQwvHNmRTco+f+
	 8ndMuCI+xQea76qdlKW070QtZkSCWoBk40wwTo7ugtcflI9QyWQaKPNskddiaQrkPgKpk
	 gzxRHjbzxc6tV220Is/hb53e2jkF8z5eSfRdSNOYNL5gTscYE/LLLy7F7IknZCcPJ5QNa
	 JG4sGfOo15X9aNiGz88SFz8bs3e7p9+iLc/Odois/NRwDagmsVkljyPFQvjorEhwed3a+
	 mtSHRhZj1mCHFu/LRjVX8qclf1uQ3CUuHHkTqG9E6gkej5+Lnbn2AOXQW82YXjP2t1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPgIifNk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C4E606A32C;
	Sat,  7 Nov 2026 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPgIifNk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A911F0089F;
	Sat,  7 Nov 2026 14:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061767;
	bh=wMtKGt+iu89XTTm9/mgXJ1+cKk6HzODIGjK/U9QY+00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPgIifNkIbL3xyVTklomuq/hUHouiOJv8142PMK131XvW3s2H1TKxl2OUNY1AB659
	 Y+DFLBZ58h4hbm6evCJWAqNTfH36NYkSOFXeqWUCvjwSbUJfqB14/eiN0EGCDrpjI6
	 GehtYiCRF/SVVAN+FMkE+bEcbu3hsErxzYHEep2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0785/1536] SUNRPC: Reject a TLS alert record that is not two octets
Date: Sat,  7 Nov 2026 08:46:41 -0500
Message-ID: <20261107135019.589037526@linuxfoundation.org>
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

commit d16bebe45272ced4f962d27b9efd8b32a3876bd9 upstream.

tls_alert_recv() reads two octets from the kvec it is handed and does
not check the length (net/handshake/alert.c). svc_tcp_sock_recv_cmsg()
calls it for any positive receive, and the alert[] buffer it supplies
carries no initializer. A one-octet alert body leaves the description
read from uninitialized stack and reported through
trace_tls_alert_recv().

The peer controls that length. Neither tls_rx_msg_size() nor
tls_rx_one_record() enforces the two-octet Alert payload. A TLS 1.3
record carrying only the inner content-type octet decrypts to a
zero-length payload. RFC 8446 Section 5.1 requires a record with an
Alert type to carry exactly one message, so any other length is
malformed.

Require exactly two octets before parsing and return -EBADMSG
otherwise. That closes the transport rather than acting on a partly
uninitialized alert. Gate the path on a control message rather than a
positive count so that a zero-length record reaches the check.

Fixes: bee47cb026e7 ("sunrpc: fix handling of server side tls alerts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260808-svcsock-cmsg-fixes-v3-2-62d9a631c880@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -289,13 +289,23 @@ svc_tcp_sock_recv_cmsg(struct socket *so
 	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &alert_kvec, 1,
 		      alert_kvec.iov_len);
 	ret = sock_recvmsg(sock, &msg, MSG_DONTWAIT);
-	if (ret > 0) {
+	/* put_cmsg() shrinks msg_controllen, so a short one means
+	 * kTLS filled in u.cmsg.
+	 */
+	if (ret >= 0 && msg.msg_controllen < sizeof(u)) {
 		/* Returning the count would credit the RPC stream with
 		 * octets that never reached the caller's buffer.
 		 */
 		if (tls_get_record_type(sock->sk, &u.cmsg) !=
 		    TLS_RECORD_TYPE_ALERT)
 			return -EAGAIN;
+		/* An Alert record carries exactly one two-octet message
+		 * (RFC 8446 Section 5.1). alert_kvec caps the receive at two,
+		 * so a longer record produces the same count. MSG_EOR appears
+		 * only once kTLS has drained the whole record.
+		 */
+		if (ret != sizeof(alert) || !(msg.msg_flags & MSG_EOR))
+			return -EBADMSG;
 		iov_iter_revert(&msg.msg_iter, ret);
 		ret = svc_tcp_sock_process_cmsg(sock, &msg, &u.cmsg, -EAGAIN);
 	}


