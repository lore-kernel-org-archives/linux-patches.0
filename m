Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC6C41836D;
	Fri,  7 Aug 2026 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115671; cv=none; b=pWBxcmchAPEYa6HUTpJ8lHJQnnuc314ANNnbyweX5+QFwTToGK05XpzO7BMJHmhZMcq692IB2GzvaawccoKi6jtet8d6ZiWHUdgNggvqykaKDwev7Qk6NwY7OxkZ7Rm62tzTUSiqus5a/Bz4s2Dx38HxJcRYHkVFwGITvc/bobY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115671; c=relaxed/simple;
	bh=RI9RqMh7osk+igrXWX0LpwTDif1zdEuLYabZiXl1eCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8IRR6VHtCV4Px7fKgbupDw8oFtsTxVTZJFanXFCncz8yLvaFUb54wavK8CuaWw1BPxQQQ4qWposXwsU9GHBLTKVmO4tR7sDkoJ3rJ3W6884EeDfPY82WxBGlbkKWTwe7PzPiCaMxvtm3mZMrxKReCdzTcQYavQQ6B/AuMA1eyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYQWUnuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYQWUnuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96371F000E9;
	Fri,  7 Aug 2026 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115670;
	bh=4sY7L9v0vZEgVTocKY45sVeZarT2WOE2v+kCfQPBTok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYQWUnuLxp6dQuiYzHJE4Pau7Du5wgXzWqjnSEaBgRd4lmURtmPGeSAurkOfTPh9N
	 wXHwBrkPcu6ZDNcO/Gn4BOMHMUxAWI95gv46GG801f5wvHRExO9RqcsR/+fulxcXDF
	 sm7nQpNGPcQQdAnK4LpOgEmvjA8i66KwfFcgKZP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/396] net/handshake: convert handshake_nl_accept_doit() to FD_PREPARE()
Date: Fri,  7 Aug 2026 16:38:38 +0200
Message-ID: <20260807143432.007137667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit fe67b063f687d8f32c466778aad57508bc1c618a ]

Link: https://patch.msgid.link/20251123-work-fd-prepare-v4-27-b6efa1706cfd@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
(cherry picked from commit fe67b063f687d8f32c466778aad57508bc1c618a)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/netlink.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index d8211e0ba75c6..7b1d42607ae68 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -93,7 +93,7 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	struct handshake_net *hn = handshake_pernet(net);
 	struct handshake_req *req = NULL;
 	struct socket *sock;
-	int class, fd, err;
+	int class, err;
 
 	err = -EOPNOTSUPP;
 	if (!hn)
@@ -106,27 +106,25 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 
 	err = -EAGAIN;
 	req = handshake_req_next(hn, class);
-	if (!req)
-		goto out_status;
-
-	sock = req->hr_sk->sk_socket;
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0) {
-		err = fd;
-		goto out_complete;
-	}
-
-	err = req->hr_proto->hp_accept(req, info, fd);
-	if (err) {
-		put_unused_fd(fd);
-		goto out_complete;
+	if (req) {
+		sock = req->hr_sk->sk_socket;
+
+		FD_PREPARE(fdf, O_CLOEXEC, sock->file);
+		if (fdf.err) {
+			err = fdf.err;
+			goto out_complete;
+		}
+
+		get_file(sock->file); /* FD_PREPARE() consumes a reference. */
+		err = req->hr_proto->hp_accept(req, info, fd_prepare_fd(fdf));
+		if (err)
+			goto out_complete; /* Automatic cleanup handles fput */
+
+		trace_handshake_cmd_accept(net, req, req->hr_sk, fd_prepare_fd(fdf));
+		fd_publish(fdf);
+		return 0;
 	}
 
-	fd_install(fd, get_file(sock->file));
-
-	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
-	return 0;
-
 out_complete:
 	handshake_complete(req, -EIO, NULL);
 out_status:
-- 
2.53.0



