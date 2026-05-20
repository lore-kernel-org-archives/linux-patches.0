Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1281B372B31;
	Wed, 20 May 2026 18:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301337; cv=none; b=X8ZvdOnGt820xbur9AzAmYL3y5/9Lfegg8fSISNcdVEXOBXZG5F4ZAYmerUnzmN4n34JxzrI7rlbwrfnMmSW60Q8dTxc/C0DQkIHyGIhe4qGx3k5TuDk9Np+LOXsvwrcs6GFB9h+LMU3jyy8l0tQE+p6xMAY87Oac5Qtyd3imYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301337; c=relaxed/simple;
	bh=HMOu+PTW28CZfBLiIJCYyi3uPUeScAa2w81pfDau9D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gULw/Ue7bL21fkGbcElSyiuuQPhoyuJosNknugSZIJJy4TqqL/j8vj41tdUOAjd8iFUKt8piPc+SqMZNQGoKmE1vXk1QRnDZLxe/7eMMlsMNzmE64mabcSMzcYgu9VjKtqaQR1ukKwOjNFQ7GNtJRG7Qas+x+Yzn+1FTuzU0pt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ8jHqIN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ8jHqIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0FC1F00893;
	Wed, 20 May 2026 18:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301335;
	bh=9rM3e4hCVG5haXXDCHFex7CGvCKvHQElS0vOydZv5RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQ8jHqIN95fVyvzfFHrf3ll2xKSI6fKgzM56qSehogfIG7IVrNbRPVPg8uVjKKGPL
	 a4azjRNn7Ji4wtouT7DlpMkH5C6yTyx3Ysk4cPVTk+ofcyBUv2zXYnFrT+YllGuvOs
	 vDQDYfZP5NwWzPUvNuZReX2QlpnmcR6oUTvjb258=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/666] ksmbd: destroy async_ida in ksmbd_conn_free()
Date: Wed, 20 May 2026 18:21:30 +0200
Message-ID: <20260520162121.648022725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit b32c8db48212a34998c36d0bbc05b29d5c407ef5 ]

When per-connection async_ida was converted from a dynamically
allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
removed from the connection teardown path but no matching
ida_destroy() was added.  The connection is therefore freed with the
IDA's backing xarray still intact.

The kernel IDA API expects ida_init() and ida_destroy() to be paired
over an object's lifetime, so add the missing cleanup before the
connection is freed.

No leak has been observed in testing; this is a pairing fix to match
the IDA lifetime rules, not a response to a reproduced regression.

Fixes: d40012a83f87 ("cifsd: declare ida statically")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 8470aba1233a9..1610b4d2fd414 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -41,6 +41,15 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
 	if (atomic_dec_and_test(&conn->refcnt)) {
+		/*
+		 * async_ida is embedded in struct ksmbd_conn, so pair
+		 * ida_destroy() with the final kfree() rather than with
+		 * the unconditional field teardown above.  This keeps
+		 * the IDA valid for the entire lifetime of the struct,
+		 * even while other refcount holders (oplock / vfs
+		 * durable handles) still reference the connection.
+		 */
+		ida_destroy(&conn->async_ida);
 		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
 	}
-- 
2.53.0



