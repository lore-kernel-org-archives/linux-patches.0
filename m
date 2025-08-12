Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269092FDC59;
	Tue, 12 Aug 2025 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025159; cv=none; b=gCJqFMv+ehykjVtuQYWPb/pOC4NrIscyKMV0BDgkJptiYov/CXRussxHWlRGtLjOjMAOgx8LBv3Xt3H+Lu7zmWsCCd8yN1w7ZqdwEeERgKQf5+zINrzaaPTrZtGKYZh7JeR5rU6Hx6tZhBpNjeiVVEM7vDE1RpmBU77x9joPN/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025159; c=relaxed/simple;
	bh=cV4SumpL+A0/2x+EROsf3oce4EPHTSXp+Qb6zNJKX5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP9quYZDyPeA4IRMfBP3RnlPa3f7eC6GfkBCbg0zD+AxP9c0FNVNQ5gNs9JGOAXdghMwicN9WK2l9JrG63zN82Xt9vUnc7+RUaVxSVT8m5/fwfBWtZubW6SdZbUwBx5KX3d8feUNWSG+d2YxoGxhL3eflCM4xhVqmdJy1sQQpMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqYD7uPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqYD7uPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84402C4CEF0;
	Tue, 12 Aug 2025 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025159;
	bh=cV4SumpL+A0/2x+EROsf3oce4EPHTSXp+Qb6zNJKX5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqYD7uPw+ET07o/x0595jTHkXCa2UbvbuPAwqehTRjVp9/zrbwbQbfjjlvQc886Dq
	 RIxQRDHFaama+g9E1oQtXXsykBev6jJsMot1dhMfOFT3kj+g2vVAnzap6j7YjS47Ws
	 /nh9Ce2zlfbjabQvmXlNv6+AGo+oGfFmzGlWldxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 586/627] ksmbd: fix corrupted mtime and ctime in smb2_open
Date: Tue, 12 Aug 2025 19:34:41 +0200
Message-ID: <20250812173454.172121487@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 4f8ff9486fd94b9d6a4932f2aefb9f2fc3bd0cf6 upstream.

If STATX_BASIC_STATS flags are not given as an argument to vfs_getattr,
It can not get ctime and mtime in kstat.

This causes a problem showing mtime and ctime outdated from cifs.ko.
File: /xfstest.test/foo
Size: 4096            Blocks: 8          IO Block: 1048576 regular file
Device: 0,65    Inode: 2033391     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:cifs_t:s0
Access: 2025-07-23 22:15:30.136051900 +0100
Modify: 1970-01-01 01:00:00.000000000 +0100
Change: 1970-01-01 01:00:00.000000000 +0100
Birth: 2025-07-23 22:15:30.136051900 +0100

Cc: stable@vger.kernel.org
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -548,7 +548,8 @@ int ksmbd_vfs_getattr(const struct path
 {
 	int err;
 
-	err = vfs_getattr(path, stat, STATX_BTIME, AT_STATX_SYNC_AS_STAT);
+	err = vfs_getattr(path, stat, STATX_BASIC_STATS | STATX_BTIME,
+			AT_STATX_SYNC_AS_STAT);
 	if (err)
 		pr_err("getattr failed, err %d\n", err);
 	return err;


