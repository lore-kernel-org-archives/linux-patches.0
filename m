Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB85168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702EBC433D2;
	Mon,  8 May 2023 10:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541029;
	bh=V9Dg1V9fmqWra7qEzHk6hJ52XF4WNtwERcF7mEgEELc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRTEcXQWPBAxNH2MgTHqsFLVJ/nt0aarXq+O8yU/I53eOXfRGhZjjD5bMoK6303pq
	 lfZDcv0IskMIIPsQsXMAa+9YJT6/JaEQMk/+A/TWBZCGgcLDBAvh5XFZMBQeTo3MOg
	 FRqWNeSwHX0JkmhoJ6jTuWiGqxzK9cL2KtCVfghQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 558/611] afs: Avoid endless loop if file is larger than expected
Date: Mon,  8 May 2023 11:46:40 +0200
Message-Id: <20230508094440.120434882@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit 9ea4eff4b6f4f36546d537a74da44fd3f30903ab ]

afs_read_dir fetches an amount of data that's based on what the inode
size is thought to be.  If the file on the server is larger than what
was fetched, the code rechecks i_size and retries.  If the local i_size
was not properly updated, this can lead to an endless loop of fetching
i_size from the server and noticing each time that the size is larger on
the server.

If it is known that the remote size is larger than i_size, bump up the
fetch size to that size.

Fixes: f3ddee8dc4e2 ("afs: Fix directory handling")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 104df2964225c..f73b2f62afaae 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -274,6 +274,7 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 	loff_t i_size;
 	int nr_pages, i;
 	int ret;
+	loff_t remote_size = 0;
 
 	_enter("");
 
@@ -288,6 +289,8 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 
 expand:
 	i_size = i_size_read(&dvnode->netfs.inode);
+	if (i_size < remote_size)
+	    i_size = remote_size;
 	if (i_size < 2048) {
 		ret = afs_bad(dvnode, afs_file_error_dir_small);
 		goto error;
@@ -363,6 +366,7 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 			 * buffer.
 			 */
 			up_write(&dvnode->validate_lock);
+			remote_size = req->file_size;
 			goto expand;
 		}
 
-- 
2.39.2



