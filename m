Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164BD2D73A0;
	Mon, 17 Aug 2026 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974537; cv=none; b=Pw2Ms+1ZXZgjufBf+qTpeTNZPlZCwwJVON75Z42fkfAPGqTjNFaQ6kAlMZB3hTEg56OEmGNeGH0eJeSp87D9aEXkZQ/DOkn6xXXTmS91nu4pZzCEUATuOKfbnntFsVKnOdumV7jrBVuY7MoDELfUHw16qFIGqTUUhxDfQ02zwlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974537; c=relaxed/simple;
	bh=ErLiv7r/BPkJ72c//ZRTn1ONIC3d+ji/O+CpLdGrxII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ViNIin0DUMFl/gUaIuBCjjY9ZfThjjtTA36qRhesOPVlVNaLy8BXdvIWAfZ215Bv2fjd/kpMBPOanKHPyaMeFWlnxA7a92i32v9ZDiAtgQioGmO7ZR12TQ0w6xLjFBeC7j3qVyYifBjNRgFg2494FvmBrH/CpPoip36wA1uKGuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvnsSFUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvnsSFUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FC31F00A3A;
	Mon, 17 Aug 2026 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974532;
	bh=mn+HRSd0AmxR6P2ABzQZ0tjwTgLvQIsg/qkx6WIWP5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvnsSFUjc1JIbNMi08Mt68qyvB8ZzcWGmJjTErtxQhYq/cEqusT0ui5T99rMVf2xI
	 JFjAXFSUeTlg0y+XFEbFHkFd9lu0sQwoRtSnMoIWdWKrOW/Cs7gQf9R42ZnXwbeUlD
	 et5lCB+7cmu6018q90Y8o3NzIDin3HCRydjduybA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 237/271] tls: rx: restore msg_iter before TLS 1.3 optimistic retry
Date: Mon, 17 Aug 2026 15:32:42 +0200
Message-ID: <20260817132546.515909243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 1c8629651cb54f7b51db8fc0b1a9944e4a4b0f5e upstream.

tls_decrypt_sg() advances msg->msg_iter when it maps user pages for
the optimistic TLS 1.3 zero-copy path. If the decrypted record turns
out not to be unpadded application data, tls_decrypt_sw() retries into
a kernel skb, but leaves the iterator advanced.

The subsequent copy from the skb then writes decrypted bytes again at
a later point in the caller iovecs while recvmsg() reports only the
post-retry length. A TLS peer can trigger this after the receiver
enables TLS_RX_EXPECT_NO_PAD.

Revert the iterator by the number of bytes consumed by the optimistic
mapping before retrying without zero-copy.

Add a selftest which sends a TLS 1.3 control record with
TLS_RX_EXPECT_NO_PAD enabled and verifies that recvmsg() does not
overwrite later iovecs beyond the returned length.

Fixes: ce61327ce989 ("tls: rx: support optimistic decrypt to user buffer with TLS 1.3")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20260804125528.2139928-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c                  |    2 +
 tools/testing/selftests/net/tls.c |   57 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1731,6 +1731,8 @@ tls_decrypt_sw(struct sock *sk, struct t
 	/* If opportunistic TLS 1.3 ZC failed retry without ZC */
 	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
 		     darg->tail != TLS_RECORD_TYPE_DATA)) {
+		iov_iter_revert(&msg->msg_iter, strp_msg(darg->skb)->full_len -
+				prot->overhead_size);
 		darg->zc = false;
 		if (!darg->tail)
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXNOPADVIOL);
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1802,6 +1802,63 @@ TEST_F(tls, recv_efault)
 }
 
 #define TLS_RECORD_TYPE_HANDSHAKE      0x16
+
+TEST_F(tls_basic, recvmsg_nopad_retry_iov)
+{
+	char payload[32];
+	char first_iov[sizeof(payload)];
+	char later_iov[sizeof(payload) * 2];
+	char expected_later_iov[sizeof(later_iov)];
+	char cbuf[CMSG_SPACE(sizeof(char))];
+	struct tls_crypto_info_keys tls13;
+	struct iovec iov[] = {
+		{ .iov_base = first_iov, .iov_len = sizeof(first_iov) },
+		{ .iov_base = later_iov, .iov_len = sizeof(later_iov) },
+	};
+	struct msghdr msg = {
+		.msg_iov = iov,
+		.msg_iovlen = ARRAY_SIZE(iov),
+		.msg_control = cbuf,
+		.msg_controllen = sizeof(cbuf),
+	};
+	int one = 1;
+	int ret;
+	int i;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
+			     &tls13, 0);
+
+	ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls13, tls13.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls13, tls13.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->cfd, SOL_TLS, TLS_RX_EXPECT_NO_PAD,
+			 &one, sizeof(one));
+	ASSERT_EQ(ret, 0);
+
+	for (i = 0; i < sizeof(payload); i++)
+		payload[i] = 0x40 + i;
+	memset(first_iov, 0xa5, sizeof(first_iov));
+	memset(later_iov, 0x5a, sizeof(later_iov));
+	memset(expected_later_iov, 0x5a, sizeof(expected_later_iov));
+
+	/* A control record forces optimistic TLS 1.3 RX to retry. */
+	ret = tls_send_cmsg(self->fd, TLS_RECORD_TYPE_HANDSHAKE,
+			    payload, sizeof(payload), 0);
+	ASSERT_EQ(ret, sizeof(payload));
+
+	ret = recvmsg(self->cfd, &msg, 0);
+	ASSERT_EQ(ret, sizeof(payload));
+	EXPECT_EQ(memcmp(first_iov, payload, sizeof(payload)), 0);
+	EXPECT_EQ(memcmp(later_iov, expected_later_iov,
+			 sizeof(later_iov)), 0);
+}
+
 /* key_update, length 1, update_not_requested */
 static const char key_update_msg[] = "\x18\x00\x00\x01\x00";
 static void tls_send_keyupdate(struct __test_metadata *_metadata, int fd)


