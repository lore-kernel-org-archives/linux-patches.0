Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0BD341ADD;
	Wed, 30 Sep 2026 19:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796229; cv=none; b=UXPc44ZlgxZ4h341B4tipyyASrXl6nqyXcrDrT/93AGEarvF/3rEjGfEsiu+JcS+8ovWDI+ETa6eqphr/5VxLoSmqQyB5+awj1nRaHVr4i70BGJ8qR7kpyfPTV/nh4mlCg10zmJXdQt2EFFozZ1dlerblOphYMLZ2wX4MsuqiwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796229; c=relaxed/simple;
	bh=mnBGG1t/OB57U4FCwCjn+BZqgG340EQnCEOUM04bl5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+ZG4u86hfsV8e+BrSphAWiVD7evnqzW2CMBFrIdOxonW82WTxC1s+QLKVu5bfyyUoz4p5zyita85eAqiyZZYn5XC0bprKEWZ18HDeTTCtXOzyZpDh693VOmiqI2ETFSo+NO9546TCBQkCY+n+sQhCr83I2WhfjO9VfNgRmFeN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTkxYVgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTkxYVgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538D31F000FF;
	Wed, 30 Sep 2026 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796227;
	bh=m6n0SYQJ7jJkLXqnHO8qlZMfwTHjFG9WbKcSgBnDjfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTkxYVgxZxue1RRQfJD/PUJ0sInk2mYWK4Q3B2XEwEFk3bW9RqkqsNNMyxCF5+jFL
	 6t73aNpf6iSTsudT6Nz9I0fKMxSE3Gjn+/+9kMNYM9A0CD//akLDRi7/U7yF8y8cAd
	 uZ4kpv8frtkvlRS2pB0vhCQaDTCBwMj8JaischW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0838/1193] cifs: Fix server use-after-free in cifs_chan_skip_or_disable()
Date: Wed, 30 Sep 2026 17:25:22 +0200
Message-ID: <20260930152452.862460970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -185,18 +185,19 @@ cifs_chan_skip_or_disable(struct cifs_se
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


