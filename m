Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0D4341648;
	Tue, 16 Dec 2025 11:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884809; cv=none; b=Wl50wWyf23ZIzbtoq3HZqdPXFW+Cp17E3Vo2yKtbVyzsKpIiqkiekcfNKFlV4ccaXcJIM5tpcnh5luSeE0uVR0FvbqeQoxRgIhOzg4zpdmkt1o/V6xp0ueASN0im5KnoGSfrhkPDoCRsFCxn8SSG5Eye60QEKRqi6trZMOAhGTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884809; c=relaxed/simple;
	bh=kJyPEXuzss6Qd4cap2fUmWNLN2CCTyuGmVyc+Q5DbKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyeSPJVOjiXggYFnRw9RZN8fejJBS0JZriRpKMErLF1ekV4czbF5ozxkmKswxxHuEQ4pzfBc5EEGdqb5JMXsnXrabrXtlaB/ANMOiqudJr/yg0ZshSbIDwo08An+QDOrOAQrVlle/eKsZ0kKy/Q7OstaFd00wIfIH7xzRWUY4UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zM81cSr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zM81cSr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15D0C4CEF5;
	Tue, 16 Dec 2025 11:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884809;
	bh=kJyPEXuzss6Qd4cap2fUmWNLN2CCTyuGmVyc+Q5DbKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zM81cSr/+eCpz0Dy9CKgf+WVphuJ6UVjUbZ2sQ/YXzRvsoH79CAkZyVVEeHpqD65Z
	 3l/fBn4oUcvRG+sUAN87MM7n6cWWQLM4GT3/3hRt11V2dWBFVn5Vdx2OT9ClDrSDCG
	 FZCbFrLkh25a/229Avy3ApSHp+acI1ocEIzXA4eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/354] NFS: Initialise verifiers for visible dentries in nfs_atomic_open()
Date: Tue, 16 Dec 2025 12:14:32 +0100
Message-ID: <20251216111331.962775154@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 518c32a1bc4f8df1a8442ee8cdfea3e2fcff20a0 ]

Ensure that the verifiers are initialised before calling
d_splice_alias() in nfs_atomic_open().

Reported-by: Michael Stoler <michael.stoler@vastdata.com>
Fixes: 809fd143de88 ("NFSv4: Ensure nfs_atomic_open set the dentry verifier on ENOENT")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 8c4fcd140fa13..1cf1b2ddbf549 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2151,12 +2151,12 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		d_drop(dentry);
 		switch (err) {
 		case -ENOENT:
-			d_splice_alias(NULL, dentry);
 			if (nfs_server_capable(dir, NFS_CAP_CASE_INSENSITIVE))
 				dir_verifier = inode_peek_iversion_raw(dir);
 			else
 				dir_verifier = nfs_save_change_attribute(dir);
 			nfs_set_verifier(dentry, dir_verifier);
+			d_splice_alias(NULL, dentry);
 			break;
 		case -EISDIR:
 		case -ENOTDIR:
-- 
2.51.0



