Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B4156F25;
	Tue, 18 Jun 2024 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715749; cv=none; b=MT4iRJ8n2iTHNKSyrjHMD/bnB4rFu+Xc9mdgLd//s7r7La63KgWOXUBUSdzt26JfYBe6T0vNykIc4b7rpQuER3oMT+Acf6lZYRDH6PGr8pZamODPQRlyzeEtW5wX8+YlslJJ2URSqfTzUvcYiGipNGXRQ4gIpSxEcnuZPFlkAXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715749; c=relaxed/simple;
	bh=2qPd6aNsCY/984rozba+rqyLwL3nJXO0p58yBL7S7Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWdxW3tQSHOE4G1ui5K/NU8f0VXLC5zdav6JcDWuHQkwem6s+pYVeDGQdulEsBOXmBLCIh2OiVRxg90SylolDIpOP362N/IIM1iaGtAdtV/WAZcekiq1+mmNNaMXIRy0ac7IrmcRuR1l6wIhzQ3V0torDKKp1/xEnlwCrpipXaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqS/8QMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqS/8QMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1BBC3277B;
	Tue, 18 Jun 2024 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715748;
	bh=2qPd6aNsCY/984rozba+rqyLwL3nJXO0p58yBL7S7Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqS/8QMPx3d++nxs64MFd/rj7YMVBCDL0e/j0yRX3eJWDxbdHOloM0HnN56qMtzux
	 mHJQnJ1M22NFbfv3VapetZcqPVCIrKEX6KXNcPs66rco6Ljmf2icQtRtIvK0FwAm39
	 Jm3cYimr1fw1ZYzo2BDSp3iPvY/1tqaC/40GjYUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/770] fanotify: Wrap object_fh inline space in a creator macro
Date: Tue, 18 Jun 2024 14:33:55 +0200
Message-ID: <20240618123422.021627329@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 2c5069433a3adc01ff9c5673567961bb7f138074 ]

fanotify_error_event would duplicate this sequence of declarations that
already exist elsewhere with a slight different size.  Create a helper
macro to avoid code duplication.

Link: https://lore.kernel.org/r/20211025192746.66445-23-krisman@collabora.com
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 2b032b79d5b06..3510d06654ed0 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -171,12 +171,18 @@ static inline void fanotify_init_event(struct fanotify_event *event,
 	event->pid = NULL;
 }
 
+#define FANOTIFY_INLINE_FH(name, size)					\
+struct {								\
+	struct fanotify_fh (name);					\
+	/* Space for object_fh.buf[] - access with fanotify_fh_buf() */	\
+	unsigned char _inline_fh_buf[(size)];				\
+}
+
 struct fanotify_fid_event {
 	struct fanotify_event fae;
 	__kernel_fsid_t fsid;
-	struct fanotify_fh object_fh;
-	/* Reserve space in object_fh.buf[] - access with fanotify_fh_buf() */
-	unsigned char _inline_fh_buf[FANOTIFY_INLINE_FH_LEN];
+
+	FANOTIFY_INLINE_FH(object_fh, FANOTIFY_INLINE_FH_LEN);
 };
 
 static inline struct fanotify_fid_event *
-- 
2.43.0



