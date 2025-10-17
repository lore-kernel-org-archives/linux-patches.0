Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457EC330B03;
	Fri, 17 Oct 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715562; cv=none; b=bmhG5f62irtijHQOVnqj6CqjiLG+KPXKvaUSDk61yG9syBI/OYmOj6+3fPew9UCggGqIbGu74p7BQzgmfZUlSUxVZN9h9OwOH3tzvQWsDoUTE6P0aK+pju/9BPwylQe11j1ip9/3ymt1A1+rrzQ/UC3rquU9lbBsZ0MrFst2B5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715562; c=relaxed/simple;
	bh=tBTcVQFUs9CmJdnBKnwtsoBDw74fHD0WMKHWBR3eZ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVALmbt+8JWGQAInddMY45YZMxIPXHeuDJBNUBar5TYslvugKJfqcox6I5pzVQxLfGEgMIRA8PQeG/WEC+ZqFWrH4UdzzsVwj8BnBEDGQ1ePALO+cgZRNSIJttUWny7NDELxPCKMaaoig7C3qEJ8O95cMq97KWk3Ng47mKfvbQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DL8gsyze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DL8gsyze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD95BC4CEFE;
	Fri, 17 Oct 2025 15:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715562;
	bh=tBTcVQFUs9CmJdnBKnwtsoBDw74fHD0WMKHWBR3eZ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DL8gsyzeG7e/03soF9g2LUQEqAp3HxGN0gWy/0VKLUFTuMVYMz5LGGrbWKnjIRb7r
	 vXTnjsIoZSxw8ehGJKrLmOoaHmNjws0eENoFevrCFbRipCd3j2Yb/OtUyjoy5t+XCm
	 cpL9rizLyMJw/eyIW4wHe/wZsn4sHlg+TkVp7RVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 259/371] smb client: fix bug with newly created file in cached dir
Date: Fri, 17 Oct 2025 16:53:54 +0200
Message-ID: <20251017145211.452474312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm@microsoft.com>

commit aa12118dbcfe659697567c9daa0eac2c71e3fd37 upstream.

Test generic/637 spotted a problem with create of a new file in a
cached directory (by the same client) could cause cases where the
new file does not show up properly in ls on that client until the
lease times out.

Fixes: 037e1bae588e ("smb: client: use ParentLeaseKey in cifs_do_create")
Cc: stable@vger.kernel.org
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index bc145436eba4..a233a5fe377b 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -329,6 +329,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 					       parent_cfid->fid.lease_key,
 					       SMB2_LEASE_KEY_SIZE);
 					parent_cfid->dirents.is_valid = false;
+					parent_cfid->dirents.is_failed = true;
 				}
 				break;
 			}
-- 
2.51.0



