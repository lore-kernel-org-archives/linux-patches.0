Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074FD44E66F;
	Thu, 30 Jul 2026 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424890; cv=none; b=beVXUz7YuYDCfxtUNplcAL4g/1jg9vV7shvmNOdGr/xBARqUWv7AZr+gAtpeY6KeH2hgf8oOVXnixO/WZJ9Kj3cMwe2EHXSt+zlZ06S/6q/FPSxWe20WR6NMsmUscNxtPH/mOewxQ+xYrXr2eWPJXt67UT6AI5kM501JCoR+B7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424890; c=relaxed/simple;
	bh=Iwrusthf9GeWKizwbqnD+VSiHo3QgpmX0NkNG3CWdTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNZs42Cv+zOxpQjf9QEQllZQ1huRmQXy/CfgNgwRxfk4ySFNvKMBqmZ0qg5MOGXK2v42i+cnh50a6KGP/O1W3M8w0jbu6iag/AbtNmYQHkVZBqXKnGh1m1XBSBPfR6kNdaudnEcmLKr0d89FvNmyHo/UGhbTZyYPhoMY2Toj3bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D3byVeX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D3byVeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF0A1F00A3D;
	Thu, 30 Jul 2026 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424888;
	bh=VSMc05coZjaGR1Z+S1TLisqH5c8xgY79H5jsmluL4Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1D3byVeXbjUlKiUjfbqGU3iBUIbNoeEs4yi0Fr6wKzjEudlNuT0vdi1i/1B1z/SS4
	 NVzN+w0zGP0SlfM4Z0RGI2S6R1evAxX9FxmPi48tDJOBZuyIY8bv4Z9tV7IXUwWF5s
	 Elmgez++dQu4iWeQNUjFyCWUOztUIJsEf7HzR8pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Qi Tang <tpluszz77@gmail.com>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 508/675] sctp: avoid auth_enable sysctl UAF during netns teardown
Date: Thu, 30 Jul 2026 16:13:58 +0200
Message-ID: <20260730141455.926184178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Zhiling Zou <roxy520tt@gmail.com>

commit f8d5e7846025f4ab15a461235f8ebae9094a361a upstream.

proc_sctp_do_auth() updates the SCTP control socket after changing
net.sctp.auth_enable. The handler gets the per-net SCTP state from
ctl->data, so an already opened sysctl file can still target a network
namespace while that namespace is being torn down.

SCTP previously registered its per-net sysctls from sctp_defaults_init(),
while the control socket is created later from sctp_ctrlsock_init(). This
exposed a window during initialization where auth_enable was writable
before net->sctp.ctl_sock existed, and a teardown window where auth_enable
stayed writable after inet_ctl_sock_destroy() had released the control
socket.

Move the per-net SCTP sysctl registration into sctp_ctrlsock_init() after
sctp_ctl_sock_init() succeeds, and unregister the sysctl table before
destroying the control socket in sctp_ctrlsock_exit(). If sysctl
registration fails after the control socket was created, destroy the
control socket in the same init path.

Make sctp_sysctl_net_unregister() tolerate a missing header and clear the
saved pointer so init-error and exit paths can safely share the unregister
helper.

Fixes: 15649fd5415e ("sctp: sysctl: auth_enable: avoid using current->nsproxy")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Qi Tang <tpluszz77@gmail.com>
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/390cd5e91ed60eea27b0b64d0468301a9e73b808.1784033357.git.roxy520tt@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/protocol.c |   20 ++++++++++++--------
 net/sctp/sysctl.c   |    9 +++++++--
 2 files changed, 19 insertions(+), 10 deletions(-)

--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1410,10 +1410,6 @@ static int __net_init sctp_defaults_init
 	net->sctp.l3mdev_accept = 1;
 #endif
 
-	status = sctp_sysctl_net_register(net);
-	if (status)
-		goto err_sysctl_register;
-
 	/* Allocate and initialise sctp mibs.  */
 	status = init_sctp_mibs(net);
 	if (status)
@@ -1447,8 +1443,6 @@ err_init_proc:
 	cleanup_sctp_mibs(net);
 #endif
 err_init_mibs:
-	sctp_sysctl_net_unregister(net);
-err_sysctl_register:
 	return status;
 }
 
@@ -1463,7 +1457,6 @@ static void __net_exit sctp_defaults_exi
 	net->sctp.proc_net_sctp = NULL;
 #endif
 	cleanup_sctp_mibs(net);
-	sctp_sysctl_net_unregister(net);
 }
 
 static struct pernet_operations sctp_defaults_ops = {
@@ -1477,16 +1470,27 @@ static int __net_init sctp_ctrlsock_init
 
 	/* Initialize the control inode/socket for handling OOTB packets.  */
 	status = sctp_ctl_sock_init(net);
-	if (status)
+	if (status) {
 		pr_err("Failed to initialize the SCTP control sock\n");
+		return status;
+	}
+
+	status = sctp_sysctl_net_register(net);
+	if (status) {
+		inet_ctl_sock_destroy(net->sctp.ctl_sock);
+		net->sctp.ctl_sock = NULL;
+	}
 
 	return status;
 }
 
 static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
+	sctp_sysctl_net_unregister(net);
+
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
+	net->sctp.ctl_sock = NULL;
 }
 
 static struct pernet_operations sctp_ctrlsock_ops = {
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -615,11 +615,16 @@ int sctp_sysctl_net_register(struct net
 
 void sctp_sysctl_net_unregister(struct net *net)
 {
+	struct ctl_table_header *header = net->sctp.sysctl_header;
 	const struct ctl_table *table;
 
-	table = net->sctp.sysctl_header->ctl_table_arg;
-	unregister_net_sysctl_table(net->sctp.sysctl_header);
+	if (!header)
+		return;
+
+	table = header->ctl_table_arg;
+	unregister_net_sysctl_table(header);
 	kfree(table);
+	net->sctp.sysctl_header = NULL;
 }
 
 static struct ctl_table_header *sctp_sysctl_header;


