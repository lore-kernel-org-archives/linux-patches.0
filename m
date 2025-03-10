Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED92423370F;
	Mon, 10 Mar 2025 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628613; cv=none; b=mtvIQcSuZXG+3FM3jx0jr+ZI2bjOc3EY7PfTnZQhEQ/tEcwAV/7X2qt58Rd1AYzLqgF9SPJnHeiJah95SWV8t5oYKw8d47nnHIMV6SyrgZoebR1p+zJecr4wHlEayhtOlSgpR6aFDvY8Xv9mQ95ZSd6NxQfXalGTTMhHnpFSG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628613; c=relaxed/simple;
	bh=P5/YXvWrhNDduSZlwjknUqOE2DGm3sSPIwNZ/r4jij0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGeY+GZWCSi1DA0ICmvMu5u9mNN6JpPEpd7NQVR+RgjNiaoDXd3c41Ae/S5GttbgMfQhFy9OGj0vM2URnxuS4IkwWvJnM5b/VUJFgO3zmOZQzZDKJuRUT7XTAC9YGjVdROcvx3/X1Fo2o/sQCRrWa8vRv/pjsS4Ke0Uh5ljF81U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTmjLwUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTmjLwUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763DBC4CEEC;
	Mon, 10 Mar 2025 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628612;
	bh=P5/YXvWrhNDduSZlwjknUqOE2DGm3sSPIwNZ/r4jij0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTmjLwUd7A/aAnBpjfWugVQijg+nrD8aCoV6NzEyErw5b4cq4FBuC9jrIQmU/YTxp
	 PKP92ujuCwRH54ygKYb890YlOcIwtXvtxBUtY4r5HTl+SaOcdHoDxGJq5GvtzuqDKQ
	 0Wym0x2jxQHz02GAmjhoB1Ws2VKN969rnwQx2ajc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/620] afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
Date: Mon, 10 Mar 2025 17:57:27 +0100
Message-ID: <20250310170545.618943678@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit b49194da2aff2c879dec9c59ef8dec0f2b0809ef ]

AFS servers pass back a code indicating EEXIST when they're asked to remove
a directory that is not empty rather than ENOTEMPTY because not all the
systems that an AFS server can run on have the latter error available and
AFS preexisted the addition of that error in general.

Fix afs_rmdir() to translate EEXIST to ENOTEMPTY.

Fixes: 260a980317da ("[AFS]: Add "directory write" support.")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-13-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index cec18f9f8bd7a..d4bd6efc8c447 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1493,7 +1493,12 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 		op->file[1].vnode = vnode;
 	}
 
-	return afs_do_sync_operation(op);
+	ret = afs_do_sync_operation(op);
+
+	/* Not all systems that can host afs servers have ENOTEMPTY. */
+	if (ret == -EEXIST)
+		ret = -ENOTEMPTY;
+	return ret;
 
 error:
 	return afs_put_operation(op);
-- 
2.39.5



