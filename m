Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB342DE6E9;
	Tue, 12 Aug 2025 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021833; cv=none; b=mEf4fpdNY0NX0z4cgzFx44f6gstA6DEFHcdKh3ZI8Id/0J/Up8QuUNEr3yUSKW8YM2pq5Mu0e9JGKDvcfNFo7vBktEVklP7R4UWRrCSErtBqtI0AfAYz8k62WTWihVcX2scA6ocCI9ivIYnS8gqWFlMaIrUoPWFCy/cy8eMkaIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021833; c=relaxed/simple;
	bh=J3p32y9aKluEiKDhexm2aAc/ttwDJxJDP/nMnvbpoe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0pfCWMx5aB3s3w5dasg2wLM+60r4uD0W8akJf9M4Z7OtGT33qU/N+LPGJegEEQYxRwcz+EdVMvh+xHeRKfYz7QcDCzCFpGO6D4/3rh2EJ7w0BJoI+vJqnsHkHzKko1p+tMyDxePunf7ialZQ3K4BisK185OjxL+cXdX1oeDlHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpma55+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpma55+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E39BC4CEF0;
	Tue, 12 Aug 2025 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021832;
	bh=J3p32y9aKluEiKDhexm2aAc/ttwDJxJDP/nMnvbpoe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpma55+VpWd6xpu1QA0pL8Gj2+da3sjFU4RKM55fA9mRd9S8DfUwMOL65sVC5VUAu
	 UwcT+9HNwTJPFWdJ9P39EtJ4FryjXKNDb4aScWbJI2voB+DCpJyKIQ4B1Qb6cCpJa9
	 CnOJMT4T5j87v0lu/D15izRr/Gu6PrwNobpTu6IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 239/262] ksmbd: fix corrupted mtime and ctime in smb2_open
Date: Tue, 12 Aug 2025 19:30:27 +0200
Message-ID: <20250812173003.332395867@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -563,7 +563,8 @@ int ksmbd_vfs_getattr(const struct path
 {
 	int err;
 
-	err = vfs_getattr(path, stat, STATX_BTIME, AT_STATX_SYNC_AS_STAT);
+	err = vfs_getattr(path, stat, STATX_BASIC_STATS | STATX_BTIME,
+			AT_STATX_SYNC_AS_STAT);
 	if (err)
 		pr_err("getattr failed, err %d\n", err);
 	return err;


