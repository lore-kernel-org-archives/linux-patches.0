Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C954342A16C;
	Thu, 16 Jul 2026 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212037; cv=none; b=VvZySIRiAeGpYumiIewzR4rZuyAzFAFQjkWVnHt5AXWvHqGH8FA7iHhMVPi2oxgzGT2p7BrT0jizwgCaA93ssGFPaNsW2Ou8avTi1lLOpmLS0fHrd6W6opIL+vP0n1rb9wU4N7Qc4k4/fe7+XNfMFbPXlBpF0USjTca0nYkxseg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212037; c=relaxed/simple;
	bh=L4hO96jAIsWl4lHz7IcwdE/SV9u45cAtwgRNDGz/mSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QO6uzLdYPJR4mwEf9MQEhuwdIk+fOBrT55JqpU6iNHr4QlguAm6a+CiM+oXHNd9y6VzOY9fo3zQCEarP4AFNunSUm28UU8vt+0gJw5N5KmNapeShn9W8iAW57RoUh91A9t5cgit056FJ59lt6UcxpI/4EZakOPUa5rTOgTvBbEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNG3QQSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNG3QQSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADDB1F000E9;
	Thu, 16 Jul 2026 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212036;
	bh=Y8b3oQSxsdflF6bFfpE2QOyvED/U2L1KZ2GVg2Fzt6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNG3QQSjBY4K8dWfQqbe/ytDwBDhsXjW3bC5oxBiU9c63x+M5xxNcp8UEEt7lFAuz
	 Dg9lYT8CSD/gOOpyMo4ZmtyMNrPBr/DEUqHaCwshqSxK7m7Kfu0bOx7cC6bKQxOg45
	 YQldXzC70k1Be9ZdwFS2cE0EUnYogdU7t1uqKLvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 174/349] smb: client: fix query directory replay double-free
Date: Thu, 16 Jul 2026 15:31:48 +0200
Message-ID: <20260716133037.271666986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 9647492b5e41954be59d5157eddbcd4cdc1656f7 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_query_directory_init() fails before the next send,
cleanup retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5659,6 +5659,8 @@ send_set_info(const unsigned int xid, st
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


