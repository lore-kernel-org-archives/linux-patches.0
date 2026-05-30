Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F419D8AC;
	Sat, 30 May 2026 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163327; cv=none; b=CxOWm3X86q8MgcX7i+Uvlr4ew7Q//Usg1iEDwrZYIR5qKdUZ4JR6Cz0eFbHkudBrFDgcMDeRBNc7UbrVigU4IRLxT5x3Z6e5w8k0Yx9vGbnbB51iyy1r/cbQu3xn286e1058BiT6gQt0VBbo8KA7mKu4n/CBQK88Yn+tylrIBmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163327; c=relaxed/simple;
	bh=rMdYFjzRwYqE89/FMMzDSSl4GVto7V3ZG6Z1anP/sK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+y18gQVyKSM9ks7amVnk5fAwILL6oem6a43nH/zZYuxS1Jb8QiJcnZU5eUjeBDfSJEsw/1zMjVMx4Rym0XMwt9KrWqx2grovdreMb+fZzFGK8VYSaL9KxZfPYEhJ6qEAoaZo3BvHWyhso04H7zRThbPj0nIq5e1gkdPo8191ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chB+77sS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chB+77sS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35501F00893;
	Sat, 30 May 2026 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163326;
	bh=MB7PLRL9hk5/Gs3C0XKwDmtDISfXhmoIyZ8NKAGuU18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chB+77sS7fT1qMtwRVyjmRUvNIcQSXLAhUo7rCisprxF4/EsWDO0MT+GUQcNP1Pd+
	 OI0MhTGxg9DZY84knysJpAUzBQ/UwmzLmCrU/+aFrsHjchDB6A7UDfh35ZbRmA0Lbr
	 coY/OCa3UTr8wGzIOQZnSkzK56bMXVLaGir5Mx7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 224/776] libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()
Date: Sat, 30 May 2026 17:58:58 +0200
Message-ID: <20260530160246.310608911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 5199c125d25aeae8615c4fc31652cc0fe624338e upstream.

If a message of type CEPH_MSG_AUTH_REPLY contains a zero value for both
protocol and result, this is currently not treated as an error. In case
of ac->negotiating == true and ac->protocol > 0, this leads to setting
ac->protocol = 0 and ac->ops = NULL. Thereafter, the check for
ac->protocol != protocol returns false, and init_protocol() is not
called. Subsequently, ac->ops->handle_reply() is called, which leads to
a null pointer dereference, because ac->ops is still NULL.

This patch changes the check for ac->protocol != protocol to
!ac->protocol, as this also includes the case when the protocol was set
to zero in the message. This causes the message to be treated as
containing a bad auth protocol.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -245,7 +245,7 @@ int ceph_handle_auth_reply(struct ceph_a
 			ac->protocol = 0;
 			ac->ops = NULL;
 		}
-		if (ac->protocol != protocol) {
+		if (!ac->protocol) {
 			ret = init_protocol(ac, protocol);
 			if (ret) {
 				pr_err("auth protocol '%s' init failed: %d\n",


