Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB7B3624DD;
	Tue,  6 Jan 2026 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721830; cv=none; b=FfL7KXKB/U7SPZk5JW3Lqa2NRaR5H7gGHKHAX2DgByN7ULd4kRLsSv7njAJZh7y1DVPSxuksQMU2IB/+gWEHFyYPSG+1ueQK6LianPPZ5BOEZmrzmYKqV+ln8kxWWffQSXgFfZaw/3M+9eldQilV8G0KN2fxu7hzGXKlPZGPU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721830; c=relaxed/simple;
	bh=pxS7IxNKlzHA6KXjkfs4oGbVeCCaSMcTJfcH0UxtLGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ8sHBEMXN+vU0lmQWRpeAB9wijxuvzQO1Pu2JHUJ6Bmjyyj/v+FSANoMbQhZ1u+obPFiMLaKL64t8AIFGbIyjSvil7KCcu8NpjIc+4Lmxmx8+seahDPP02fIeaMoJU+bsj98HfVJ6CUW9i19Z1HVs+e6snG9eLfu1Y/rw+BFIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBbltGNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBbltGNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D786BC16AAE;
	Tue,  6 Jan 2026 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721830;
	bh=pxS7IxNKlzHA6KXjkfs4oGbVeCCaSMcTJfcH0UxtLGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBbltGNTNPckhtlvUCCoOnCLx+0uHkb4TPDqHkjxEaSIMXMhmwHXPScD55Q5Y2zSl
	 xZmx2XiSmZJcGZZFcjxsj9r94CNaBwBkoxticlrYAQdgUV0a3PExg5vbJ2GSkVZZbB
	 Lhy3bS+hcbu4ZQEtQCf8BlgDfgjTv3JZgsS3S2Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/312] ksmbd: Fix memory leak in get_file_all_info()
Date: Tue,  6 Jan 2026 18:02:37 +0100
Message-ID: <20260106170550.840365693@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 0c56693b06a68476ba113db6347e7897475f9e4c ]

In get_file_all_info(), if vfs_getattr() fails, the function returns
immediately without freeing the allocated filename, leading to a memory
leak.

Fix this by freeing the filename before returning in this error case.

Fixes: 5614c8c487f6a ("ksmbd: replace generic_fillattr with vfs_getattr")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6a94cda0927d..2b59c282cda5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4933,8 +4933,10 @@ static int get_file_all_info(struct ksmbd_work *work,
 
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			  AT_STATX_SYNC_AS_STAT);
-	if (ret)
+	if (ret) {
+		kfree(filename);
 		return ret;
+	}
 
 	ksmbd_debug(SMB, "filename = %s\n", filename);
 	delete_pending = ksmbd_inode_pending_delete(fp);
-- 
2.51.0



