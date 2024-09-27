Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D0718BB91;
	Fri, 27 Sep 2024 12:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439967; cv=none; b=NTWwUf7jBrLsMnssbaK9cK0dvjQCeFgU9C7ByDmqI/DAjLLzytPEMDNgazLWL9B6LGGuwXO/QgjujFwqzaZ9/B1MpIwxwHKvOd1cNpNm4rMBP0Qr37Vd+BgTe7Fz/hZ1MXGATZq4oJBM1l7CV/IrLqKkVY7br7qX8DuaQ49z/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439967; c=relaxed/simple;
	bh=6FOp+NVYoyMOE7v+SMhrrXXSpsCQaLP4s6etK7BJJUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8f89rKC3bH28HhjsQUKa7dFS210QBMGikMNGIsj5NUQG9IFrbK+8XmIJyGwXGbfCHX7TS7Fp9buXvrEwsA4xXpvuLUlOVn56FNaWe3huV6iPm8FwWlQ53vp3IVoGkiH4DSLRJGnou2SwteAWZ9pWjbeRE4iGKAGkjnJ+/0WWcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgtI/Ou2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgtI/Ou2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C355BC4CEC4;
	Fri, 27 Sep 2024 12:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439967;
	bh=6FOp+NVYoyMOE7v+SMhrrXXSpsCQaLP4s6etK7BJJUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgtI/Ou2KenOf8yMcTP7k3zWQlSKHw5ncE5R3hCiJV0+6m3rac/bxWND9Q4eIsEty
	 Sf70oySoaqIkbTxOEvw5Br9z1FZiTm6RFmu+FdLoRw+IhLJ12hJkl/TK21dD9pRR3C
	 UVkMg7MShUyP8XLVobgR7m7wVt1A6Pv+GTdhwVVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rickard Andersson <rickaran@axis.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/54] smb: client: fix hang in wait_for_response() for negproto
Date: Fri, 27 Sep 2024 14:23:24 +0200
Message-ID: <20240927121721.042698469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 7ccc1465465d78e6411b7bd730d06e7435802b5c ]

Call cifs_reconnect() to wake up processes waiting on negotiate
protocol to handle the case where server abruptly shut down and had no
chance to properly close the socket.

Simple reproducer:

  ssh 192.168.2.100 pkill -STOP smbd
  mount.cifs //192.168.2.100/test /mnt -o ... [never returns]

Cc: Rickard Andersson <rickaran@axis.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index d2307162a2de1..e325e06357ffb 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -656,6 +656,19 @@ allocate_buffers(struct TCP_Server_Info *server)
 static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
+	/*
+	 * If we're in the process of mounting a share or reconnecting a session
+	 * and the server abruptly shut down (e.g. socket wasn't closed, packet
+	 * had been ACK'ed but no SMB response), don't wait longer than 20s to
+	 * negotiate protocol.
+	 */
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus == CifsInNegotiate &&
+	    time_after(jiffies, server->lstrp + 20 * HZ)) {
+		spin_unlock(&server->srv_lock);
+		cifs_reconnect(server, false);
+		return true;
+	}
 	/*
 	 * We need to wait 3 echo intervals to make sure we handle such
 	 * situations right:
@@ -667,7 +680,6 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
 	 *     a response in >60s.
 	 */
-	spin_lock(&server->srv_lock);
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
-- 
2.43.0



