Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE33C18C02E;
	Fri, 27 Sep 2024 12:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440281; cv=none; b=X3u68nem2zr4tyKytfXKIrcNxk73Y9WqrZK1iyxNumRi9rm+XijZDvOEd7/nuw8PsXlzFIXKXJIEX6rxQdbhaleeR2cXcx3ObHVopWcOpAp5DbjRwnyyXFpNFj2fA/ArJaPb65xodwOJDr5Bqx9MtI2i207mrBYpx4Oq4GD8LkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440281; c=relaxed/simple;
	bh=iR062jz7BZKz7NreMSgpJt91oJ2ZGkihomyxH/GG0Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMaYurTHBJOajwE5dRk7eHhjOB/v3zTiQNYV4gxlU3VY2u4qRC3o0IpljyI8flw7TtuvkBZdZ2T9eD7Xbu3zUsJ3XwBYM6fYpDgj35bq1s6V4G/6C8o9P8BUYo8+ENNOKMbcSrXk0HWmHPn1Cwxgq+9QcwnTtHiyzc78Rm6rJUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEP5qhwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEP5qhwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B525C4CECD;
	Fri, 27 Sep 2024 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440281;
	bh=iR062jz7BZKz7NreMSgpJt91oJ2ZGkihomyxH/GG0Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEP5qhwJ3ug/97o6FjJwoxqFEvPGG/sS/oRJCiRrEfNNMq3g6qQ7pROeBP21g3amx
	 VF6CFMorai6B07dGspatYiQDVzxLlmKvBHF3BQxIY5dvSDTSIIsop2DuF704E6pb+5
	 wudj27sL7DBiJ0RNG8wBaZzu/Wg2xD/LeTh6QuX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rickard Andersson <rickaran@axis.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/73] smb: client: fix hang in wait_for_response() for negproto
Date: Fri, 27 Sep 2024 14:23:36 +0200
Message-ID: <20240927121720.908927333@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 21b344762d0f8..87ce71b39b771 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -673,6 +673,19 @@ allocate_buffers(struct TCP_Server_Info *server)
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
@@ -684,7 +697,6 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
 	 *     a response in >60s.
 	 */
-	spin_lock(&server->srv_lock);
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
-- 
2.43.0



