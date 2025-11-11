Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B00A26E146;
	Tue, 11 Nov 2025 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824453; cv=none; b=St8pKFXf58y9Qz1Z1QFVw1cR1X6Lc2L64txH9ArT4jV9czIrjzMUZU+aX4HzPkfAhCHem8BN9Ag0QG5nGv6fzs2pmk4P2u73CKQZtLm7R62gOfZkbXVtjSe46IVpcwIy3/wz7yRCuhE1mbh70XvrIJ/tmyka+dfowcdj5gCDJfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824453; c=relaxed/simple;
	bh=wEOjBIcvqfN4ZPHrbB6TgG1mX6834pWeW2JKgPi3glo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzgALIWiju+AbrEXMlQKEZQejxmIoP9a0tPrwxrcvp66XnYHS/aiAPprtS3uEX8bFWL9sPFdlpXZEVhf5CDYkF6kqqlYvi1mc5Sw4Sx2G1Nc9JR/UwbU8hYENlbfnujnods6DzfpuRiXqBgRqW7o2hJ2QhOMNlSRE3aOgaT3ktY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8VahAwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8VahAwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BFCC4CEF5;
	Tue, 11 Nov 2025 01:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824453;
	bh=wEOjBIcvqfN4ZPHrbB6TgG1mX6834pWeW2JKgPi3glo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8VahAwAQk2fa+odAy0QDDohvVHFrvWiuTdtYrbdNIHPEDxig6EOW4iMb2i7sklgD
	 NCJoQWerg/v9RBV9/9Vx36PsjXrn2WfNaUl70CBvAJhbJ2ra2pzLcpT+f8KrheoG9p
	 xanF4HLOG/574POIQpBeyjOMSm+wT1cXRrQmgEo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Ebner <f.ebner@proxmox.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/565] smb: client: transport: avoid reconnects triggered by pending task work
Date: Tue, 11 Nov 2025 09:45:05 +0900
Message-ID: <20251111004536.991310383@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 35d1871187931..691c9265994fb 100644
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
@@ -212,9 +213,16 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
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



