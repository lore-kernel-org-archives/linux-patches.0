Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB180495C2;
	Thu, 30 Nov 2023 16:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bka6KDPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56311C433C8;
	Thu, 30 Nov 2023 16:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361789;
	bh=AR49ktfzQOLtWTowj4va7AO56EZEiyDxlWfpYvXN8ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bka6KDPYCvdLKLVFLs2JRCn6I+QSxnh+6doDxVb+wEIW410ozl6xGKQ5vIYj5J+wx
	 Ft/EhKkBhbRl1jWmvavS9dfVP43LT8dtxz8bcM2w5SAU7WpZwBPc9WF2PMfEUvpiB4
	 GAhmarjEsWX6W2CYp03S8Z0oAQqJileLsf7mjMtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/82] afs: Fix file locking on R/O volumes to operate in local mode
Date: Thu, 30 Nov 2023 16:21:54 +0000
Message-ID: <20231130162136.688113394@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit b590eb41be766c5a63acc7e8896a042f7a4e8293 ]

AFS doesn't really do locking on R/O volumes as fileservers don't maintain
state with each other and thus a lock on a R/O volume file on one
fileserver will not be be visible to someone looking at the same file on
another fileserver.

Further, the server may return an error if you try it.

Fix this by doing what other AFS clients do and handle filelocking on R/O
volume files entirely within the client and don't touch the server.

Fixes: 6c6c1d63c243 ("afs: Provide mount-time configurable byte-range file locking emulation")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 95d713074dc81..e95fb4cb4fcd2 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -407,6 +407,8 @@ static int afs_validate_fc(struct fs_context *fc)
 			return PTR_ERR(volume);
 
 		ctx->volume = volume;
+		if (volume->type != AFSVL_RWVOL)
+			ctx->flock_mode = afs_flock_mode_local;
 	}
 
 	return 0;
-- 
2.42.0



