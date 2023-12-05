Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2938BF7;
	Tue,  5 Dec 2023 03:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdJn7OqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90C8C433C7;
	Tue,  5 Dec 2023 03:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747336;
	bh=tQ/tMCla90fQnqLOZZ06erXaytHHo8hGB2rCqHeafro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdJn7OqDAOC+8oMomFwVMCj2pld82QzxTl25kvthFbM1nfrpwpguUwmY6Yh30keab
	 UB7sZjEOGyL2YcE5LZ7dyTCGtPb4cwoRdjjBJ2+LhlDa3h+e853Mc4tdaeEWstnIE0
	 x7gGjIkLBWBFMIne6/4KzgscTa4KXzhmyCTORID0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/135] afs: Fix file locking on R/O volumes to operate in local mode
Date: Tue,  5 Dec 2023 12:15:51 +0900
Message-ID: <20231205031532.569207164@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e38bb1e7a4d22..1b62a99b36731 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -406,6 +406,8 @@ static int afs_validate_fc(struct fs_context *fc)
 			return PTR_ERR(volume);
 
 		ctx->volume = volume;
+		if (volume->type != AFSVL_RWVOL)
+			ctx->flock_mode = afs_flock_mode_local;
 	}
 
 	return 0;
-- 
2.42.0



