Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3345F3A48C2;
	Sat, 17 Oct 2026 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254618; cv=none; b=CgygBIe4I3ExqZmJA54MKP1YMluPX53oqhVXkzRecM8y1R/dEJwkgITijDSinjCKXK4xgiMQwtCWocvx7R2jg/VI68DxJIBrGrtwjRvLs2wu0ttg7S/EysCuxiceK57uTetOgRtLR8ISydJvEbX751HY97pbvP75E1fHZW1gIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254618; c=relaxed/simple;
	bh=4i5PBhZ1yd/lQwNmLzXuyObKHbPTrPXyJMtJrP/uYms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvYWQF8eq+OL56Ne9Lj2HTKehXn3IE34okabQu/dzOeh9O+I6X6kya6qe50MHnOUax3Dgfgzou1ll72pmDJHF7/HmfEkovFySt8shrcSetSLGRBjeN7u7xeUAjnSMfF7efY4V33iALYO7Yjwa3J/oY/6sON8v7Wu291SLowLNYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts0VLFnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts0VLFnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8501F000C4;
	Sat, 17 Oct 2026 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254616;
	bh=p9XJ1pU+QxB9wDRSKVwr0+/F2rPWjXmfmk1yYIdYaKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ts0VLFnZu8akvKC/KH2nba3+riPfm6qO6sBgWRVuKwReGBBqXQeLtTI5lTrZNCPXE
	 9F0yjFKc5FY9FZD5S9fWTJ8IK1ICDfYA8fRG9FskQcOhVrI88TnLo/r2rZltkY4ln1
	 5SOwq+b5CWMpiPM6nwKpxnx12XitxIfcm51RYnP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 505/869] selftests: tls: add rekey tests
Date: Sat, 17 Oct 2026 17:55:46 +0200
Message-ID: <20261017160050.052901557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 555f0edb9ff043196655a5b7cc65f67dfd05b530 ]

Test the kernel's ability to:
 - update the key (but not the version or cipher), only for TLS1.3
 - pause decryption after receiving a KeyUpdate message, until a new
   RX key has been provided
 - reflect the pause/non-readable socket in poll()

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1c8629651cb5 ("tls: rx: restore msg_iter before TLS 1.3 optimistic retry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 458 ++++++++++++++++++++++++++++++
 1 file changed, 458 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index f27a12d2a2c99..1264a20c1a04e 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1649,6 +1649,464 @@ TEST_F(tls, recv_efault)
 		EXPECT_EQ(memcmp(rec2, recv_mem + 9, ret - 9), 0);
 }
 
+#define TLS_RECORD_TYPE_HANDSHAKE      0x16
+/* key_update, length 1, update_not_requested */
+static const char key_update_msg[] = "\x18\x00\x00\x01\x00";
+static void tls_send_keyupdate(struct __test_metadata *_metadata, int fd)
+{
+	size_t len = sizeof(key_update_msg);
+
+	EXPECT_EQ(tls_send_cmsg(fd, TLS_RECORD_TYPE_HANDSHAKE,
+				(char *)key_update_msg, len, 0),
+		  len);
+}
+
+static void tls_recv_keyupdate(struct __test_metadata *_metadata, int fd, int flags)
+{
+	char buf[100];
+
+	EXPECT_EQ(tls_recv_cmsg(_metadata, fd, TLS_RECORD_TYPE_HANDSHAKE, buf, sizeof(buf), flags),
+		  sizeof(key_update_msg));
+	EXPECT_EQ(memcmp(buf, key_update_msg, sizeof(key_update_msg)), 0);
+}
+
+/* set the key to 0 then 1 for RX, immediately to 1 for TX */
+TEST_F(tls_basic, rekey_rx)
+{
+	struct tls_crypto_info_keys tls12_0, tls12_1;
+	char const *test_str = "test_message";
+	int send_len = strlen(test_str) + 1;
+	char buf[20];
+	int ret;
+
+	if (self->notls)
+		return;
+
+	tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
+			     &tls12_0, 0);
+	tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
+			     &tls12_1, 1);
+
+	ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_1, tls12_1.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_0, tls12_0.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_1, tls12_1.len);
+	EXPECT_EQ(ret, 0);
+
+	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
+	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
+}
+
+/* set the key to 0 then 1 for TX, immediately to 1 for RX */
+TEST_F(tls_basic, rekey_tx)
+{
+	struct tls_crypto_info_keys tls12_0, tls12_1;
+	char const *test_str = "test_message";
+	int send_len = strlen(test_str) + 1;
+	char buf[20];
+	int ret;
+
+	if (self->notls)
+		return;
+
+	tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
+			     &tls12_0, 0);
+	tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
+			     &tls12_1, 1);
+
+	ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_0, tls12_0.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_1, tls12_1.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_1, tls12_1.len);
+	EXPECT_EQ(ret, 0);
+
+	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
+	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
+}
+
+TEST_F(tls, rekey)
+{
+	char const *test_str_1 = "test_message_before_rekey";
+	char const *test_str_2 = "test_message_after_rekey";
+	struct tls_crypto_info_keys tls12;
+	int send_len;
+	char buf[100];
+
+	if (variant->tls_version != TLS_1_3_VERSION)
+		return;
+
+	/* initial send/recv */
+	send_len = strlen(test_str_1) + 1;
+	EXPECT_EQ(send(self->fd, test_str_1, send_len, 0), send_len);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
+	EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
+
+	/* update TX key */
+	tls_send_keyupdate(_metadata, self->fd);
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	/* send after rekey */
+	send_len = strlen(test_str_2) + 1;
+	EXPECT_EQ(send(self->fd, test_str_2, send_len, 0), send_len);
+
+	/* can't receive the KeyUpdate without a control message */
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
+
+	/* get KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, 0);
+
+	/* recv blocking -> -EKEYEXPIRED */
+	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EKEYEXPIRED);
+
+	/* recv non-blocking -> -EKEYEXPIRED */
+	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_DONTWAIT), -1);
+	EXPECT_EQ(errno, EKEYEXPIRED);
+
+	/* update RX key */
+	EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+
+	/* recv after rekey */
+	EXPECT_NE(recv(self->cfd, buf, send_len, 0), -1);
+	EXPECT_EQ(memcmp(buf, test_str_2, send_len), 0);
+}
+
+TEST_F(tls, rekey_fail)
+{
+	char const *test_str_1 = "test_message_before_rekey";
+	char const *test_str_2 = "test_message_after_rekey";
+	struct tls_crypto_info_keys tls12;
+	int send_len;
+	char buf[100];
+
+	/* initial send/recv */
+	send_len = strlen(test_str_1) + 1;
+	EXPECT_EQ(send(self->fd, test_str_1, send_len, 0), send_len);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
+	EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
+
+	/* update TX key */
+	tls_send_keyupdate(_metadata, self->fd);
+
+	if (variant->tls_version != TLS_1_3_VERSION) {
+		/* just check that rekey is not supported and return */
+		tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+		EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), -1);
+		EXPECT_EQ(errno, EBUSY);
+		return;
+	}
+
+	/* successful update */
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	/* invalid update: change of version */
+	tls_crypto_info_init(TLS_1_2_VERSION, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/* invalid update (RX socket): change of version */
+	tls_crypto_info_init(TLS_1_2_VERSION, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/* invalid update: change of cipher */
+	if (variant->cipher_type == TLS_CIPHER_AES_GCM_256)
+		tls_crypto_info_init(variant->tls_version, TLS_CIPHER_CHACHA20_POLY1305, &tls12, 1);
+	else
+		tls_crypto_info_init(variant->tls_version, TLS_CIPHER_AES_GCM_256, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/* send after rekey, the invalid updates shouldn't have an effect */
+	send_len = strlen(test_str_2) + 1;
+	EXPECT_EQ(send(self->fd, test_str_2, send_len, 0), send_len);
+
+	/* can't receive the KeyUpdate without a control message */
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
+
+	/* get KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, 0);
+
+	/* recv blocking -> -EKEYEXPIRED */
+	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EKEYEXPIRED);
+
+	/* recv non-blocking -> -EKEYEXPIRED */
+	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_DONTWAIT), -1);
+	EXPECT_EQ(errno, EKEYEXPIRED);
+
+	/* update RX key */
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+
+	/* recv after rekey */
+	EXPECT_NE(recv(self->cfd, buf, send_len, 0), -1);
+	EXPECT_EQ(memcmp(buf, test_str_2, send_len), 0);
+}
+
+TEST_F(tls, rekey_peek)
+{
+	char const *test_str_1 = "test_message_before_rekey";
+	struct tls_crypto_info_keys tls12;
+	int send_len;
+	char buf[100];
+
+	if (variant->tls_version != TLS_1_3_VERSION)
+		return;
+
+	send_len = strlen(test_str_1) + 1;
+	EXPECT_EQ(send(self->fd, test_str_1, send_len, 0), send_len);
+
+	/* update TX key */
+	tls_send_keyupdate(_metadata, self->fd);
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_PEEK), send_len);
+	EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
+
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
+	EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
+
+	/* can't receive the KeyUpdate without a control message */
+	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_PEEK), -1);
+
+	/* peek KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, MSG_PEEK);
+
+	/* get KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, 0);
+
+	/* update RX key */
+	EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+}
+
+TEST_F(tls, splice_rekey)
+{
+	int send_len = TLS_PAYLOAD_MAX_LEN / 2;
+	char mem_send[TLS_PAYLOAD_MAX_LEN];
+	char mem_recv[TLS_PAYLOAD_MAX_LEN];
+	struct tls_crypto_info_keys tls12;
+	int p[2];
+
+	if (variant->tls_version != TLS_1_3_VERSION)
+		return;
+
+	memrnd(mem_send, sizeof(mem_send));
+
+	ASSERT_GE(pipe(p), 0);
+	EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
+
+	/* update TX key */
+	tls_send_keyupdate(_metadata, self->fd);
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
+
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), send_len);
+	EXPECT_EQ(read(p[0], mem_recv, send_len), send_len);
+	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
+
+	/* can't splice the KeyUpdate */
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/* peek KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, MSG_PEEK);
+
+	/* get KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, 0);
+
+	/* can't splice before updating the key */
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), -1);
+	EXPECT_EQ(errno, EKEYEXPIRED);
+
+	/* update RX key */
+	EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), send_len);
+	EXPECT_EQ(read(p[0], mem_recv, send_len), send_len);
+	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
+}
+
+TEST_F(tls, rekey_peek_splice)
+{
+	char const *test_str_1 = "test_message_before_rekey";
+	struct tls_crypto_info_keys tls12;
+	int send_len;
+	char buf[100];
+	char mem_recv[TLS_PAYLOAD_MAX_LEN];
+	int p[2];
+
+	if (variant->tls_version != TLS_1_3_VERSION)
+		return;
+
+	ASSERT_GE(pipe(p), 0);
+
+	send_len = strlen(test_str_1) + 1;
+	EXPECT_EQ(send(self->fd, test_str_1, send_len, 0), send_len);
+
+	/* update TX key */
+	tls_send_keyupdate(_metadata, self->fd);
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_PEEK), send_len);
+	EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
+
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), send_len);
+	EXPECT_EQ(read(p[0], mem_recv, send_len), send_len);
+	EXPECT_EQ(memcmp(mem_recv, test_str_1, send_len), 0);
+}
+
+TEST_F(tls, rekey_getsockopt)
+{
+	struct tls_crypto_info_keys tls12;
+	struct tls_crypto_info_keys tls12_get;
+	socklen_t len;
+
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 0);
+
+	len = tls12.len;
+	EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_get, &len), 0);
+	EXPECT_EQ(len, tls12.len);
+	EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
+
+	len = tls12.len;
+	EXPECT_EQ(getsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_get, &len), 0);
+	EXPECT_EQ(len, tls12.len);
+	EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
+
+	if (variant->tls_version != TLS_1_3_VERSION)
+		return;
+
+	tls_send_keyupdate(_metadata, self->fd);
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	tls_recv_keyupdate(_metadata, self->cfd, 0);
+	EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+
+	len = tls12.len;
+	EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_get, &len), 0);
+	EXPECT_EQ(len, tls12.len);
+	EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
+
+	len = tls12.len;
+	EXPECT_EQ(getsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_get, &len), 0);
+	EXPECT_EQ(len, tls12.len);
+	EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
+}
+
+TEST_F(tls, rekey_poll_pending)
+{
+	char const *test_str = "test_message_after_rekey";
+	struct tls_crypto_info_keys tls12;
+	struct pollfd pfd = { };
+	int send_len;
+	int ret;
+
+	if (variant->tls_version != TLS_1_3_VERSION)
+		return;
+
+	/* update TX key */
+	tls_send_keyupdate(_metadata, self->fd);
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	/* get KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, 0);
+
+	/* send immediately after rekey */
+	send_len = strlen(test_str) + 1;
+	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
+
+	/* key hasn't been updated, expect cfd to be non-readable */
+	pfd.fd = self->cfd;
+	pfd.events = POLLIN;
+	EXPECT_EQ(poll(&pfd, 1, 0), 0);
+
+	ret = fork();
+	ASSERT_GE(ret, 0);
+
+	if (ret) {
+		int pid2, status;
+
+		/* wait before installing the new key */
+		sleep(1);
+
+		/* update RX key while poll() is sleeping */
+		EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+
+		pid2 = wait(&status);
+		EXPECT_EQ(pid2, ret);
+		EXPECT_EQ(status, 0);
+	} else {
+		pfd.fd = self->cfd;
+		pfd.events = POLLIN;
+		EXPECT_EQ(poll(&pfd, 1, 5000), 1);
+
+		exit(!__test_passed(_metadata));
+	}
+}
+
+TEST_F(tls, rekey_poll_delay)
+{
+	char const *test_str = "test_message_after_rekey";
+	struct tls_crypto_info_keys tls12;
+	struct pollfd pfd = { };
+	int send_len;
+	int ret;
+
+	if (variant->tls_version != TLS_1_3_VERSION)
+		return;
+
+	/* update TX key */
+	tls_send_keyupdate(_metadata, self->fd);
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
+	EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+
+	/* get KeyUpdate */
+	tls_recv_keyupdate(_metadata, self->cfd, 0);
+
+	ret = fork();
+	ASSERT_GE(ret, 0);
+
+	if (ret) {
+		int pid2, status;
+
+		/* wait before installing the new key */
+		sleep(1);
+
+		/* update RX key while poll() is sleeping */
+		EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+
+		sleep(1);
+		send_len = strlen(test_str) + 1;
+		EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
+
+		pid2 = wait(&status);
+		EXPECT_EQ(pid2, ret);
+		EXPECT_EQ(status, 0);
+	} else {
+		pfd.fd = self->cfd;
+		pfd.events = POLLIN;
+		EXPECT_EQ(poll(&pfd, 1, 5000), 1);
+		exit(!__test_passed(_metadata));
+	}
+}
+
 FIXTURE(tls_err)
 {
 	int fd, cfd;
-- 
2.53.0



