Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CE3768EA;
	Mon,  8 Apr 2024 13:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583378; cv=none; b=Yz3W5JKATgWu2hmb7s+SreVLka6x6WR9Y3b4Q0Wg+pqcgsOV1n1C0r4KncS87QP9nQSzfIvPxZoSD1BaKvWGwgRmSkfATvK14FE8YG6pxOWKgW0iD36bMxr59xCKLUP2rrdNwNA+I4jO97+9YUzvozEkso7yShhIs8Qyw8yaT1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583378; c=relaxed/simple;
	bh=Kgn6zkLEnRTN1pnKd4guJOcFCEGKqKEBksJwS7iNivE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvFC/rTCB+mghcfjnhWCca6RGTBVaR/vL3ASiuQq+9nqaexxhjg7aCq3kW0lEOkJ+lYWC4tAF3d91BfE3larvMV8znSwZwMk44odI0yfBpR3Qrk5vGTtx4PmEBE+7e4unI/0cFDVGodMVCkYqNFf3P8z9wuNB8WbOFUqezeMM8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaQKM2b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaQKM2b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA6AC433F1;
	Mon,  8 Apr 2024 13:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583378;
	bh=Kgn6zkLEnRTN1pnKd4guJOcFCEGKqKEBksJwS7iNivE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaQKM2b+JVomhHIYj/VlGisY78PY8Cjx97CwrUNEXjr4zuIf7TvK8R2Q69/I5l6FS
	 PFw86g9YqdK5zwHbpoWike4HnyWpCvIjpQtBoHyOQU8oPIPjO8j2OtHeIp2xeRjJcB
	 651WCHtnxayUgRQd4Ahw5ckCY/qidw7NvdEX/SHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 241/690] lockd: rename lockd_create_svc() to lockd_get()
Date: Mon,  8 Apr 2024 14:51:47 +0200
Message-ID: <20240408125408.385243112@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit ecd3ad68d2c6d3ae178a63a2d9a02c392904fd36 ]

lockd_create_svc() already does an svc_get() if the service already
exists, so it is more like a "get" than a "create".

So:
 - Move the increment of nlmsvc_users into the function as well
 - rename to lockd_get().

It is now the inverse of lockd_put().

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 7f12c280fd30d..1a7c11118b320 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -396,16 +396,14 @@ static const struct svc_serv_ops lockd_sv_ops = {
 	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
 };
 
-static int lockd_create_svc(void)
+static int lockd_get(void)
 {
 	struct svc_serv *serv;
 	int error;
 
-	/*
-	 * Check whether we're already up and running.
-	 */
 	if (nlmsvc_serv) {
 		svc_get(nlmsvc_serv);
+		nlmsvc_users++;
 		return 0;
 	}
 
@@ -439,6 +437,7 @@ static int lockd_create_svc(void)
 	register_inet6addr_notifier(&lockd_inet6addr_notifier);
 #endif
 	dprintk("lockd_up: service created\n");
+	nlmsvc_users++;
 	return 0;
 }
 
@@ -472,10 +471,9 @@ int lockd_up(struct net *net, const struct cred *cred)
 
 	mutex_lock(&nlmsvc_mutex);
 
-	error = lockd_create_svc();
+	error = lockd_get();
 	if (error)
 		goto err;
-	nlmsvc_users++;
 
 	error = lockd_up_net(nlmsvc_serv, net, cred);
 	if (error < 0) {
-- 
2.43.0



