Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C1611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41A8C433D2;
	Sun, 28 May 2023 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301685;
	bh=Kj4R2YI2m89JegjuUvVtt1Dg208D9FEudH84eVJGXJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBnaaXirC9aIIqrGVOUzFTLrLtUGdKBP2NCjCZ6Nfjp45aKULg/8YQOKKEKqM8ttY
	 Uz1VI7gtbWoZMgzhPzaefUDOUBQeh5/S6fpMIrxPJ3i1NX/eRLAuyPOmZzX7UfwDCD
	 QbASA3wsp1c/f8b2K822/L68/IwTGLiabqiAJzs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 128/132] xen/pvcalls-back: fix double frees with pvcalls_new_active_socket()
Date: Sun, 28 May 2023 20:11:07 +0100
Message-Id: <20230528190837.792453580@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 8fafac202d18230bb9926bda48e563fd2cce2a4f upstream.

In the pvcalls_new_active_socket() function, most error paths call
pvcalls_back_release_active(fedata->dev, fedata, map) which calls
sock_release() on "sock".  The bug is that the caller also frees sock.

Fix this by making every error path in pvcalls_new_active_socket()
release the sock, and don't free it in the caller.

Fixes: 5db4d286a8ef ("xen/pvcalls: implement connect command")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/e5f98dc2-0305-491f-a860-71bbd1398a2f@kili.mountain
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/pvcalls-back.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -330,8 +330,10 @@ static struct sock_mapping *pvcalls_new_
 	void *page;
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
-	if (map == NULL)
+	if (map == NULL) {
+		sock_release(sock);
 		return NULL;
+	}
 
 	map->fedata = fedata;
 	map->sock = sock;
@@ -423,10 +425,8 @@ static int pvcalls_back_connect(struct x
 					req->u.connect.ref,
 					req->u.connect.evtchn,
 					sock);
-	if (!map) {
+	if (!map)
 		ret = -EFAULT;
-		sock_release(sock);
-	}
 
 out:
 	rsp = RING_GET_RESPONSE(&fedata->ring, fedata->ring.rsp_prod_pvt++);
@@ -567,7 +567,6 @@ static void __pvcalls_back_accept(struct
 					sock);
 	if (!map) {
 		ret = -EFAULT;
-		sock_release(sock);
 		goto out_error;
 	}
 


