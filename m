Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6B5370AFB;
	Tue, 21 Jul 2026 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662939; cv=none; b=TM1Kqd/Qr7oWHfZ+jYsqY/f0BB+lfjFapUsgRXo63GNsMraCc/QemAcFgXJ12NueNkHUHYLqStKVp0Hqj67HF0PfRppl3fDopq3ys6B3v2ibRFzIOqPo2ggIgAN4HhhNsvIoEjHtJ/h+SzmEe5E9z3BZ7HzoHJTTFUzBudDvufk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662939; c=relaxed/simple;
	bh=TCGwpxBFtNoOLbZH6OZ1ha7TCrpnvhqVbUvMXFO1ZnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbNQPA6WoQCGkImYHp30lAFkPtZt+E3MfFhpq371TIuVqD4cXceebqp1aqLYJuV2s91vbYH4uRHcFow+9AnS5Fl6mWf02JFBeXaeEcZGUmqgZErgvpCF7OpSl3zx3pruv1qcbENhZ+p3HynBC/nOFLdD+ZYZpV9jtibeZKybeJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0ppHCXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0ppHCXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E109D1F000E9;
	Tue, 21 Jul 2026 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662938;
	bh=y1RHEVmchs6hHXOyiCk7aAkK8XmxglBFfQ8UwqJ739I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0ppHCXP/iEGLZvfwoZ/YEy+LigFquyFKFkoQr3XqIxGGN9OTWGfO0Yszo43FNl4m
	 pnF1QYio8hecZm6Ev8raN1SxDvZ/eHdHLf5bmr/l7/9LaN2Kfvr3s4+jbp+0uaWHQt
	 hp1qc5VfVpddRaHQB4mjfEtLOIX+L6H8pQHJKyYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0633/1276] ksmbd: fix use-after-free of conn->preauth_info in concurrent SMB2 NEGOTIATE
Date: Tue, 21 Jul 2026 17:17:56 +0200
Message-ID: <20260721152500.274804780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

[ Upstream commit 0c054227479ed7e36ebccb3a558bc0ef698264f6 ]

conn->preauth_info is shared connection state (struct
preauth_integrity_info, kmalloc-96) that is allocated and freed by the
SMB2 NEGOTIATE handler and read by the response send path.

smb2_handle_negotiate() allocates conn->preauth_info, and on a
deassemble_neg_contexts() failure kfrees it and sets it to NULL. Both the
allocation and the free/NULL happen under ksmbd_conn_lock(conn) (the
connection srv_mutex), which is held across the whole handler body.

The response send path smb3_preauth_hash_rsp(), called from the send:
block of __handle_ksmbd_work(), reads conn->preauth_info and dereferences
conn->preauth_info->Preauth_HashValue (via
ksmbd_gen_preauth_integrity_hash()) without taking conn_lock. When a
client drives two SMB2 NEGOTIATE requests on the same connection, one
worker can free conn->preauth_info on the failing-negotiate path while a
concurrent send-path worker is reading it, producing a slab
use-after-free read (KASAN-confirmed).

The send-path read tested conn->preauth_info for NULL but raced with the
free that occurs between the NULL check and the dereference, so the NULL
guard alone does not close the window.

Serialize the NEGOTIATE-branch read in smb3_preauth_hash_rsp() under
ksmbd_conn_lock(conn) and re-check conn->preauth_info inside the lock.
Because the negotiate handler holds conn_lock across its kfree + NULL
assignment, a reader that also takes conn_lock either runs fully before
the allocation or fully after the NULL store, and can never observe the
freed-but-not-yet-NULLed pointer. ksmbd_gen_preauth_integrity_hash()
takes no locks itself (it only computes a SHA-512 over the buffer), so
no lock-ordering inversion is introduced, and conn_lock is a sleepable
mutex which is safe on this send path (it already performs network I/O).

Fixes: aa7253c2393f ("ksmbd: fix memory leak in smb2_handle_negotiate")
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f1cadc029677e8..25471cbb4c5eaa 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9142,10 +9142,13 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
-	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE &&
-	    conn->preauth_info)
-		ksmbd_gen_preauth_integrity_hash(conn, work->response_buf,
-						 conn->preauth_info->Preauth_HashValue);
+	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE) {
+		ksmbd_conn_lock(conn);
+		if (conn->preauth_info)
+			ksmbd_gen_preauth_integrity_hash(conn, work->response_buf,
+							 conn->preauth_info->Preauth_HashValue);
+		ksmbd_conn_unlock(conn);
+	}
 
 	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE && sess) {
 		__u8 *hash_value;
-- 
2.53.0



