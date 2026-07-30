Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A62372ECB;
	Thu, 30 Jul 2026 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424023; cv=none; b=SqVUCVMIU0RG3ipwB+pWMts11J3mkVG4q4/sXfTMiBW41GHNGJEy2rXuGQT8xacA7lSOYLEp11lRKZ9YdVMOeQ7A5JxIQOSNUjelX6w6Vdx2o7eU6RjBzRBKZL085A/agz6Y2PhL+hA/mfJwG4Y0zJn2XK8SU0xcQ77E6tbeeXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424023; c=relaxed/simple;
	bh=NBAD/qs/erDUrE7DTrovYxHZvURPSJs4xU2ogfzjV9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVtNdkTHaWOV4SDBSfsgsqwVgQVfqnpb3TwmNgHel4KK+LGLU3W81W0ng3jPIb2lAYos6eUzKdyb91je+w6LBl2J9qnixc3OEfCwBzms/FH27bEQnnG4PDyS5B46wSBaS3net2BcU30p1r2wkCNozyNYSH8+mX5HLq3kQqYcwe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sO5Etu5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sO5Etu5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB121F000E9;
	Thu, 30 Jul 2026 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424021;
	bh=k7F81jpycXpWeyNaMDa1AxyW9HkxxuQ+GfL8SsDV8EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sO5Etu5HPoy+YSxChee9H7Llv/Ht409vfZh6c8JcFC0orJ5RTGjamw0+ZYRXqDV9K
	 9aoKhREt/o+9i2KOJnP4sMoSNagGSO7etmDpvsSDT6wTH7lHOwxUFLEbbS+dO8E8bC
	 uvwRqRWWh3J/vuLIIGkqXu6DY+9hgbzypHTAkB24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nils Juenemann <nils.juenemann@gmail.com>,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 247/675] tls: device: push pending open record on splice EOF
Date: Thu, 30 Jul 2026 16:09:37 +0200
Message-ID: <20260730141450.385393323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71734411ff4c3a..d2e3870590c894 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -594,13 +594,15 @@ void tls_device_splice_eof(struct socket *sock)
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



