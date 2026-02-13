Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1EF23645D;
	Fri, 13 Feb 2026 13:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990631; cv=none; b=B1vClz6/1zywAYUrBtxelc6R0Qes60o+E+sCLwsUr6HM0BCSAcDvp9sX/UJ9V0ALKheQHAskkbrOTYn6TYRBbrT6h77LiHcWBPCt2MsDvFJXXgfcKNR3cSe3W8wBjStxl9j0XHiTZnJ13z3nhFY5275384Buxp6q6DOgDzYiAxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990631; c=relaxed/simple;
	bh=d2DPvzxl8+w1niFrJPWRzGlHmsAEvimCcabjWWDHs6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDwstvsvZVTLHpAZVidXYeKMcYq/4k5lo8XK04B7fZTD3IUwGdj5rxYilm2Ya03OknZtcvsjOj+UeLdSKwBsTAlqNlCZTq5IT0EbchDpljVi88ibBpw25QR7Dr341PtZvL+/2lBRgkVpvjdvksf9E6uME39PiioJb42Pzzv7afQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l57G+sf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l57G+sf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F243C116C6;
	Fri, 13 Feb 2026 13:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990631;
	bh=d2DPvzxl8+w1niFrJPWRzGlHmsAEvimCcabjWWDHs6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l57G+sf9IMlBgjOGGr4ZzUgIO1byRHTaFF95o4yqf+0vZ4rJd/eh3nRriyh0tpZVT
	 7TDoqwG6GAtgbN9zkG9twVlLHDH7eQc2XmfN5S9sF3StEU7WlypTnaF9j4SiDbo6xO
	 xiwbL9uFrFUJt2R8J9I/zAmznKPdGWzNEZUwDDNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 04/49] ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset in error paths
Date: Fri, 13 Feb 2026 14:47:23 +0100
Message-ID: <20260213134708.886782476@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 010eb01ce23b34b50531448b0da391c7f05a72af upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/server.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -126,21 +126,21 @@ static int __process_request(struct ksmb
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
 


