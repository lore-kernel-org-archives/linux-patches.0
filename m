Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956971DDC28
	for <patches@lists.linux.dev>; Thu, 12 Mar 2026 03:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773287189; cv=none; b=stCZx3v9papEBnFuQoo2UuhrihlvRf61Cw+lSv71Y7Sa41BtbNyDwe+N7/A/A76iF1HL6M2+8/OCV94IuaMkdmX7sawdPce4T6cga2OL3eAol871vzSANj/SddHCm2H1CKogs1lFlUuK9YELbQ9PgXRwIrLKQ4WdRLUVtlpmUi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773287189; c=relaxed/simple;
	bh=QGCBu24qEP1uzA1M/RCjuIHGY7TJTEBU47sUFrDTpdI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S4RGqgjbsBejquUEms5dmbvmqODEpY7TLDux7lo69I2YsUp0TPDX8UHg7Tt5fTPeF2m5QTe6uiyZLQNFwnTj2WTOflDZaErnF58PTqDN+VkmgMPGJa1dTkDEHcBcyuuTyMXOw/mJsO5Y93qEXqwHtzphQRgTdEAXCaBFFTuxzr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=PlTVwW4z; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="PlTVwW4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=PlTVwW4zXf40tYO+fIeM+Icp6+KiLf4O6ri5CicLk7ywWfEsIsmlVKk89fkvqFkCFLAvGbiZrhI1S
	 /YWKqVP3P3nBMzcy1Ma6UdzBqSzc5MZoOVm1i+Ts7kSptfwPiJYiCMwcZEcjSCS/9z3NnoDefqv5mo
	 PsmPZVOP1HC6u+4E=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-03-12081 (RichMail) with SMTP id 2f3169b237031bb-0420c;
	Thu, 12 Mar 2026 11:46:15 +0800 (CST)
X-RM-TRANSID:2f3169b237031bb-0420c
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset in error paths
Date: Thu, 12 Mar 2026 11:46:14 +0800
Message-Id: <20260312034614.3043373-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 010eb01ce23b34b50531448b0da391c7f05a72af ]

The problem occurs when a signed request fails smb2 signature verification
check. In __process_request(), if check_sign_req() returns an error,
set_smb2_rsp_status(work, STATUS_ACCESS_DENIED) is called.
set_smb2_rsp_status() set work->next_smb2_rcv_hdr_off as zero. By resetting
next_smb2_rcv_hdr_off to zero, the pointer to the next command in the chain
is lost. Consequently, is_chained_smb2_message() continues to point to
the same request header instead of advancing. If the header's NextCommand
field is non-zero, the function returns true, causing __handle_ksmbd_work()
to repeatedly process the same failed request in an infinite loop.
This results in the kernel log being flooded with "bad smb2 signature"
messages and high CPU usage.

This patch fixes the issue by changing the return value from
SERVER_HANDLER_CONTINUE to SERVER_HANDLER_ABORT. This ensures that
the processing loop terminates immediately rather than attempting to
continue from an invalidated offset.

Reported-by: tianshuo han <hantianshuo233@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/ksmbd/server.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 27d8d6c6fdac..fe797e8fe941 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -126,21 +126,21 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 andx_again:
 	if (command >= conn->max_cmds) {
 		conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
-		return SERVER_HANDLER_CONTINUE;
+		return SERVER_HANDLER_ABORT;
 	}
 
 	cmds = &conn->cmds[command];
 	if (!cmds->proc) {
 		ksmbd_debug(SMB, "*** not implemented yet cmd = %x\n", command);
 		conn->ops->set_rsp_status(work, STATUS_NOT_IMPLEMENTED);
-		return SERVER_HANDLER_CONTINUE;
+		return SERVER_HANDLER_ABORT;
 	}
 
 	if (work->sess && conn->ops->is_sign_req(work, command)) {
 		ret = conn->ops->check_sign_req(work);
 		if (!ret) {
 			conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
-			return SERVER_HANDLER_CONTINUE;
+			return SERVER_HANDLER_ABORT;
 		}
 	}
 
-- 
2.34.1


