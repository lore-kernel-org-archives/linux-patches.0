Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0FC4E3224;
	Thu, 17 Sep 2026 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659047; cv=none; b=V/a6/P1M+uqRwKT4JXObmJ5sev4llW+wU9/XOpr3yhCjHfi0OhD5Y2zGjjgKLS3/WEUpkn5XB3VGpHaS6LeUxtRamls0cUjZlS9SrFXFd1rWUiYwDvyFEe5ZR9k8XNt6NPneIMOXtePALU1lYOWGPEFjAV6SjT4+XzBJVcKxEdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659047; c=relaxed/simple;
	bh=+oFFj3YLqkjiDeRLrSRvcm4JTbqaz5jyRA5jE3Gd2Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGInMbjRQIGsl8miY7q2zfDkYrkxPo2OPs1TdPiVxHH9HncVaAteOQLQZzFAl2LOjxmI3ZF2f+jKZMtMcLaAzlU7+21oSvM8xqSmyCVEIrZ7P9qFjVr7MUFtN7uwkOW4Bw7WXiX6+wWxOwakE7+/IZ54mj/0+qgShMEjofcdHt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9EaeeWI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9EaeeWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CEA1F00893;
	Thu, 17 Sep 2026 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659034;
	bh=66jkb6b25i3Sm5RfU80HExx+HuMAiTKCjHikCecQj7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9EaeeWIbCS0BgaC/Dg9G6rgaqT7lWqwFg+Cga7zZJ4zvwlSRqfxqOwkmE9C7erwQ
	 6Z5JMXBJLPLZBNtjcOnKDXFlajmwsHyINQgjN9hMLhPRDRYuQccIxYpYba0KudNml7
	 zHoUJ0u7/YOTtT3w8apk5ZWqbkd4ebCDzh9S36X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 082/733] netfs: Fix i_size update for partial transfer
Date: Thu, 17 Sep 2026 16:06:30 +0100
Message-ID: <20260917151352.939982745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 741416a8003b77e636dafade408f808d96ac3f47 ]

Fix netfs_unbuffered_write_done() to pass the amount written to
netfs_update_i_size() in the event of a partial transfer that ends in an
error.

That said, it might be better for the filesystem to mark the inode data as
invalid and recheck it in case something like a network error occurred that
prevented the reply from the server from being received.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-5-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/direct_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index e563532c2e598..e07e7850a5a21 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -21,7 +21,7 @@ static void netfs_unbuffered_write_done(struct netfs_io_request *wreq)
 	/* Okay, declare that all I/O is complete. */
 	trace_netfs_rreq(wreq, netfs_rreq_trace_write_done);
 
-	if (!wreq->error)
+	if (wreq->transferred)
 		netfs_update_i_size(ictx, &ictx->inode, wreq->start, wreq->transferred);
 
 	if (wreq->origin == NETFS_DIO_WRITE &&
-- 
2.53.0



