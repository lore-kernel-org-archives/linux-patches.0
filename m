Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C2979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27E5C433D6;
	Wed, 30 Nov 2022 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834305;
	bh=EVfho+zLHPxYxdwXd9akYpefZ3o0MbhXSCRSb8mNpyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta6NK/I/f8AGqo5aQOlsHP7pi6LbakwjD70duEGbdzVtWFZi67j/JLYbI2fSr822q
	 ogfKH7sN4nGBh6Dn/hQSWR89XR8SLYJ9Vp9f/j09bpaX0WkxQyR4xKR9r2Xq4yVsq4
	 wuNJJqDQKd3dYtEUcW5HqwkW48X0O3/txCPijYmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 167/289] cifs: Use after free in debug code
Date: Wed, 30 Nov 2022 19:22:32 +0100
Message-Id: <20221130180547.918599330@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f391d6ee002ea022c62dc0b09d0578f3ccce81be upstream.

This debug code dereferences "old_iface" after it was already freed by
the call to release_iface().  Re-order the debugging to avoid this
issue.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Cc: stable@vger.kernel.org # 5.19+
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/sess.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 92e4278ec35d..9e7d9f0baa18 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -302,14 +302,14 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	/* now drop the ref to the current iface */
 	if (old_iface && iface) {
-		kref_put(&old_iface->refcount, release_iface);
 		cifs_dbg(FYI, "replacing iface: %pIS with %pIS\n",
 			 &old_iface->sockaddr,
 			 &iface->sockaddr);
-	} else if (old_iface) {
 		kref_put(&old_iface->refcount, release_iface);
+	} else if (old_iface) {
 		cifs_dbg(FYI, "releasing ref to iface: %pIS\n",
 			 &old_iface->sockaddr);
+		kref_put(&old_iface->refcount, release_iface);
 	} else {
 		WARN_ON(!iface);
 		cifs_dbg(FYI, "adding new iface: %pIS\n", &iface->sockaddr);
-- 
2.38.1



