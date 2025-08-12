Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1E92D5C76;
	Tue, 12 Aug 2025 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021306; cv=none; b=eju80miVo7sM+7E72ddIS5emwvNqusGKyLQFnA146048BzYiPmno1ZOxXuRfEqPyh5Og4GvOaMPrG6UM3yS8ojJeIG0Qz19mVoHxfH8pU6+yAv9/JNAHk3Erwp5LJnfpbEngxYRGUxb5FUN1NtnA3Lk+x6NeoP6ucDfSC9ypKgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021306; c=relaxed/simple;
	bh=U+ddJ2dQxdwY08eUl+DG3KajTOH9XYPJ0SA1ln/wi/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiKxHtr253x3Touhx984+UROvIMzj5iRC+0XChVyeyBqqiVZGI2kOZdICQIlEgxBFJ7iJa9HVniWVTp7DoFedauD7qwmZZHwtETgdohm2Ex/g8id2lqbR3ul3u1H2Kzp+cvwRMxGN9/MpOnhMHQllRtN0ZWDugKaRDpbCMlqEU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOaRjJYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOaRjJYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BA5C4CEF0;
	Tue, 12 Aug 2025 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021305;
	bh=U+ddJ2dQxdwY08eUl+DG3KajTOH9XYPJ0SA1ln/wi/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOaRjJYIH6Joq+OSc+JSH3m8McC3MN7ulK9++aXfKR5r+/S0MjZpzQN55N9wPCKNh
	 8P9MzLoUirUq1az7YunYRF7Cd0Tu2ayjKjle+YQWiZ5icgWyeVvVMOEQp1xgVBAFfP
	 O/D6TjDmdAg/wfTthSYDolrIQV87XFqQ2eC1wXRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 241/253] ksmbd: fix corrupted mtime and ctime in smb2_open
Date: Tue, 12 Aug 2025 19:30:29 +0200
Message-ID: <20250812172959.102222727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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
@@ -562,7 +562,8 @@ int ksmbd_vfs_getattr(const struct path
 {
 	int err;
 
-	err = vfs_getattr(path, stat, STATX_BTIME, AT_STATX_SYNC_AS_STAT);
+	err = vfs_getattr(path, stat, STATX_BASIC_STATS | STATX_BTIME,
+			AT_STATX_SYNC_AS_STAT);
 	if (err)
 		pr_err("getattr failed, err %d\n", err);
 	return err;


