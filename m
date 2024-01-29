Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B8815CD54;
	Mon, 29 Jan 2024 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548140; cv=none; b=gV4IMU0JbwYe9uDIur+3wUBOWWoWzCWSmi7WsdyaAsikLTpVjnY4F4Oq9+yObSlujlXaRpcv3GwQo3rRM7O4ikSUxa0v7v+5A00scbp2j21q7UuQtCs4usWuVPqwImLg5p4szQ6snAu4/Rf73WSEVzu933gY+xJiCHLVMwonTzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548140; c=relaxed/simple;
	bh=i+yqHgGtxIET4rIfYydDJlh/5Ig+O+kREomvuj/xOe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk4bz+0BVoxg1ncue7y9MiWSFMr2A+PBGd9TUj2fZz/X2scuUpEwe9bzq9Fm+5Hebj6siavepN0Caw86MFqt3aBwkJByJMRcC+rpp65lyhM3+wX/tzy4BQNhEIrB8E7ckzQG6GgcgqPnUhMIfoIQL/pVsIlxcngtII8FFYZfNDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAC9gs1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAC9gs1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A75C43394;
	Mon, 29 Jan 2024 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548140;
	bh=i+yqHgGtxIET4rIfYydDJlh/5Ig+O+kREomvuj/xOe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAC9gs1QjCkPoNlqjpcxXzO55wvG2L9kHgLRhIjjxn9QdLRaDGlsNPpWaEk5Ykh8J
	 8b2LwRJnXM1aHnT+Uw28FlTgebyBgrrVlm3vzc35QfrMuiG5hDCYgh8v16ooA4vJUK
	 kvHYj7xRJDLgMu5zG/1pDQ2b+Yw1SeJ8qibvPIL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.7 144/346] ksmbd: Add missing set_freezable() for freezable kthread
Date: Mon, 29 Jan 2024 09:02:55 -0800
Message-ID: <20240129170020.642339841@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 8fb7b723924cc9306bc161f45496497aec733904 ]

The kernel thread function ksmbd_conn_handler_loop() invokes
the try_to_freeze() in its loop. But all the kernel threads are
non-freezable by default. So if we want to make a kernel thread to be
freezable, we have to invoke set_freezable() explicitly.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -284,6 +284,7 @@ int ksmbd_conn_handler_loop(void *p)
 		goto out;
 
 	conn->last_active = jiffies;
+	set_freezable();
 	while (ksmbd_conn_alive(conn)) {
 		if (try_to_freeze())
 			continue;


