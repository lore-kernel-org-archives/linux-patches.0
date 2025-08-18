Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98F831E0FF;
	Mon, 18 Aug 2025 12:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521688; cv=none; b=cBbK0n7ay4iVrklU+EwLsuX64QQxWYsRIQf7bQNiQ2GgPw9qHDlM1zAI6h2/nt6qm6tVx2S4alAtcasFUmWf1s220bRcpZp5J+0LtRFvkRUAAq3+POyLXuyfwZZwNUtQLIdHht6HRCnT5Kk96pD2gloGiOYdW8bqFHHQTK18VS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521688; c=relaxed/simple;
	bh=P2giNBy2zk3lP1SCkS26DTdXo6plYPw+eIAJJQX76mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YugASrD4QLH2RzMz87VZWnGNf5ajhvZt5pk2jUEzZC+Eb8JBFvtIYdKHg36jLrr1t9ZLlFIhh6GeuJ07AnTH/P0CpEbQOV66Mla8F7aHxR64KS12fV5aQa1bMxMO1+/AB84elKbbvAf9AA/xQ8zib5XLsaBJNd5Gzu1DLr7qmA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3igx91c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3igx91c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3084C4CEEB;
	Mon, 18 Aug 2025 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521688;
	bh=P2giNBy2zk3lP1SCkS26DTdXo6plYPw+eIAJJQX76mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3igx91cGcqg5rKvR5RKO44XnzN8OJ9qJyroIQaexIkEF1Ca82HMQBbfcHi2rGGLm
	 XiVpZjprRYUrJWVndub8Dr3KzwppTAzSDmY972f2zWfYH0/w2UgTHKdmR8I38NwD9N
	 UAYhLQlxszirHk7MxatGt+fs9btsc1BaDxNV7wpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/444] tracefs: Add d_delete to remove negative dentries
Date: Mon, 18 Aug 2025 14:42:00 +0200
Message-ID: <20250818124452.472397005@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit d9b13cdad80dc11d74408cf201939a946e9303a6 ]

If a lookup in tracefs is done on a file that does not exist, it leaves a
dentry hanging around until memory pressure removes it. But eventfs
dentries should hang around as when their ref count goes to zero, it
requires more work to recreate it. For the rest of the tracefs dentries,
they hang around as their dentry is used as a descriptor for the tracing
system. But if a file lookup happens for a file in tracefs that does not
exist, it should be deleted.

Add a .d_delete callback that checks if dentry->fsdata is set or not. Only
eventfs dentries set fsdata so if it has content it should not be deleted
and should hang around in the cache.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index cfc614c638da..9f15d606dfde 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -464,9 +464,20 @@ static int tracefs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	return !(ei && ei->is_freed);
 }
 
+static int tracefs_d_delete(const struct dentry *dentry)
+{
+	/*
+	 * We want to keep eventfs dentries around but not tracefs
+	 * ones. eventfs dentries have content in d_fsdata.
+	 * Use d_fsdata to determine if it's a eventfs dentry or not.
+	 */
+	return dentry->d_fsdata == NULL;
+}
+
 static const struct dentry_operations tracefs_dentry_operations = {
 	.d_revalidate = tracefs_d_revalidate,
 	.d_release = tracefs_d_release,
+	.d_delete = tracefs_d_delete,
 };
 
 static int tracefs_fill_super(struct super_block *sb, struct fs_context *fc)
-- 
2.39.5



