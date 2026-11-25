Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625467;
	b=B5FrbTFSlhnVcrWwAiwmicKvEV71OL71OlzWYI2o0kaQmGArGafojMRavYuPPHUjMYOT
	 TnWlGaIGzdD2ezZtsKFXnhHZbOJVwPpLviZLYVVPuqjqfiE1HBAWj4ij99B//OpCLXGdV
	 koDCQBOsz3Mk0zE3at3ojsthpoJNm3Oc+y5qhsOBxYsXID8eSCOUzSLIR33vJIzEY1CjQ
	 OkF3tY9zG5HMmstGTStAB69wDmQXj3T++YPmi/319oWxzQOnAUvWhZoEaARiXV2KXx/J/
	 I5L/slTKS5Tsn5/Iyt3jT1ms8pct5DqygvbrcHwFK5kGov3IY1reIfJiZ4xd3QgsOWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y8miWesLrv7ejuqWdamAWm4JAa1Exa1uCEv9HJFQ/70=;
	b=5BN/thke7CwwNRS+7wfoXcDnua4rVPlvtp2jcJwuU2JOp4dHx6NfJdT+uvz27bHSKBLf
	 oRpPV9yS8fOKbrvzOOmJ3s5bK1mZskfCMR+iSnrCFRE9TVBBkG8cFPA0BJx1B2fjWz55w
	 YQxqiPyFtnknslK0avkCLrCj1/LBFEVN3QVsa4Wq68glmfyfHwu+nsiZDA15Ahfo008+7
	 3n5qj2KuW2+rFYxD0IQoNeFPbPDsqMJykx1PoDsfCv+KlfCSO1nWptTqsOzAg3bb08d2Q
	 mpFbRBoQPDVNVuSMXLQ45yQDAFqgKD88QYQpaKampYix0lWMprgO9VrE2sycewyV2uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5it4mxt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED08606A321;
	Wed, 25 Nov 2026 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5it4mxt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0201F000C4;
	Wed, 25 Nov 2026 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625467;
	bh=y8miWesLrv7ejuqWdamAWm4JAa1Exa1uCEv9HJFQ/70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5it4mxtJXlmYGwPSLsh7/tFb6ZtGC2NrPj5xakEGtzJtnFqotqHSSeeU5eh2HJPU
	 zYhsigzah/6spKpbYtBogZyjuIAW1B0cSBEWCJ3PpbitBU5MULV16ZIyLuRvri9fHY
	 DkpBDiEcCsUyBDcve9tRejzi0TirR8x4wUrwsnh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 527/816] ksmbd: fix iface_list use-after-free during server reset
Date: Wed, 25 Nov 2026 15:34:35 +0100
Message-ID: <20261125143901.387883961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit d34d38ab0c62fe4eb9e746420c554e6d0e6f54db ]

ksmbd_find_netdev_name_iface_list() walks iface_list for
fsctl_query_iface_info_ioctl(), which holds RTNL. But during server
reset, ksmbd_tcp_destroy() unlinks and frees the entries without RTNL,
and queued SMB requests can still be running at that point. So an
FSCTL_QUERY_NETWORK_INTERFACE_INFO request can therefore race with
interface destruction and dereference a freed entry. With debug-only
instrumentation to make the race deterministic, KASAN reports:

   BUG: KASAN: slab-use-after-free in
   ksmbd_find_netdev_name_iface_list

   ksmbd_find_netdev_name_iface_list
   fsctl_query_iface_info_ioctl
   smb2_ioctl
   handle_ksmbd_work

   Freed by:
   kfree
   ksmbd_tcp_destroy
   ksmbd_conn_transport_destroy
   kill_server_store

The fix is to detach iface_list to a temporary list under RTNL, then drop
RTNL before cleanup because the following cleanup may block and hold RTNL
for a long time.

Fixes: b2d99376c5d6 ("ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260911163516.6403-1-15815827059%40163.com
Assisted-by: LLM
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Dropped the ksmbd_tcp_stop_listener() context line from the cleanup loop, since that helper doesn't exist here, so the loop starts at list_del(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 65705c8993be0..6dfd70f44cceb 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -682,10 +682,15 @@ static void tcp_stop_kthread(struct task_struct *kthread)
 void ksmbd_tcp_destroy(void)
 {
 	struct interface *iface, *tmp;
+	LIST_HEAD(iface_list_to_free);
 
 	unregister_netdevice_notifier(&ksmbd_netdev_notifier);
 
-	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
+	rtnl_lock();
+	list_splice_init(&iface_list, &iface_list_to_free);
+	rtnl_unlock();
+
+	list_for_each_entry_safe(iface, tmp, &iface_list_to_free, entry) {
 		list_del(&iface->entry);
 		kfree(iface->name);
 		kfree(iface);
-- 
2.53.0



