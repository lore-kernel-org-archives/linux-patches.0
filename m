Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C97FC1D;
	Tue, 26 Aug 2025 12:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212736; cv=none; b=J1Axwwbfqs2eEvcBr4KRuTydceJ+HIJ/4mVfYd95aaLmYpEDnZlo29GkGJhf2EfQPbWzxfite6y3b9lGXJ5nWRC14d+RmHCjhb9cgSOC63i88ZwhGQXSN3U9jyfos9ZUYiuIKCbEyO8ENQy2q0QCbWi5ZP0+FHy0d7ccjH4awMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212736; c=relaxed/simple;
	bh=4j7X8lo9HrDMzruo24zrsk2mR5J8ardP1WnmvDz+dK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q93vKqlYx/l/rNsmNpWJAoQcYzMZJesplwulBeNl1UTwF1+d4ypH3fp49b6BPARZ42ULQnGykIONGNv2Cqb8jJ9Yx6NK4/7UBYQzzVWEDXYlhulfPCjpxULItUmWoSce9sMxEIDLPGDZOmPOIJ/mHN9TspYEzZe0Wolek/Nm6LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKCFHoG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKCFHoG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CF7C4CEF1;
	Tue, 26 Aug 2025 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212735;
	bh=4j7X8lo9HrDMzruo24zrsk2mR5J8ardP1WnmvDz+dK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKCFHoG8VGb3WACG3dqXBaPMlZhS00BRug2S+1DlFwttT6DmSrLa3sd7rkcdOHIs5
	 FRTi6IPeAAwfCLdxmVza2kNIMz7d0qgcn5fJ8IFpsVZ5jw/ZY5Z3kGpdN2dKWF5Btc
	 AezYifg1OEHglLuvlHGNftQ8GV7pPNev379s7d/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/587] tracefs: Add d_delete to remove negative dentries
Date: Tue, 26 Aug 2025 13:03:51 +0200
Message-ID: <20250826110955.020818672@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 7d389dd5ed51..6b70965063d7 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -483,9 +483,20 @@ static int tracefs_d_revalidate(struct dentry *dentry, unsigned int flags)
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
 
 static int trace_fill_super(struct super_block *sb, void *data, int silent)
-- 
2.39.5



