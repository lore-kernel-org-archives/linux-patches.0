Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EE313BAFB;
	Tue, 18 Jun 2024 13:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715811; cv=none; b=j4sWUmpupP49LxfNPN44zo3hN7DQ/PQPWepKTuDao+Rq7TSB/edXSABenaoL83u2DJkaOTu1ehYE8zoPQ7l5MszhH7LmII8iEI+c72q3cV+7evGr/o8eJGFRB1yhl2Bh2v5X8+/+BzQfHFVkUf+W+yfVQVXGUlwaprFAjUV1lIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715811; c=relaxed/simple;
	bh=pB8pUGB+nmLld84h9fZYbmHumxPYci7GVlJ4LqzuvRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgrzW6I8RCxzatqRp5LJLRvTb/Kqt8Xwah3VRKLQYlMhDsXGWQpKQJ3noog4d+OuogIYqkcF1bcFjMagDFsrHyfRrqtWNzB9lNDBjy6yiyzy75zVomLM8sR0ZWqSNeEt/zBZdeTicyFSpTULzYGlU4muU8zPCpXr0gGHCnPgOBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiGcSf2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiGcSf2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A6DC3277B;
	Tue, 18 Jun 2024 13:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715811;
	bh=pB8pUGB+nmLld84h9fZYbmHumxPYci7GVlJ4LqzuvRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiGcSf2PysLDIq0y3lmRKVewYZ7unVZzdmt/gugmHa08T1ydWlDXcXd6qA0vWZnWv
	 K88+juBkE5F1/NIjoBDcqwLpIDoMWd7BDolMu4W0Om7FOEpr34Jo9Y8qqX4LHQWWtJ
	 wWAL0YFY3Eggm0r+3DeVzzelpfYJOCFZubNNo5/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/770] lockd: rename lockd_create_svc() to lockd_get()
Date: Tue, 18 Jun 2024 14:34:47 +0200
Message-ID: <20240618123424.039423482@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



