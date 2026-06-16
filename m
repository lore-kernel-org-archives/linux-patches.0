Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BD7477E33;
	Tue, 16 Jun 2026 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634387; cv=none; b=TFFG72LooMqSidfyhsDBLN7jJ8myiyZlNKAzClpWdKCOKDSlez9CVIVzomsSydTKUdlELfC/yNRLbCvrz20B3/8xpZ5KfYyMy1X+6E5cEZRi0wM0D7JCwq6wAoPVrwwZ1bygBLOMw3QKJFK8Qclwpdak0lt8qtAT6wpOKSI0Jw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634387; c=relaxed/simple;
	bh=yt1ZQB69riPbuiSglgOJm9EyGd126rWaCbJzUTvA3KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI57K3Uh9r/0OO3XtDa/VvP7dRizglmmH8zjJbVyIvXFCpkqH3khz2kqJvb3r53KNhObaVsVYeTT83jEt+qxRCwq0ftX3ZXeZega+/g1Ss8CvC0D2CKFkx1nJpGKqHkZyLygxwa0fkOFUl/Y8v9E7JSP8f177WwV61ty4Jdzc6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptAZXUQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptAZXUQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DF81F000E9;
	Tue, 16 Jun 2026 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634386;
	bh=IoS5hS/31zmDQDa8EbocSvYpuPMtAoivkV8noBX8jDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptAZXUQJ+hjwDX7/wauL5g/3LmtSm/mdD3GG5TfsaIooMtC+F96wz/3JmfOx0Un8+
	 gjiIgIPos6NkHSQtj12MALIMNVsyCDIlLCgj7grRqHBECDb2pW4IzrjPO7jkhachLD
	 CEJ1DICJ48AqgR06ylUbpftusEdSz7nTE9kafrc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/411] smb: server: fix max_connections off-by-one in tcp accept path
Date: Tue, 16 Jun 2026 20:28:12 +0530
Message-ID: <20260616145114.498480169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit ce23158bfe584bd90d1918f279fdf9de57802012 ]

The global max_connections check in ksmbd's TCP accept path counts
the newly accepted connection with atomic_inc_return(), but then
rejects the connection when the result is greater than or equal to
server_conf.max_connections.

That makes the effective limit one smaller than configured. For
example:

- max_connections=1 rejects the first connection
- max_connections=2 allows only one connection

The per-IP limit in the same function uses <= correctly because it
counts only pre-existing connections. The global limit instead checks
the post-increment total, so it should reject only when that total
exceeds the configured maximum.

Fix this by changing the comparison from >= to >, so exactly
max_connections simultaneous connections are allowed and the next one
is rejected. This matches the documented meaning of max_connections
in fs/smb/server/ksmbd_netlink.h as the "Number of maximum simultaneous
connections".

Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -248,7 +248,7 @@ static int ksmbd_kthread_fn(void *p)
 		}
 
 		if (server_conf.max_connections &&
-		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
+		    atomic_inc_return(&active_num_conn) > server_conf.max_connections) {
 			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
 					    atomic_read(&active_num_conn));
 			atomic_dec(&active_num_conn);


