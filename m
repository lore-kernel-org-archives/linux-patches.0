Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033197;
	b=zx3GJ4rVPbTF9CMoaAVKifwyllN3WRWAgt5KyGNQDw3mEMzVPeXfAmYmTF5YJJ01bwcH
	 FV5PUzzO9EDHwtt6erd/g9plPt8kcw/dcZ0DD0R+yw2o3NuNChgLfpufwggVg1zQ+w5sJ
	 hPJLD00gZam0p/IA6V/EM1JGs8D04p/TtD4XsIHd6eVlJo85XRhTUWF06hPOUSLtwVBr/
	 0ziElNAwrRgwWzpolvV96Aj/OOTKWRDlR7mgSdNA/2JdIR4mmbCgdoq/tS1/pUZrcwuMs
	 o/bj0VlnURsgLmMydKHjManIylLQQQOLMJyNTqoG3MeAO74tt6auugLDIw0Q9z0c/4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLnmYXonDqeSo/2aPDOH3bqwjkOuQzxBE4hW/2Va/pc=;
	b=gcnCL6c0a1tV+ny4vGMvTQBjIZChekmxXm0v/6OK68uo8iPHPT7tKs1B07wkHIM0f3OW
	 +qXs6j1VMG7nHSUJhr2mFUXaIcfWw9s7o4wwsaPRvYYuGTCzQSai6P3jaaPs6pO/803Iw
	 nKcGk0l4bSp7nuQaZLMorGCbDVFhC9nxUfbHCk1d1vakF7mWG/E1KCZxcL1sjoQ5j7ktr
	 GwblNaomqVb3XB+RO6l0e/AoyeJ2nLLjZTfP++PThlZhQKrbghIRwKPANWkOVfZMnSlIg
	 nnKfpLVseSfxSjdT/RDB4nRRtdyVc4HHdc8AH2KKVUcNsKHK+ziFsD3OFumAaufp+gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bdl9wU/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076B1606A332;
	Wed, 18 Nov 2026 20:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdl9wU/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D88B1F000C4;
	Wed, 18 Nov 2026 20:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033196;
	bh=zLnmYXonDqeSo/2aPDOH3bqwjkOuQzxBE4hW/2Va/pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdl9wU/TuXaf/3nSLZ3XDM5bq/xm1Ll8QHalIEodzvQX74uGBtaii7jdNUR4MVUx9
	 rPXG0P3oYlv0qbOnGiOnw/X9er27acdvmqGkNG9ecxiJspceMlMtqlvT4atixkjGvk
	 soHg8ZiCVtq9p6Ck3FI5neDGY9cvgxE6ax2cgwTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1681/1756] rnbd-srv: fix use-after-free on two CLOSE messages
Date: Wed, 18 Nov 2026 16:03:28 +0100
Message-ID: <20261118150116.621273859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 4912dab88baa5f7034dc9e38807804d470ae5438 ]

process_msg_close() looks the sess_dev up with a kref, drops it right
away, and only then takes the session mutex for the teardown. A session
has several connections handled by different workers, so two CLOSE
messages for the same ID both finish the lookup before either one tears
the sess_dev down, and the second one works on freed memory. Any host
that can open a device on the server can do that.

Take the mutex first and look the ID up with xa_load() under it. The
second CLOSE then finds nothing.

Fixes: 2de6c8de192b ("block/rnbd: server: main functionality")
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-40-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 8895862f55839..dc944a194cc3d 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -359,14 +359,15 @@ static void process_msg_close(struct rnbd_srv_session *srv_sess,
 
 	trace_process_msg_close(srv_sess, close_msg);
 
-	sess_dev = rnbd_get_sess_dev(le32_to_cpu(close_msg->device_id),
-				      srv_sess);
-	if (IS_ERR(sess_dev))
-		return;
-
-	rnbd_put_sess_dev(sess_dev);
+	/*
+	 * Each teardown of a sess_dev runs under srv_sess->lock and erases the
+	 * ID, so an entry that is found under the lock is alive.
+	 */
 	mutex_lock(&srv_sess->lock);
-	rnbd_srv_destroy_dev_session_sysfs(sess_dev);
+	sess_dev = xa_load(&srv_sess->index_idr,
+			   le32_to_cpu(close_msg->device_id));
+	if (sess_dev)
+		rnbd_srv_destroy_dev_session_sysfs(sess_dev);
 	mutex_unlock(&srv_sess->lock);
 }
 
-- 
2.53.0



