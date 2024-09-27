Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8189318BC0D;
	Fri, 27 Sep 2024 12:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440114; cv=none; b=rmiOltFwU+DmtxJePj2R9Ld5iLr4iqt/qYdjrYEU0iLl4PNy1M6o1mkb72c9WfN3AGjbv83a2NBZvWYXr3mS+1EfGYNGXP8fUupsYyvAbMOY2f8Rqk/obiphwUqKVCpT2FDzgGbGTri9K2dEZ66Jkb487hirdcjK39gTGjOaWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440114; c=relaxed/simple;
	bh=DL9gNP4/VSkOhIC5rqvEH4J2Xh0ZLFd7itwe/kl7E0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1hja809IUElCYDCruUVyZm9N4OK2PYq8bFFWifYfo1NHTn6F+BATYB/jYiUWbfFzbEv2Fu9JwOA1M+OBCWx5fjkcr/BEFnPX4drC2RZL2xZnRI/RVy6PmqCnLMicLIJq0+xovT51toMJgvY5BPg7++a53FoWOfeTSW5qpssZ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYwrjahS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYwrjahS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAE9C4CEC4;
	Fri, 27 Sep 2024 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440114;
	bh=DL9gNP4/VSkOhIC5rqvEH4J2Xh0ZLFd7itwe/kl7E0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYwrjahSG6GTUG3pcyyWcPkuW/V2bPv7Raodp2gKM4iVDNiRvDHzUb3IHKlJZqT9M
	 H0LN1UZy1UbYoTpodmo+lwBEK7U+KlDZ9Cn61wtHdyb+J5f/lU+JjPvUq0IbM/uUcP
	 F3OTgXHdw4S6ybNQU5EBGPM/k6d0UbO2nFrKSXWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rickard Andersson <rickaran@axis.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 37/58] smb: client: fix hang in wait_for_response() for negproto
Date: Fri, 27 Sep 2024 14:23:39 +0200
Message-ID: <20240927121720.287693134@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



