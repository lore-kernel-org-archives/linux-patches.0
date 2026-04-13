Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263CB2459D1;
	Mon, 13 Apr 2026 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097172; cv=none; b=JibfW6Am4gYJ+stazf7N6/vQ611ciqvKyc+PFZSGcIyxTzplwfltEWEsbwRLVv8FP8NAIKr2jAnS/Mxc+5MR91F7Jewj12Ea/WZj/l3jD7blcZdQz0M1quMTeEnpy71d+rZDWYLWMgqiLgOyrTSw1hwiM/t7734JgaB213p7FK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097172; c=relaxed/simple;
	bh=L/jJn7LnKzfwNpK1OKlsysImGV56RlSaLu5N7GodcU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO7xgEoYFSmT6ORd+qyyOtPkFhM67GgGOwtf12Py2egAR7tR8xhfTBL8xjzehM7T4+Nof24wfpxgXP1wa9xWdTv6kuGHcou4MV1b+39rmRfWoPrygGHc9ISNAmKgzMUWVwHi73vWMZ80kdJeRq37PnKQviNakeH4yEWiOAWAsgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuI8vTZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuI8vTZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0542C2BCAF;
	Mon, 13 Apr 2026 16:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097172;
	bh=L/jJn7LnKzfwNpK1OKlsysImGV56RlSaLu5N7GodcU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuI8vTZ3L1OjBYk67+edsLMbelzrIoFzo90INuEX3XbysHYYkFkWAlEvq7ikzCEjw
	 FrNEV8Wiy+F5c7Tif56b5QfHUWqcp4Jvwn1p+u7vIHqV3Ny9EJoZTxkATpHJHA2Rst
	 kx8GUefZrT+qHdQnDV+sX0pbXcilvqDAuljNTlSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/570] ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset in error paths
Date: Mon, 13 Apr 2026 17:52:45 +0200
Message-ID: <20260413155831.701067892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/server.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 27d8d6c6fdacd..fe797e8fe9419 100644
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
2.51.0



