Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDB040862;
	Tue, 14 May 2024 11:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687738; cv=none; b=LnhPdlQdBs2aXWsDmvrn5MbtEFQdkkTJM4hLzv10/7MkHEBfbVU2VIUkL/kbOiWhUxE+dEzTxXON67seRq/G3p4QVCjiWCXmSiD8jTaKQ557upZe+APxvAyHPVTi1KRQhMe4k/slTeMZJkRK2Q886cYIfEPakP2ysy3qSZnuF94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687738; c=relaxed/simple;
	bh=LM7QhylfnORcaZqwYXrudrVJY6CB3pT1McD/y6nQW8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bjf3tvPDoZaEIoIOB8cVMdecjTl+5dhzViuTsjrS4cdvZDpHGB5U9BJdWqSxjxYhjJOd8+IS5L3GCAC1gurvrArNAY0UmDrcC+gCAGNImdEiSiFEP8HeNlSkKLyStYxVKE9fMED8+mjNd/O2E/lMDMbKafwsz49FmfR+S1PnSmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsOFHg0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsOFHg0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9447C32782;
	Tue, 14 May 2024 11:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687738;
	bh=LM7QhylfnORcaZqwYXrudrVJY6CB3pT1McD/y6nQW8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsOFHg0GH6QiPfAWyVjI267XcjgpMyfO8hLq/RHJs78AdS8JgkFG0JDNPDwiGhru5
	 7Ng8udfnVwgilAnbVbhx/HSp0I8UI21zHO+mCPIuYVWrgf/WR0aZUdTOeh7aJj5y40
	 OOHcyoO7CBg8wSZ1eZk9A4fDe+Dg6VQIjMqhRuV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/168] 9p: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:19:46 +0200
Message-ID: <20240514101010.015580033@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7a84602297d36617dbdadeba55a2567031e5165b ]

9p is a remote network protocol, and it doesn't support asynchronous
notifications from the server. Ensure that we don't hand out any leases
since we can't guarantee they'll be broken when a file's contents
change.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 7437b185fa8eb..0c84d414660ca 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -660,6 +660,7 @@ const struct file_operations v9fs_file_operations = {
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync,
+	.setlease = simple_nosetlease,
 };
 
 const struct file_operations v9fs_file_operations_dotl = {
@@ -701,4 +702,5 @@ const struct file_operations v9fs_mmap_file_operations_dotl = {
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync_dotl,
+	.setlease = simple_nosetlease,
 };
-- 
2.43.0



