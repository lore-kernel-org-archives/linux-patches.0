Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284BA139D1E;
	Tue, 14 May 2024 11:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687068; cv=none; b=Y4GqS28ROl0JubJR2sGWWbRGKot1/AfNnlIaMPVySPywGhPFGkrVvB8Ej1LsUaD/N7Aj4VDOU+ZkTwx+pCTpSnt4d0K+uza8bKaRxZrr4+OBmPfDrA4KGxzwC2osCWzH2iuijswY/wIDd/eg/MEwdux/CGQsXlxxu6cnuIz3AZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687068; c=relaxed/simple;
	bh=yYosZi+aEBC1xhJe1FjW83MsY1x8dsdAFRlzpFInz08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkVKT68Lr/dLsoGlRNYkI23IGta2lMKTgPNFKmvC4EB3fNXcGgi5Zs6I01wI0LXYJ6uhx9QS9EeYfSd41AiSv2PSbS8pepRtA0fGnyXFY1HV7kprpA2NtajMs+Okr8SiazWR2fqNU4nn1WTt2GDcYZEpf8sPWdI1l6rcVP20NII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8WMPCse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8WMPCse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1192C2BD10;
	Tue, 14 May 2024 11:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687068;
	bh=yYosZi+aEBC1xhJe1FjW83MsY1x8dsdAFRlzpFInz08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8WMPCsev8KWCCSsMWkhUQ2vDx0vo8xZ+a06gsAkS4ZkeVqJLOqJqHe5xYjK44J5/
	 NNdBv5YpIgT0TtmSkVKuBEZ4QmqV2s8HLlG/QdHIjUWTAQis/+EXH4scU+3D5lVjh/
	 KBghPXn2mHFKQcYc3/SouMIHGkjP0WV8lBR5UL0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/84] 9p: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:20:04 +0200
Message-ID: <20240514100953.681076081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ee9cabac12041..14d6cb0316212 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -676,6 +676,7 @@ const struct file_operations v9fs_file_operations = {
 	.lock = v9fs_file_lock,
 	.mmap = generic_file_readonly_mmap,
 	.fsync = v9fs_file_fsync,
+	.setlease = simple_nosetlease,
 };
 
 const struct file_operations v9fs_file_operations_dotl = {
@@ -711,4 +712,5 @@ const struct file_operations v9fs_mmap_file_operations_dotl = {
 	.flock = v9fs_file_flock_dotl,
 	.mmap = v9fs_mmap_file_mmap,
 	.fsync = v9fs_file_fsync_dotl,
+	.setlease = simple_nosetlease,
 };
-- 
2.43.0



