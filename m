Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9C5411A09;
	Thu, 30 Jul 2026 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423021; cv=none; b=tAqFzUiqOREr5UIeTqekVMrCNS6qwCnsSYiQ6/o5FCuhAeDg+Ko8YLTEKxEiluNCTB+xJ7mTK06NXczLyRrrwutrsiJFntSs2NDgKfxAQqTU8vUGcSOKBA+5DCm9ycGKYkG4mtA33jCR8V6HedS0Zjlq87j+gY969ZHjeFj5jUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423021; c=relaxed/simple;
	bh=5UBtYCiRg78J5mVk14P21fcBNY1uUam0q+ArNLTMC08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIFCznm/dtigwFYzfyzpW76r8bVfNpU7IbVv1pQB8o7LRPl0egs6xnwqIxgecjx6iUSncgT0mtVbTnTaDOwaaNN9sbDw5bG6el6SQCHU5BzHPHi6KE0+zejK+saYh8BuDh7ausmR95s4c39U6V1k1/2mLoSo8btWMVcxctBWN0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G41Z5BWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G41Z5BWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E361F000E9;
	Thu, 30 Jul 2026 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423020;
	bh=JK/fWENvSQ90xJE42lSjFJ4KmMI62Ma5tslObI1LIo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G41Z5BWxre97QRWgMf2VF+7GsV3ZEvOBST8Gpkop4WfyZ9AbdSzNbBCLU+8ac9iSZ
	 cl7/zmICDnCSfbanzRUh3o1PpxD7lg0mSGDiwKa9qnXryLgxoiXAJVEywS6kErETAY
	 ii74nQ4BX3c5i57mfmnVjYYRwjiPQI67FEsgLOXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 637/744] libceph: remove debugfs files before client teardown
Date: Thu, 30 Jul 2026 16:15:10 +0200
Message-ID: <20260730141457.811955927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douya Le <ldy3087146292@gmail.com>

commit e4c804726c4afce3ba648b982d564f6af2cfa328 upstream.

ceph_destroy_client() tears down the monitor client before removing
the per-client debugfs files. A concurrent read of the monmap debugfs
file can enter monmap_show() after ceph_monc_stop() has freed
monc->monmap, triggering a use-after-free.

Remove the debugfs files before stopping the OSD and monitor clients.
debugfs_remove() drains active handlers and prevents new accesses, so
the debugfs callbacks can no longer race the rest of client teardown.

Cc: stable@vger.kernel.org
Fixes: 76aa844d5b2f ("ceph: debugfs")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/ceph_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -762,13 +762,13 @@ void ceph_destroy_client(struct ceph_cli
 
 	atomic_set(&client->msgr.stopping, 1);
 
+	ceph_debugfs_client_cleanup(client);
+
 	/* unmount */
 	ceph_osdc_stop(&client->osdc);
 	ceph_monc_stop(&client->monc);
 	ceph_messenger_fini(&client->msgr);
 
-	ceph_debugfs_client_cleanup(client);
-
 	ceph_destroy_options(client->options);
 
 	kfree(client);


