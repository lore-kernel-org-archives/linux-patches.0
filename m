Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDDE5C9E;
	Mon, 13 Apr 2026 16:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096936; cv=none; b=VbFV4skpdcnr1evAYpX8DD5QBIpcC7vfkrUSuIXIyJ8A9Vke4omaMDUfWfzFk4+HKu9kSmBBm4lcKhmj9i/wC5sgVun6LtGjC6byC+4K5ayLaCT3MDEq61PABDix/R3fTCbXK0eVN0tMPLx5QBzzGLFV+iJdQpx8zb1XCgLxb+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096936; c=relaxed/simple;
	bh=pphS1h6dRLtR5T44SgYGcEXsIHIBEVYuc1vqnlH9XRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLHY4qxx5CdTj3zNEKS9E6veXXBzr+Sdt8ToP5Aj5+ODhejxdXThgecrsMy0XIiHqDuOKtZUR4jmC/oIkN5/kQfSy0gdBQbFFdznDaOno25eR92J5/6+IGgSSz60Ew+GY4+Ri/90tn9st4u6ezGaSFtoNVkOs4N8lwX2V6fcB80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcZ9HSdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcZ9HSdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0ABC2BCAF;
	Mon, 13 Apr 2026 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096936;
	bh=pphS1h6dRLtR5T44SgYGcEXsIHIBEVYuc1vqnlH9XRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcZ9HSdI4deI1daheuH8xF1JCLN+1XuBK3hRYTInavQx+3Muv3S2YWxzRt5mREGqU
	 zIGzbxq+iUt2qXp7skXoVtd9uZqwLVYjA9Irxhlc6da8FOREpDqsyjG3UFGCQ3lCaa
	 Ldlp1n3dakHplmYMhC0WqHYDVmEA/XUkBSnsIBSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 32/50] net/tls: fix use-after-free in -EBUSY error path of tls_do_encryption
Date: Mon, 13 Apr 2026 18:00:59 +0200
Message-ID: <20260413155725.714342034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

From: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>

commit a9b8b18364fffce4c451e6f6fd218fa4ab646705 upstream.

The -EBUSY handling in tls_do_encryption(), introduced by commit
859054147318 ("net: tls: handle backlogging of crypto requests"), has
a use-after-free due to double cleanup of encrypt_pending and the
scatterlist entry.

When crypto_aead_encrypt() returns -EBUSY, the request is enqueued to
the cryptd backlog and the async callback tls_encrypt_done() will be
invoked upon completion. That callback unconditionally restores the
scatterlist entry (sge->offset, sge->length) and decrements
ctx->encrypt_pending. However, if tls_encrypt_async_wait() returns an
error, the synchronous error path in tls_do_encryption() performs the
same cleanup again, double-decrementing encrypt_pending and
double-restoring the scatterlist.

The double-decrement corrupts the encrypt_pending sentinel (initialized
to 1), making tls_encrypt_async_wait() permanently skip the wait for
pending async callbacks. A subsequent sendmsg can then free the
tls_rec via bpf_exec_tx_verdict() while a cryptd callback is still
pending, resulting in a use-after-free when the callback fires on the
freed record.

Fix this by skipping the synchronous cleanup when the -EBUSY async
wait returns an error, since the callback has already handled
encrypt_pending and sge restoration.

Fixes: 859054147318 ("net: tls: handle backlogging of crypto requests")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260403013617.2838875-1-ramdhan@starlabs.sg
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -584,6 +584,16 @@ static int tls_do_encryption(struct sock
 	if (rc == -EBUSY) {
 		rc = tls_encrypt_async_wait(ctx);
 		rc = rc ?: -EINPROGRESS;
+		/*
+		 * The async callback tls_encrypt_done() has already
+		 * decremented encrypt_pending and restored the sge on
+		 * both success and error. Skip the synchronous cleanup
+		 * below on error, just remove the record and return.
+		 */
+		if (rc != -EINPROGRESS) {
+			list_del(&rec->list);
+			return rc;
+		}
 	}
 	if (!rc || rc != -EINPROGRESS) {
 		atomic_dec(&ctx->encrypt_pending);


