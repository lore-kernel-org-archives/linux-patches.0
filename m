Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC6C6EB72;
	Mon,  8 Apr 2024 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584521; cv=none; b=VE/mVPS654eyXX/BgjITE7V0V7xXIHqDk06bgeqwiXK0VLj5E6tz2HgFlFcRt1p+tS8Qr3M1kMQb3onYwsJOCoyVds5xXPOFeX0HVQdTJietHa6pyUZDvXunOEj7LDW7uqF1J43JHVzbKCVp0V6QAGhqYmcMxM5icxa3cfhNbu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584521; c=relaxed/simple;
	bh=jvTehpZsdRfGsbmZv/1uomecNF7CRGfDcX0TufUMZu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYOl5R3OSpxG9vRm4OPDckwjCk71qQk1dctpXPqEmvRTgH8tU5FW5bIPHUndbb+387SWTfIxYg0dDGvKFBGq/UNBo/YAk+HUsdW9igYM1dRgoBVwVFueh0iutyss8E5l6vYynd5VS92u8EdjUlLhfXDiR6LDeekb2PZaBXIudxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPsvQ7A+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPsvQ7A+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216E6C433F1;
	Mon,  8 Apr 2024 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584521;
	bh=jvTehpZsdRfGsbmZv/1uomecNF7CRGfDcX0TufUMZu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPsvQ7A+9E1PWYwrVnOUOAUZ/YLQO0bne55KFf5Ab9RuFAwT+h6IshwJ29UvClgd7
	 y+NiMqRiYm4vYWDNPdlXWAdfqMWTPonyhnydW6YlFeDno7ksvPBAWNCR1i837zWe91
	 lrWN9CJa3u3dP7iHgusIOzIL51vNuxYZ3iFg0hMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Blomdell <anders.blomdell@control.lth.se>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 467/690] NFSD: Fix reads with a non-zero offset that dont end on a page boundary
Date: Mon,  8 Apr 2024 14:55:33 +0200
Message-ID: <20240408125416.534906159@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ac8db824ead0de2e9111337c401409d010fba2f0 ]

This was found when virtual machines with nfs-mounted qcow2 disks
failed to boot properly.

Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2142132
Fixes: bfbfb6182ad1 ("nfsd_splice_actor(): handle compound pages")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d17377148b669..9215350ad095c 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -872,11 +872,11 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct svc_rqst *rqstp = sd->u.data;
 	struct page *page = buf->page;	// may be a compound one
 	unsigned offset = buf->offset;
-	int i;
+	struct page *last_page;
 
-	page += offset / PAGE_SIZE;
-	for (i = sd->len; i > 0; i -= PAGE_SIZE)
-		svc_rqst_replace_page(rqstp, page++);
+	last_page = page + (offset + sd->len - 1) / PAGE_SIZE;
+	for (page += offset / PAGE_SIZE; page <= last_page; page++)
+		svc_rqst_replace_page(rqstp, page);
 	if (rqstp->rq_res.page_len == 0)	// first call
 		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
-- 
2.43.0



