Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC158F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F945C433C7;
	Sun, 16 Jul 2023 20:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539840;
	bh=zlvEsLOkG4kkRovVqDbJ/93nGlrHZJk91USNVtd+s3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5weafPEtdS/gKENiwZq5UuQ7c2CxOBY4obptueMzg3kHOWTetQvd02rCtY+SbILa
	 Dyi6UOnhz3nGmrLo7mDxwwC3DEuwiowMc0hzFU10BIkO6efqlEz3ubudUMQhjMu+sp
	 xP90touTfvjWbmajmFT33tf9X8hz5WVBv7Nwc/Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Mark Fasheh <mark@fasheh.com>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@oss.oracle.com,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/591] ocfs2: Fix use of slab data with sendpage
Date: Sun, 16 Jul 2023 21:44:32 +0200
Message-ID: <20230716194927.316678989@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 86d7bd6e66e9925f0f04a7bcf3c92c05fdfefb5a ]

ocfs2 uses kzalloc() to allocate buffers for o2net_hand, o2net_keep_req and
o2net_keep_resp and then passes these to sendpage.  This isn't really
allowed as the lifetime of slab objects is not controlled by page ref -
though in this case it will probably work.  sendmsg() with MSG_SPLICE_PAGES
will, however, print a warning and give an error.

Fix it to use folio_alloc() instead to allocate a buffer for the handshake
message, keepalive request and reply messages.

Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mark Fasheh <mark@fasheh.com>
cc: Kurt Hackel <kurt.hackel@oracle.com>
cc: Joel Becker <jlbec@evilplan.org>
cc: Joseph Qi <joseph.qi@linux.alibaba.com>
cc: ocfs2-devel@oss.oracle.com
Link: https://lore.kernel.org/r/20230623225513.2732256-14-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/tcp.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 785cabd71d670..4e083e25d0e7d 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -2083,18 +2083,24 @@ void o2net_stop_listening(struct o2nm_node *node)
 
 int o2net_init(void)
 {
+	struct folio *folio;
+	void *p;
 	unsigned long i;
 
 	o2quo_init();
-
 	o2net_debugfs_init();
 
-	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
-	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp)
+	folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!folio)
 		goto out;
 
+	p = folio_address(folio);
+	o2net_hand = p;
+	p += sizeof(struct o2net_handshake);
+	o2net_keep_req = p;
+	p += sizeof(struct o2net_msg);
+	o2net_keep_resp = p;
+
 	o2net_hand->protocol_version = cpu_to_be64(O2NET_PROTOCOL_VERSION);
 	o2net_hand->connector_id = cpu_to_be64(1);
 
@@ -2120,9 +2126,6 @@ int o2net_init(void)
 	return 0;
 
 out:
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
 	o2net_debugfs_exit();
 	o2quo_exit();
 	return -ENOMEM;
@@ -2131,8 +2134,6 @@ int o2net_init(void)
 void o2net_exit(void)
 {
 	o2quo_exit();
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
 	o2net_debugfs_exit();
+	folio_put(virt_to_folio(o2net_hand));
 }
-- 
2.39.2



