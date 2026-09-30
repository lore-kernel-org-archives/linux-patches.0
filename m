Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA84FECCF;
	Wed, 30 Sep 2026 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788562; cv=none; b=hntrpYIxw4tkX7hQ8G+36yjv23QJRK1VZkdSj6dsxN/s4J2WrfX692zI8C0xrJe6CMH3re4woDj0QiKSJNqs2PglYdSI6DQ6TBMXICzGup2/rdwn9Sj7kpxep5FFevSNcXay3jvXL1D/oEXmmgobBWg7jsGdnpsL2Cav5Z5jEbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788562; c=relaxed/simple;
	bh=XIa0qmTbGvixQdVGiSflNs1VXm/viyYEe5IKehgoxcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ17+mPxnWsLZGAD2DYvbhhFx/UDmmtxJeWQrID8eoh+8kFZCGtm1uoj4ejNRZBAQg+DCjaaQ0e6jjW2Mz/IMcUrLgpLhKXJpoo5iKl+wCyWN//kDdOVQZNuuSjjCvXsb+47YtVMMG7474LCcjUWYvorUkfzmnwGEdvoUZ00ZYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVBuXblz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVBuXblz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBDE1F000FF;
	Wed, 30 Sep 2026 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788560;
	bh=NToEyRDmuu8QiNhA2Fja2a/8gQGcxqvXdvZJrz/CVeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVBuXblzbLXtrERF5BAG5o7yaFHeVeczlCuSIB5jlLkdlvgjBk9sH0P36mUf464EE
	 1N8Mpi7l6Akv+jSR9OGA5L0LQfZJubQOUnORe8+gubf0G6+nUdkBm//VqbsydJkO38
	 CVDcFHdEEZslbEgWsysudDfI99b60X9qBlrigHN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 169/877] cifs: Fix server use-after-free in cifs_chan_skip_or_disable()
Date: Wed, 30 Sep 2026 17:18:00 +0200
Message-ID: <20260930152418.371091549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 717e0a25036b6c92cecace30913b2d874a4c22b8 upstream.

When a secondary channel is no longer supported by the server,
cifs_chan_skip_or_disable() drops the channel reference with
cifs_put_tcp_session() and then continues to use the server pointer by
calling cifs_signal_cifsd_for_reconnect() on it and reading its
primary_server pointer. cifs_put_tcp_session() can drop the last
reference of the channel and tear it down, so both the channel and the
primary server (whose reference is also dropped by
cifs_put_tcp_session()) can be freed before they are signaled for
reconnect.

Signal the channel and the primary server and capture the primary
server pointer before dropping the channel reference with
cifs_put_tcp_session().

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -188,18 +188,19 @@ cifs_chan_skip_or_disable(struct cifs_se
 		spin_unlock(&ses->chan_lock);
 
 		/*
-		 * the above reference of server by channel
-		 * needs to be dropped without holding chan_lock
-		 * as cifs_put_tcp_session takes a higher lock
-		 * i.e. cifs_tcp_ses_lock
+		 * signal the channel and its primary server to
+		 * reconnect before dropping the above reference of
+		 * server by channel, which is done without holding
+		 * chan_lock as cifs_put_tcp_session takes a higher
+		 * lock i.e. cifs_tcp_ses_lock
 		 */
-		cifs_put_tcp_session(server, from_reconnect);
-
 		cifs_signal_cifsd_for_reconnect(server, false);
 
 		/* mark primary server as needing reconnect */
 		pserver = server->primary_server;
 		cifs_signal_cifsd_for_reconnect(pserver, false);
+
+		cifs_put_tcp_session(server, from_reconnect);
 skip_terminate:
 		return -EHOSTDOWN;
 	}


