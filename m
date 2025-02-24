Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7822C192D8F;
	Mon, 24 Feb 2025 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408201; cv=none; b=cCYM5YOvmJIAmlsL4QxP4pyQEDAaHlj2cs83YKlqrhAdwi1ur3H6+CjoJVlOX0iWNCIKjRxVjP/vD2QgLGnsBMfcScGMk+5qTq2sPeecp7ZtvFWWkkChWIrylQEslFaDxcsp630P1SvaN2VWvSTF+kUkkKOxgN2+8cl/V7mm0S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408201; c=relaxed/simple;
	bh=0qpWp7l51cULKor9+QIq+DwqQFLwjGl6g/xHx312pac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8wonpBUhqBllTakz3fKaKoTjSp8Q3NxfY4AOPTSi57YLjGBHDXwrwcYfwXyxa3ozA71Gr4IeFnnuqYyl58V2+IerMMcU/8edMJaQDJ5c+j415zU+QNeUAjfTy6hG03MZOsPnIHVN4rIFxRn+XDdhLO8ONQQ1g0+xM+tFoYnO2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vptDIJ3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vptDIJ3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF132C4CEE6;
	Mon, 24 Feb 2025 14:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408201;
	bh=0qpWp7l51cULKor9+QIq+DwqQFLwjGl6g/xHx312pac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vptDIJ3MzwI78IqpQ+gGhUgUGtJMzwbvnkYiB3rXIqNbqOfCjM/UOQxe+T39DDbBE
	 L5CabFtc6mIv/POody4UkUtDXwGoNzBfPdcbn9PzrbBq6lQ7S3Jr5iJP1CVNeZ1Ttq
	 oaYbZt/nZmMt7HwnLSRKflg7PiseZCau2HxSsNo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 128/140] smb: client: Add check for next_buffer in receive_encrypted_standard()
Date: Mon, 24 Feb 2025 15:35:27 +0100
Message-ID: <20250224142608.035923054@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 860ca5e50f73c2a1cef7eefc9d39d04e275417f7 upstream.

Add check for the return value of cifs_buf_get() and cifs_small_buf_get()
in receive_encrypted_standard() to prevent null pointer dereference.

Fixes: eec04ea11969 ("smb: client: fix OOB in receive_encrypted_standard()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4905,6 +4905,10 @@ one_more:
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
+		if (!next_buffer) {
+			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
+			return -1;
+		}
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 


