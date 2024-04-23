Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1149C20B3E;
	Tue, 23 Apr 2024 21:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908483; cv=none; b=oNkk/dusbEy7kXLMsGbs1hwX9O+AVsRvfTi1/PlfCTlNAc3gS1VLa4B7h11geSujarG/FTvDXggr/iQ09okkHA75QjvQKWFAVg8fc0n5PgNhIK4IT6N1xU7Vwa0JD4uSY8bQUwF8lsBVcDnWie8I5+dUB2M/AS8WVPrXo3M4ERo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908483; c=relaxed/simple;
	bh=qfkyt+jrNfmNMRqsq80ZTMzPgdI+g/XL395Wrx8sB/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILF91OkRJghpxoOUGrW3xWEOQSw2xhvfybUbY70GCB0AFcOzs2ruvJRYYPrTyCtNGinp40snjfCvJNXueajprXflT0fDZjcI/XdzEUBPoyxFf4qdydrICXcWPJu+YShz2VAIEkk09HoAt7n7HH8VywcEZ58wWVksEzP6FZtqlM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGUCkBLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGUCkBLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD5C32786;
	Tue, 23 Apr 2024 21:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908482;
	bh=qfkyt+jrNfmNMRqsq80ZTMzPgdI+g/XL395Wrx8sB/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGUCkBLzWWCZNwxNuxgfvXoK8hZMhpGVEMMB8aM2YByEtGHeqw8RobhyQ64TSe8Rn
	 zbKtNcQW5PQmm/LM1Z47o3FiWYkEf6k/cv6V7Z677U44uvmi6haZ9+UoW5jPkFOcyQ
	 Ui5GrWTwbEPljq3nkgkdDbrcX1cEkgSMRiA1Zcjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 030/158] selftests/tcp_ao: Make RST tests less flaky
Date: Tue, 23 Apr 2024 14:37:32 -0700
Message-ID: <20240423213856.857617275@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <0x7f454c46@gmail.com>

[ Upstream commit 4225dfa4535f219b03ae14147d9c6e7e82ec8df4 ]

Currently, "active reset" cases are flaky, because select() is called
for 3 sockets, while only 2 are expected to receive RST.
The idea of the third socket was to get into request_sock_queue,
but the test mistakenly attempted to connect() after the listener
socket was shut down.

Repair this test, it's important to check the different kernel
code-paths for signing RST TCP-AO segments.

Fixes: c6df7b2361d7 ("selftests/net: Add TCP-AO RST test")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_ao/rst.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_ao/rst.c b/tools/testing/selftests/net/tcp_ao/rst.c
index 7df8b8700e39e..a2fe88d35ac06 100644
--- a/tools/testing/selftests/net/tcp_ao/rst.c
+++ b/tools/testing/selftests/net/tcp_ao/rst.c
@@ -256,8 +256,6 @@ static int test_wait_fds(int sk[], size_t nr, bool is_writable[],
 
 static void test_client_active_rst(unsigned int port)
 {
-	/* one in queue, another accept()ed */
-	unsigned int wait_for = backlog + 2;
 	int i, sk[3], err;
 	bool is_writable[ARRAY_SIZE(sk)] = {false};
 	unsigned int last = ARRAY_SIZE(sk) - 1;
@@ -275,16 +273,20 @@ static void test_client_active_rst(unsigned int port)
 	for (i = 0; i < last; i++) {
 		err = _test_connect_socket(sk[i], this_ip_dest, port,
 					       (i == 0) ? TEST_TIMEOUT_SEC : -1);
-
 		if (err < 0)
 			test_error("failed to connect()");
 	}
 
-	synchronize_threads(); /* 2: connection accept()ed, another queued */
-	err = test_wait_fds(sk, last, is_writable, wait_for, TEST_TIMEOUT_SEC);
+	synchronize_threads(); /* 2: two connections: one accept()ed, another queued */
+	err = test_wait_fds(sk, last, is_writable, last, TEST_TIMEOUT_SEC);
 	if (err < 0)
 		test_error("test_wait_fds(): %d", err);
 
+	/* async connect() with third sk to get into request_sock_queue */
+	err = _test_connect_socket(sk[last], this_ip_dest, port, -1);
+	if (err < 0)
+		test_error("failed to connect()");
+
 	synchronize_threads(); /* 3: close listen socket */
 	if (test_client_verify(sk[0], packet_sz, quota / packet_sz, TEST_TIMEOUT_SEC))
 		test_fail("Failed to send data on connected socket");
@@ -292,13 +294,14 @@ static void test_client_active_rst(unsigned int port)
 		test_ok("Verified established tcp connection");
 
 	synchronize_threads(); /* 4: finishing up */
-	err = _test_connect_socket(sk[last], this_ip_dest, port, -1);
-	if (err < 0)
-		test_error("failed to connect()");
 
 	synchronize_threads(); /* 5: closed active sk */
-	err = test_wait_fds(sk, ARRAY_SIZE(sk), NULL,
-			    wait_for, TEST_TIMEOUT_SEC);
+	/*
+	 * Wait for 2 connections: one accepted, another in the accept queue,
+	 * the one in request_sock_queue won't get fully established, so
+	 * doesn't receive an active RST, see inet_csk_listen_stop().
+	 */
+	err = test_wait_fds(sk, last, NULL, last, TEST_TIMEOUT_SEC);
 	if (err < 0)
 		test_error("select(): %d", err);
 
-- 
2.43.0



