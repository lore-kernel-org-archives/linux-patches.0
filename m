Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12C515FA85;
	Mon, 27 May 2024 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836393; cv=none; b=TGRZV6PE4+2sD4i5wq6+URnJo+pH/iPflisM7HL7GfAzBntZR+riWVTBqy35TjxpSF3xM2RS8zTtSVkeHteZ2xPu+1wu+MM7wpoLJZNRB6R00DLzX55m55vnqzG1huhIRGwmwOFwUpFAHWkQ1/fdGbxKyEp+LN5cj7T0EEilvGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836393; c=relaxed/simple;
	bh=q2Uk6MzbGjO+1g5iKft32kJA11M+zsqliPijqaDWYQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek+/mFN0h8fYc+nKV2lA5411f90XLaejZ/dqoiaVIWp5rZYVXEQA14xbncWUKrDKnvmpoj7ddv6diERTThhU0XQjMNS4rEvRFk+AgxwPfX6qyX1rONflJqaxZ+HYlhO7Mdn1ZPWtgNfR/rUeeD5JQsf2a6UyG/3TS00p5VKQjH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUPEZdTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUPEZdTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45629C2BBFC;
	Mon, 27 May 2024 18:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836393;
	bh=q2Uk6MzbGjO+1g5iKft32kJA11M+zsqliPijqaDWYQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUPEZdTxYLjfB4ArswWCaF02N9v8H8c6U059g6Sj2taQ+OILGg8YahdjUCJ/In4lr
	 0rU+Y3wgn4bkQ8VjDKQE2vuNEN8+8U9M3/aUIF+FaPXHek8aroNK1eL4xGZlWO0x8t
	 JItZkcLZ+gLWcdJbsUJhlRiv5pnfQxfQCMAwintc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.9 035/427] ksmbd: avoid to send duplicate oplock break notifications
Date: Mon, 27 May 2024 20:51:22 +0200
Message-ID: <20240527185604.908867096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit c91ecba9e421e4f2c9219cf5042fa63a12025310 upstream.

This patch fixes generic/011 when oplocks is enable.

Avoid to send duplicate oplock break notifications like smb2 leases
case.

Fixes: 97c2ec64667b ("ksmbd: avoid to send duplicate lease break notifications")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -610,19 +610,24 @@ static int oplock_break_pending(struct o
 		if (opinfo->op_state == OPLOCK_CLOSING)
 			return -ENOENT;
 		else if (opinfo->level <= req_op_level) {
-			if (opinfo->is_lease &&
-			    opinfo->o_lease->state !=
-			     (SMB2_LEASE_HANDLE_CACHING_LE |
-			      SMB2_LEASE_READ_CACHING_LE))
+			if (opinfo->is_lease == false)
+				return 1;
+
+			if (opinfo->o_lease->state !=
+			    (SMB2_LEASE_HANDLE_CACHING_LE |
+			     SMB2_LEASE_READ_CACHING_LE))
 				return 1;
 		}
 	}
 
 	if (opinfo->level <= req_op_level) {
-		if (opinfo->is_lease &&
-		    opinfo->o_lease->state !=
-		     (SMB2_LEASE_HANDLE_CACHING_LE |
-		      SMB2_LEASE_READ_CACHING_LE)) {
+		if (opinfo->is_lease == false) {
+			wake_up_oplock_break(opinfo);
+			return 1;
+		}
+		if (opinfo->o_lease->state !=
+		    (SMB2_LEASE_HANDLE_CACHING_LE |
+		     SMB2_LEASE_READ_CACHING_LE)) {
 			wake_up_oplock_break(opinfo);
 			return 1;
 		}


