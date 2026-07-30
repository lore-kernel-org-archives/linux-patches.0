Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707B138B133;
	Thu, 30 Jul 2026 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427432; cv=none; b=Gw1fh5qhEYNgGYDV2AYyjQiCtTB2CZj62maOf9AHoQ7FoISzWKW0W+yy8quOugA1ocdJ6C5+Ujb95pB6F2A5q4XstMyKLyAI6WsZPLRGlofjy08vnzD0nZzGHhC/iGElBsJQkqRpcpNa+6yGYZX7vilUEFbL7ZMhg2NYdf2qlT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427432; c=relaxed/simple;
	bh=oJILXXqohP50ZabpC3XVJeDyO8NCAXJkARTifXJ6Ffc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTYihcSDaN1xzq10/NHT9tpvxkKa2nCIboVWc8ZAX/0yaBgIAHbSCnqB3mwqKYLsxQLOJ1kjjJE4Xsx6KwBlsJL7LY831BNue8JSKWLJOOlns1qFD00SO79O5d/F3AmveduRp06PACryQ0yp6BUJEVuPkYra185n+BbPh6ht6M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXgfb3xj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXgfb3xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F241F00A3A;
	Thu, 30 Jul 2026 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427431;
	bh=Se/qa389aQwxCDqwsEU9xXsAzwhNpZkEC7kfaO4TmyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXgfb3xjmTb66c6flOmr4M+Ox/lejJ/s+WwyFMKbwe+1TZ4s3Ff1gPYp+RuLn/9Qx
	 aeJoOAqKb6zouHt5pW9Z+3zqKIiAjerCNpWQLOzGnWLR9kzRI50FiX8cMRmXSTmvHY
	 wtF9tpcfyjeGuiEhikh1VkGBZG9jCVFY9PwOq4dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nils Juenemann <nils.juenemann@gmail.com>,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/484] tls: device: push pending open record on splice EOF
Date: Thu, 30 Jul 2026 16:11:04 +0200
Message-ID: <20260730141427.095932766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Rishikesh Jethwani <rjethwani@purestorage.com>

[ Upstream commit eaa39f9f8ac8c1d032cd26b9cd572804e9d7683f ]

On kTLS device-offload sockets, sendfile() with count > EOF can reach
->splice_eof() with a fully assembled but still-open TLS record left
pending. tls_device_splice_eof() only flushes partially sent records,
so an abrupt close() can drop the final record and the peer receives
a short file.

Fix tls_device_splice_eof() to also push pending open records.
This matches the software path, where splice EOF already flushes
pending open records.

Fixes: d4c1e80b0d1b ("tls/device: Use splice_eof() to flush")
Link: https://lore.kernel.org/netdev/CAMPsyauZ+jzG9AysO0FWv6ZY0kvCUpjX_U7o=oOjCuOQ87BCgg@mail.gmail.com/
Reported-by: Nils Juenemann <nils.juenemann@gmail.com>
Signed-off-by: Rishikesh Jethwani <rjethwani@purestorage.com>
Tested-by: Nils Juenemann <nils.juenemann@gmail.com>
Link: https://patch.msgid.link/20260709224436.1608993-2-rjethwani@purestorage.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 1fc1e8e2a9cb2c..7fce47197d0a45 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -600,13 +600,15 @@ void tls_device_splice_eof(struct socket *sock)
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct iov_iter iter = {};
 
-	if (!tls_is_partially_sent_record(tls_ctx))
+	if (!tls_is_partially_sent_record(tls_ctx) &&
+	    !tls_is_pending_open_record(tls_ctx))
 		return;
 
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
-	if (tls_is_partially_sent_record(tls_ctx)) {
+	if (tls_is_partially_sent_record(tls_ctx) ||
+	    tls_is_pending_open_record(tls_ctx)) {
 		iov_iter_bvec(&iter, ITER_SOURCE, NULL, 0, 0);
 		tls_push_data(sk, &iter, 0, 0, TLS_RECORD_TYPE_DATA);
 	}
-- 
2.53.0



