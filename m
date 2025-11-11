Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3045A2609CC;
	Tue, 11 Nov 2025 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825139; cv=none; b=ANIxhz/oU+I+CZh+z2GBiCFWabkqZVOmpPFSms9O67Bj3OBRc5hx05RTmDpTzCPgQC950iuqoDhNpjeOff7ktv+f+bRa9Bl1zLkdWPrNvm/iqK15p4y6+M7tIkySHKrbHTLG4v59M7yj1/9XFD7IvWQwVLNABwX5J9WhaH/DeGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825139; c=relaxed/simple;
	bh=Y6/YScjHG2Fl89HwPAk48H8H2TFan8Jw9aMX6ASh3wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I68k6A9IYWgbKM+Bu7QQr+0jSfxsZIxVAc4vxbvGB7SHMQRXlpQv2kmpbWjfRuvFJeA8wtFDygU8bssziJYWFu/RqZ/LJqqiI1KiIFOWnbtiYz4HRbXKBzu8CHd0fNmPjAVO57TXYBfMRiENcA6za847AHQ/AdPiixsK3PUOkx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRUsmk5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRUsmk5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84789C2BCAF;
	Tue, 11 Nov 2025 01:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825138;
	bh=Y6/YScjHG2Fl89HwPAk48H8H2TFan8Jw9aMX6ASh3wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRUsmk5d+jpw1MEtwqb4CxWCaGGt8vLFj2asC0tHBmqhG7ylGA5VqrEfmJ8SjrEni
	 Dhyt9qzGy1BRnEE1O7Q8uVStAxDmuMGpZmLonEjVJ0enB7EU3CCGecxXgsI99CtvpQ
	 +/TSl9ksddB7jX16Ab24lNTZBXcYFLuFwUPmLq34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Ebner <f.ebner@proxmox.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 678/849] smb: client: transport: avoid reconnects triggered by pending task work
Date: Tue, 11 Nov 2025 09:44:08 +0900
Message-ID: <20251111004552.814640911@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fiona Ebner <f.ebner@proxmox.com>

[ Upstream commit 00be6f26a2a7c671f1402d74c4d3c30a5844660a ]

When io_uring is used in the same task as CIFS, there might be
unnecessary reconnects, causing issues in user-space applications
like QEMU with a log like:

> CIFS: VFS: \\10.10.100.81 Error -512 sending data on socket to server

Certain io_uring completions might be added to task_work with
notify_method being TWA_SIGNAL and thus TIF_NOTIFY_SIGNAL is set for
the task.

In __smb_send_rqst(), signals are masked before calling
smb_send_kvec(), but the masking does not apply to TIF_NOTIFY_SIGNAL.

If sk_stream_wait_memory() is reached via sock_sendmsg() while
TIF_NOTIFY_SIGNAL is set, signal_pending(current) will evaluate to
true there, and -EINTR will be propagated all the way from
sk_stream_wait_memory() to sock_sendmsg() in smb_send_kvec().
Afterwards, __smb_send_rqst() will see that not everything was written
and reconnect.

Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index a61ba7f3fb86b..940e901071343 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -22,6 +22,7 @@
 #include <linux/mempool.h>
 #include <linux/sched/signal.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/task_work.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -173,9 +174,16 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 * send a packet.  In most cases if we fail to send
 		 * after the retries we will kill the socket and
 		 * reconnect which may clear the network problem.
+		 *
+		 * Even if regular signals are masked, EINTR might be
+		 * propagated from sk_stream_wait_memory() to here when
+		 * TIF_NOTIFY_SIGNAL is used for task work. For example,
+		 * certain io_uring completions will use that. Treat
+		 * having EINTR with pending task work the same as EAGAIN
+		 * to avoid unnecessary reconnects.
 		 */
 		rc = sock_sendmsg(ssocket, smb_msg);
-		if (rc == -EAGAIN) {
+		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {
-- 
2.51.0



