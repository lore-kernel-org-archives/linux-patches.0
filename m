Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC144470A;
	Tue, 21 Jul 2026 22:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672370; cv=none; b=VQCi7QeHP0KL8CpZnBqOJTOPgCTDaHWXD2OHQR7vXkbyq/pFSVuifs5QFfEoTRKax7L3OZbOCgMgboSJyn+wy+I0LGIrEP1fylhFqZn7ukFQLtaaB9Q2FyeHB0giF4tzWi+sHdd0Jv0NEFzRs9CEln5IQbkKmA/E/xq5wek1i2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672370; c=relaxed/simple;
	bh=uvyA5AsmOniS0q/GroUkzYC+nD5PmYNCkqawrYlhd/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwBgooqcWAyMxCc13gz+3Gnk6OVAfE66r00ZC/QKHWQzHwDgbZh3/DzyTYZwAIm4Z7OmkObEpaqN8KuPEQwy3j8trJSjhAhN0uH5aaL2X6fMrx/zFl27SPLBPwER5NTTzG2Ce8/hI/++8nVgbCEdftGjINVlwmZsWA1G5oPmhTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZHOelX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZHOelX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351241F000E9;
	Tue, 21 Jul 2026 22:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672367;
	bh=NwnfGzoFJaB6p3E0N8FsfSVzATugRIFYP65ZVA0fgTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZHOelX3jI+A7XpztH9uGaz0IwoYnafRIb1bwoEuJLvHT/Cnv+0xE/cF4Qw9muRIl
	 DcSSStn8g7VCwYeZL0lrsrrQKLynCTbOR9rgiFrIl3A+IAuQIafIxNMnGTTUVnQPJo
	 6lDJPq9Cu3kM6wln0eZcn0FkvbDsM6WBoVM4b2nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 599/843] Bluetooth: SCO: fix sleeping under spinlock in sco_conn_ready
Date: Tue, 21 Jul 2026 17:23:54 +0200
Message-ID: <20260721152419.522349547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

commit b819db93d73f4593636299e229914052b89e3ef2 upstream.

sco_conn_ready calls sleeping functions under conn->lock spinlock.

The critical section can be reduced: conn->hcon is modified only with
hdev->lock held. It is guaranteed to be held in sco_conn_ready, so
conn->lock is not needed to guard it.

Move taking conn->lock after lock_sock(parent). This also follows the
lock ordering lock_sock() > conn->lock elsewhere in the file.

Fixes: 27c24fda62b60 ("Bluetooth: switch to lock_sock in SCO")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1126,26 +1126,24 @@ static void sco_conn_ready(struct sco_co
 		sk->sk_state_change(sk);
 		release_sock(sk);
 	} else {
-		sco_conn_lock(conn);
-
-		if (!conn->hcon) {
-			sco_conn_unlock(conn);
+		if (!conn->hcon)
 			return;
-		}
+
+		lockdep_assert_held(&conn->hcon->hdev->lock);
 
 		parent = sco_get_sock_listen(&conn->hcon->src);
-		if (!parent) {
-			sco_conn_unlock(conn);
+		if (!parent)
 			return;
-		}
 
 		lock_sock(parent);
 
+		sco_conn_lock(conn);
+
 		sk = sco_sock_alloc(sock_net(parent), NULL,
 				    BTPROTO_SCO, GFP_ATOMIC, 0);
 		if (!sk) {
-			release_sock(parent);
 			sco_conn_unlock(conn);
+			release_sock(parent);
 			return;
 		}
 
@@ -1165,9 +1163,9 @@ static void sco_conn_ready(struct sco_co
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		release_sock(parent);
-
 		sco_conn_unlock(conn);
+
+		release_sock(parent);
 	}
 }
 


