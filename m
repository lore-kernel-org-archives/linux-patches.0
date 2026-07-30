Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D2333D4E2;
	Thu, 30 Jul 2026 14:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422088; cv=none; b=pnXkJDO/4u28w93z/8jE5Mc5jSsIFbLk4c6yKTJ9mVD6CDsFgGCB3V3FOIdmhEiHeH8aA8JFjhJQ28dma6vQMDdS46qwTYyfoKdel9wy1EQX+oH/brEGXpDemoS6uivReOsuQBDRLliYpijkugmhvN2x+WUB9Fl6bLjq1NF2P/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422088; c=relaxed/simple;
	bh=T2Pg3wZ05edabOy4sjKfd/sSmdPxQ5uwwmOGcpzNTFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqDRdMI3XzmgF+6kZ60XqnOGhbXYIAsPYhZ54vioDZJyDv4Ymsh63e4uyLMWhcgQcFxO/3qJD9qV8y4Fe2N7xA7E4TqC0pG5ie4A5g4L9LhalKHn/tjp3CjW5NvucWGfOibpmql/2NbIWkzVkTQP+amvjm6rb+1rO7IEM7ZFLaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpnc2TFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpnc2TFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763211F00A3A;
	Thu, 30 Jul 2026 14:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422087;
	bh=E2R+mBlVVAbSYdSonnHN/QgaHjaZcSDWhGqU5vMgCww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpnc2TFI2xxxuf0TW2Qh2kp7OjkexFGDkdnKFKVH5HN7hcz575lPlmO4zGn101W2w
	 eXvssEjWAtDpx3/BTeBPHGGOP7zPPgS4FZav5yoUSZDnDAbkguISrL8TyUEHxgNc4g
	 jNVqfwp31zJcTID1kWpKbyHcXIx4EWYaZ5wFjLzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nils Juenemann <nils.juenemann@gmail.com>,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 276/744] tls: device: push pending open record on splice EOF
Date: Thu, 30 Jul 2026 16:09:09 +0200
Message-ID: <20260730141450.156064255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 99c8eff9783e68..33c42f65364a22 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -595,13 +595,15 @@ void tls_device_splice_eof(struct socket *sock)
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



