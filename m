Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022143;
	b=hdSIk01UuYihp34rB181HFdJX00XCjmY3EJPLHbnTPqTo16K+kMxDwdrqKwzv2MM0+UR
	 jF1+FUxpLtrfGDd8bUq40hWGV9cOJVF1tcHwEuVhW8B5jR21Isx9meMKzIP9PO4ONFLEo
	 kKU09e9z91hpK44pk4DvpiLAn4uurXD0ZS3aa8f4VOX6f65NgmGmu/gN5hpIPDFtl6Sq0
	 86JMjnI7C6+8iqGPWDw5fsSon1Fynh5pAwWxsM84NPPhjHwVgAQl9ZrixZvhvq7M1DS2S
	 cDFvda9kK/TOfrwWLMqngPlFXUhLJNezSZJQJCX6juKpRKwqNyXL0faLc2isy6JFZFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KhDk8MhsTy3KKW4upAyeuGVjt8zUOx56d5jSMdWHR+c=;
	b=aDJ+gylyglha1NyA+SnTH7WdJGub811RcJTVvktUBoJEV/Q5tiX++nC/31/hB62+fRf4
	 XkNKzkYu2KwZXfG8j6ga1V7F0963IU6EQIyftEVCYrPqwTtW58CgxNjxhw5cnDgVDuBzA
	 nwG2mFs8DvJ90A05vRrF+5WECzxICHXzT8o3UGiDkdo9+rzMRCnm/3zIch9i411upw1Og
	 l30bamHQzdt6zsNe4/e3AYFcx5UVKn6v6xqvE73fjzhZOZguBeZM9qtcC48L2EsF//GMz
	 fyG2uKMmsiSlOazdptPMgKgLYw2xQyksDO0BJ4aGf5WPUVZ93LOkaVuTFhelQL91ZPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qlonu7W9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B98606A32A;
	Wed, 18 Nov 2026 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qlonu7W9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1111F000CC;
	Wed, 18 Nov 2026 17:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022143;
	bh=KhDk8MhsTy3KKW4upAyeuGVjt8zUOx56d5jSMdWHR+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qlonu7W9B3rc0qsn7ds6mQfoSVGilUJKZIc4O/k+D9vP2X7gTgBqhHdX2n1GI67mO
	 OgMJXrfnnqaqZPkGaZrhrv2SXZdri7iaLfSLpIZKSnOSu9P5x1bYWmlw5dZxIOBfVN
	 LLeIxanH3tmIhsh5Ez3GF27fstp8iNUa7++l9SgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2557/2651] tls: Honor O_NONBLOCK in tls_sw_splice_read()
Date: Wed, 18 Nov 2026 16:03:17 +0100
Message-ID: <20261118150416.521770019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 78ded647d43e335891f981f68c5992a2e763cfcc ]

tls_sw_splice_read() takes its blocking behavior from
SPLICE_F_NONBLOCK alone. When splicing from a socket to a pipe,
do_splice() sets that flag from the pipe's O_NONBLOCK, not the
socket's. On a nonblocking socket, a splice(2) call without
SPLICE_F_NONBLOCK therefore sleeps in tls_rx_rec_wait() until a
record arrives. tcp_splice_read() instead reads sock->file->f_flags
and returns -EAGAIN.

Polling first does not avoid the sleep once tls_sw_splice_read()
consumes zero-length records, as it does after a later patch in this
series. tls_sw_sock_is_readable() reports the socket readable while
any record sits on rx_list, including a zero-length record that
delivers no bytes to the pipe. For TLS 1.3 the strparser announces a
record before decryption, when its plaintext length is still unknown,
so the readiness test cannot screen such a record out. A splice that
consumes the record and waits for the next stalls every connection
an event loop multiplexes.

An LLM audit of the TLS read paths found this defect.

Treat the socket's O_NONBLOCK as nonblocking too. A caller that
sets O_NONBLOCK on the socket and splices without SPLICE_F_NONBLOCK
now gets -EAGAIN where the splice blocked before. sendfile(2) from
a TLS socket changes the same way, because do_sendfile() leaves the
input file's O_NONBLOCK out of the splice flags. Both now behave as
they do on a plain TCP socket.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Signed-off-by: Chuck Lever <cel@kernel.org>
Link: https://patch.msgid.link/20261027015215.605919-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d1ad31986cf2c..79639ed79821c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2007,10 +2007,14 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
+	bool nonblock;
 	int chunk;
 	int err;
 
-	err = tls_rx_reader_lock(sk, ctx, flags & SPLICE_F_NONBLOCK);
+	nonblock = flags & SPLICE_F_NONBLOCK ||
+		   sock->file->f_flags & O_NONBLOCK;
+
+	err = tls_rx_reader_lock(sk, ctx, nonblock);
 	if (err < 0)
 		return err;
 
@@ -2024,8 +2028,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	} else {
 		struct tls_decrypt_arg darg;
 
-		err = tls_rx_rec_wait(sk, flags & SPLICE_F_NONBLOCK,
-				      true, false);
+		err = tls_rx_rec_wait(sk, nonblock, true, false);
 		if (err <= 0)
 			goto splice_read_end;
 
-- 
2.53.0



