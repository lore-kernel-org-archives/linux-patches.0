Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4346413D605;
	Thu, 13 Jun 2024 11:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279637; cv=none; b=TKqxaPGgmvnLjXUG1XAaRVPq5iotlRJLqoyyhvfl3ODCqL6i7r0j3Kg7rBU91yazrMbilwVEWq2/Kk3JLTIEPc5JXAe/uzY5rfRHE5RZYQxj3tq8l5/mADeMdq5PnT4dQFPbvJYGw8DXopUBB79cnelkvu5WasyrVl5lrQD1bSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279637; c=relaxed/simple;
	bh=9rCiNVMFpvF7FvBobIp93ywVI5O8wg9Uol/r4YwKVLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWgq/Pevsn9C2EFC5lOzYZyk9ELRz0UAYsjTrTIKMbNtWAah83R9f19+deA2VT8/22KDfjnvMUWeDDKdfvTCi0aL5LsptGSXw7inB6BE7mmIzXcWqoJXJHmtToAYqi3huiJ4iFeRb/FMTUUOBm0wudn6jDSZfsyDw8+nMgRpG7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a89Yx/4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a89Yx/4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32FBC2BBFC;
	Thu, 13 Jun 2024 11:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279637;
	bh=9rCiNVMFpvF7FvBobIp93ywVI5O8wg9Uol/r4YwKVLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a89Yx/4j3nPpbJ9hknXJ8d3gycsuAVlFsVSZWWovcMdBs1xm58EgYuNGTB3ufMXXk
	 VmaErnnnh9ZFqoK8EY7xot5J1XyYQ8TMutZV9BGSsQO0vHTxbAnP49HqG8bZmUS9qF
	 JqyRnnO2UM0pTDE5Q3W52P5L8F9bx5BCJWEh/8lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.9 143/157] eventfs: Keep the directories from having the same inode number as files
Date: Thu, 13 Jun 2024 13:34:28 +0200
Message-ID: <20240613113232.935399367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 8898e7f288c47d450a3cf1511c791a03550c0789 upstream.

The directories require unique inode numbers but all the eventfs files
have the same inode number. Prevent the directories from having the same
inode numbers as the files as that can confuse some tooling.

Link: https://lore.kernel.org/linux-trace-kernel/20240523051539.428826685@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Fixes: 834bf76add3e6 ("eventfs: Save directory inodes in the eventfs_inode structure")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -50,8 +50,12 @@ static struct eventfs_root_inode *get_ro
 /* Just try to make something consistent and unique */
 static int eventfs_dir_ino(struct eventfs_inode *ei)
 {
-	if (!ei->ino)
+	if (!ei->ino) {
 		ei->ino = get_next_ino();
+		/* Must not have the file inode number */
+		if (ei->ino == EVENTFS_FILE_INODE_INO)
+			ei->ino = get_next_ino();
+	}
 
 	return ei->ino;
 }


