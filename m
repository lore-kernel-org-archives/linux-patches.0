Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC43C73748;
	Mon, 29 Jan 2024 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548544; cv=none; b=EWPLp1XnL2sOyWL9At/pMahLO6oyrqji4DNAThro/86tNSkDD7buuSs+WwMVGJl6QYDvMulYqf0Qjw6YfEw44cI982iEGV8NQX92XqPFPsKg99XLRrpYi6Sqi0O3qiqZ0Vbq5cG2SLUQ/seJpzgJt27ECg5PG1uC3xOo4GK2/4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548544; c=relaxed/simple;
	bh=jBqss7iu/jhCtOyIAseF2CobNIz8KwdTtnWLKosznQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuGoQk/HJLh2vJoYMiL/6RDiAKeDxhsvHEePQ/jfiZ/Kw/dUnJflHdHUnJItYR9Za+eu8qkSMGdwxIwk3Qy6W/DQV28HfYhhW3xTh+lnZY7NaeXWHIswMe+9l7ocLQFe1oZsm7odMZqLOvfTl8QwYfd95aPA82z+ijuFk6nQiN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMe7WH8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMe7WH8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9588EC433C7;
	Mon, 29 Jan 2024 17:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548544;
	bh=jBqss7iu/jhCtOyIAseF2CobNIz8KwdTtnWLKosznQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMe7WH8nzlhywScJC0EmsBTAGmMnTVNRCoAiW9wKLYbJBG8DqEsYZKiu6E3E5yptw
	 aR7TTdlw5hdsnlztfsVSVqBQL/Wfvda0Y6I+SZ7cpQ/9bO1NS0painzkkovuQXt1+X
	 r6jcjSYNZWUZhOcmq+zExmYNMduHrUxASMEkt+8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/331] afs: Hide silly-rename files from userspace
Date: Mon, 29 Jan 2024 09:04:09 -0800
Message-ID: <20240129170020.311981607@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 57e9d49c54528c49b8bffe6d99d782ea051ea534 ]

There appears to be a race between silly-rename files being created/removed
and various userspace tools iterating over the contents of a directory,
leading to such errors as:

	find: './kernel/.tmp_cpio_dir/include/dt-bindings/reset/.__afs2080': No such file or directory
	tar: ./include/linux/greybus/.__afs3C95: File removed before we read it

when building a kernel.

Fix afs_readdir() so that it doesn't return .__afsXXXX silly-rename files
to userspace.  This doesn't stop them being looked up directly by name as
we need to be able to look them up from within the kernel as part of the
silly-rename algorithm.

Fixes: 79ddbfa500b3 ("afs: Implement sillyrename for unlink and rename")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 5219182e52e1..2df2e9ee130d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -474,6 +474,14 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 			continue;
 		}
 
+		/* Don't expose silly rename entries to userspace. */
+		if (nlen > 6 &&
+		    dire->u.name[0] == '.' &&
+		    ctx->actor != afs_lookup_filldir &&
+		    ctx->actor != afs_lookup_one_filldir &&
+		    memcmp(dire->u.name, ".__afs", 6) == 0)
+			continue;
+
 		/* found the next entry */
 		if (!dir_emit(ctx, dire->u.name, nlen,
 			      ntohl(dire->u.vnode),
-- 
2.43.0



