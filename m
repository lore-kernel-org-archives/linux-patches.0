Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3795237B012;
	Thu, 30 Jul 2026 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426378; cv=none; b=VjbFDcZAOyQ7lEFoQXZuktHPWkL0WyYxr4I8hw4aQQJrYdFHAXVWPSKChQ25vAmgCKVfc+fjwQPaKOuKFjHCUK7qDjzKWwsJs6K3pu3Q5/gIHPDJQ4DX9PU9HMGm4kALTyp8SJ+EuDZIh2KfFQf/8jRmlcYsmvgzqtnTRB6/dFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426378; c=relaxed/simple;
	bh=2MUUvlv+V1fASfpbNyM6QPmB7T0LFQ4F/sQEBHO9Igo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIRXoMqcDSTGbDH1mN+yXQ6ZxgF7d/h4eJJYPTvsxf+8kP+q/eOR8S5EbbmvMhWE8cT/zbiFO1EMWiJ9/ge3t1eY6iGPrl6yNrxqlxbgsZ86iBZfWCEMP4202ymOG0gKPR5irmiZ5ZfnhfHhLMvLOaxQvjcOMpUPMMlqIDORwCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGa0gmQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGa0gmQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0541F000E9;
	Thu, 30 Jul 2026 15:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426377;
	bh=ELNXqAvDCuORtugtTD24NghA3lNb/GwiAF6FcmJNP84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGa0gmQMY2ili17z9XoYxRSwXDv64OCVr/TVurOeHhj0n8B712OvoRa+Nsr6hGF9k
	 sAkMZHlQdWpeBOfCEE5hFCSigYC6wL+qJsW4sL5tI73nxzQN73fHy6xNpWmVf5c0Sj
	 JPh4i5/QwZ/CSHQBdC2J1OqCfq6PxtRDEjH3T39A=
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
Subject: [PATCH 6.12 398/602] libceph: remove debugfs files before client teardown
Date: Thu, 30 Jul 2026 16:13:10 +0200
Message-ID: <20260730141444.324494239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -763,13 +763,13 @@ void ceph_destroy_client(struct ceph_cli
 
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


