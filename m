Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663191C760D;
	Wed, 19 Feb 2025 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956035; cv=none; b=k5pjG+Y1SQIWkPiAG+5ToAC4m93T728UvW5JwE2w5ofVJu+82xdUQe2EXu6A2mX2zeK4SRV8ZUjhucI2x2KemAig/f5X0ub7uqkN5HM+7zzPpT7LzUHqxndgyoI63LPq1EK2lmwuu5elcAoQEKLjwORsWHnJ+CBla4iQKVBzc6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956035; c=relaxed/simple;
	bh=3pEY5MWPsYS1GcQGjN3uyy8bDFk8O+lGh+yB2IaRogI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0MBS9yJET98j7RVGWbtacPpPt/NN7d/xIEdt6Yyq2vOS2Qx0nq04VEF1hWx0XMYtzNXPquoLKYAmPc5fajoYkHPLeaQ1nA7Bx3TXdlF6lBS+hUF53ikzGeZoQK7NsX1DSpd6L8Dmda+FbZQGNQpOSHGQddr/Mtz1BwVkAD+Gn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo7QtBXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo7QtBXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B0EC4CED1;
	Wed, 19 Feb 2025 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956035;
	bh=3pEY5MWPsYS1GcQGjN3uyy8bDFk8O+lGh+yB2IaRogI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zo7QtBXRGqXMatxsel88OgCv67erBrG83y7zIUlT/tPdRJXdD1urVr082y23eJRAh
	 +yN89Kh+rTljgJygLnB/t4OqOvo9rL9+Fz6bInmtlS/naABHBlDDS6QmzqriPB9xLg
	 6KJE70WlkELSE2NB4y5/+J886jH7IUJ8izqwhoTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/578] afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call
Date: Wed, 19 Feb 2025 09:20:16 +0100
Message-ID: <20250219082653.377790058@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit e30458d690f35abb01de8b3cbc09285deb725d00 ]

Fix a pair of bugs in the fallback handling for the YFS.RemoveFile2 RPC
call:

 (1) Fix the abort code check to also look for RXGEN_OPCODE.  The lack of
     this masks the second bug.

 (2) call->server is now not used for ordinary filesystem RPC calls that
     have an operation descriptor.  Fix to use call->op->server instead.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/109541.1736865963@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/yfsclient.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 11571cca86c19..01f333e691d64 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -655,8 +655,9 @@ static int yfs_deliver_fs_remove_file2(struct afs_call *call)
 static void yfs_done_fs_remove_file2(struct afs_call *call)
 {
 	if (call->error == -ECONNABORTED &&
-	    call->abort_code == RX_INVALID_OPERATION) {
-		set_bit(AFS_SERVER_FL_NO_RM2, &call->server->flags);
+	    (call->abort_code == RX_INVALID_OPERATION ||
+	     call->abort_code == RXGEN_OPCODE)) {
+		set_bit(AFS_SERVER_FL_NO_RM2, &call->op->server->flags);
 		call->op->flags |= AFS_OPERATION_DOWNGRADE;
 	}
 }
-- 
2.39.5



