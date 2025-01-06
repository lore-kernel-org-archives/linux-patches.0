Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854A71607AA;
	Mon,  6 Jan 2025 15:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178782; cv=none; b=ka8QDkwrXzNUGe3HbZm8eT7f3KJFjV2Sy36yCLSCs1bgk/HAXC8SJM/kXzb1RWvzbcVo8uae/r+nUnxNMv1ElGCKd9bx46ZJ8amiFEtGGR5l1L9ugdBDn8K3GHX3DP43ckaM990nGMIZ5qwSzmVbDZlP4B1g8Q80iM/U2dSbaM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178782; c=relaxed/simple;
	bh=HgVqZzxzskBqEhkjK8exEA9xBfI2gUH7PQE5GuZFlnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKRkGKXN77V01OWGo9rvTrdxguYruM3s4Ab8dHmOQ8+Z2ZSNMVjUqZbjvY+d7TJvF3VdI+ISB9n6qAeBPJLo9Z4zsuq0v35ZIH8+PjMQtbMXEtZM5TVlBQwgw65Ot3FLfOybZmlLeww6gZQTx5BGrH5H1Pm8QynuQAYCOg51Uew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xdtx9XUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xdtx9XUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06658C4CED2;
	Mon,  6 Jan 2025 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178782;
	bh=HgVqZzxzskBqEhkjK8exEA9xBfI2gUH7PQE5GuZFlnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xdtx9XUyJEd539IFcaK+P7+L0gHpYTDP9XcCxvpVLXtac2y+77z5uTJ68mAtTNYJQ
	 CEiHjZZnLaJQlfUxKEAJ63ZtiAPzhtUo5CLshwfqB720iQ9PTEPr+wdjKUhP63gyzY
	 DXhcwgcJRafEZsa03TJdtJYwSDcHqzXpnwWdA8uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/168] ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write
Date: Mon,  6 Jan 2025 16:16:38 +0100
Message-ID: <20250106151141.863137627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordy Zomer <jordyzomer@google.com>

[ Upstream commit 313dab082289e460391c82d855430ec8a28ddf81 ]

An offset from client could be a negative value, It could allows
to write data outside the bounds of the allocated buffer.
Note that this issue is coming when setting
'vfs objects = streams_xattr parameter' in ksmbd.conf.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 35914c9809aa..0f97830d1ebc 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6567,6 +6567,8 @@ int smb2_write(struct ksmbd_work *work)
 	}
 
 	offset = le64_to_cpu(req->Offset);
+	if (offset < 0)
+		return -EINVAL;
 	length = le32_to_cpu(req->Length);
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
-- 
2.39.5



