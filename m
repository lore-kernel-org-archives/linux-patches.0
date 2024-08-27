Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2D1C4603;
	Tue, 27 Aug 2024 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771285; cv=none; b=e5/lVI6VOQDeikW7ETADdZZdaB0OmMbu4jT8BsHJ8bbPQlqAwtcNI5PZ38XPoe9zj1NRMC359JH///CwK6RDRDDhLgAgFK7CESX5GlOvTcFtAW/5Ljz7/qq0/batsh1RN0ZsE7pMm8j3YZVrSkbJtS3ZhX2AAmV0fljvJt3P5c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771285; c=relaxed/simple;
	bh=Xz0ugJlz+TlxT71gsJSTlh9PspqV5yxanuYOeGNz4AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WU9Wh/hAZlwmyhJZch0oQwNw2DxXTj4eI25D8M00tzl795hecXVjT5jFWH46xxN5OtF3PMEzn4Gh84y+9spNtZDLapX+nR/fr4od+ump5AXjYlBSM06PVAgYDBAtANlB1d1sK6wBUOro0FuZwT5XjKyV7vgN2SDcWqjsI1ty5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oftFSZxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oftFSZxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F06C61074;
	Tue, 27 Aug 2024 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771285;
	bh=Xz0ugJlz+TlxT71gsJSTlh9PspqV5yxanuYOeGNz4AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oftFSZxRSd7zWrK7WhZheRAPHeepz7YIqpN56W8Hxdvit7vxgA9kETywxFMhsGPyP
	 Pc6VkuR7jLH1WN7bZAKFbb8CLOo3e/bEcgIMW9x/g4eREiN9ecLF1s14mZk3AUz0Y4
	 vTcoF172mMBgpUlglZn9bft5PaFghUfqsIuDVOGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Su Hui <suhui@nfschina.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 143/273] smb/client: avoid possible NULL dereference in cifs_free_subrequest()
Date: Tue, 27 Aug 2024 16:37:47 +0200
Message-ID: <20240827143838.849466058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 74c2ab6d653b4c2354df65a7f7f2df1925a40a51 ]

Clang static checker (scan-build) warning:
	cifsglob.h:line 890, column 3
	Access to field 'ops' results in a dereference of a null pointer.

Commit 519be989717c ("cifs: Add a tracepoint to track credits involved in
R/W requests") adds a check for 'rdata->server', and let clang throw this
warning about NULL dereference.

When 'rdata->credits.value != 0 && rdata->server == NULL' happens,
add_credits_and_wake_if() will call rdata->server->ops->add_credits().
This will cause NULL dereference problem. Add a check for 'rdata->server'
to avoid NULL dereference.

Cc: stable@vger.kernel.org
Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b413cfef05422..1fc66bcf49eb4 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -316,7 +316,7 @@ static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
 #endif
 	}
 
-	if (rdata->credits.value != 0)
+	if (rdata->credits.value != 0) {
 		trace_smb3_rw_credits(rdata->rreq->debug_id,
 				      rdata->subreq.debug_index,
 				      rdata->credits.value,
@@ -324,8 +324,12 @@ static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
 				      rdata->server ? rdata->server->in_flight : 0,
 				      -rdata->credits.value,
 				      cifs_trace_rw_credits_free_subreq);
+		if (rdata->server)
+			add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
+		else
+			rdata->credits.value = 0;
+	}
 
-	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	if (rdata->have_xid)
 		free_xid(rdata->xid);
 }
-- 
2.43.0



