Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345A161675;
	Mon,  4 Mar 2024 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589029; cv=none; b=lPmrwWgu58tKy6VkmgtYIAJHKYJY53KbC2nH58VNaNfZkLF+gm2kMUIWMzEbvNTjjuhHefCvusiofKiSC3MeR5aYkNNWughUkrhtqWDIynkmkZ1w4phNS5GRJcP/8NY9ggEoGgrd7w277UiWH+TTWi5+SUhEFCrsoWoMsO6KV/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589029; c=relaxed/simple;
	bh=bdZaaLURvylj/f6GR46F3nEdu2zy9lkwTJKCd9XBTQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVokktvJ5SyWke19PUPuUj/ljh8kQQXcG8jN29QIy5B9rB2nTjITm9clbwbht51W0JWTWkCWCfHFML7Q6aVSZZTPOt6X2X+/KN2rvWJ1OYKlSA7bXAQFkwloRTlbiPzhPnu4SBW4z+3blMeaTOJjjh0D0XgNqnM7qmpKa5+1lTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KbFJ0bT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KbFJ0bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DACC433F1;
	Mon,  4 Mar 2024 21:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589028;
	bh=bdZaaLURvylj/f6GR46F3nEdu2zy9lkwTJKCd9XBTQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KbFJ0bTYMmHHgT00EkTHhmtp3hMXQzJ6Bc/tU6X9MBs8pizcOHhbQUfaLVwrJfrL
	 B0GjO4VhsePCxQ6kzJFyxqcM5fzCdT4DI5IjZdzfh99d9/OI6WW7QdxVd5wfPTCMYL
	 ApmHp/cx3S4l5o+b9nNZIqMSl03R5szw6VACrqpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 149/215] NFSD: Flesh out a documenting comment for filecache.c
Date: Mon,  4 Mar 2024 21:23:32 +0000
Message-ID: <20240304211601.753208438@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b3276c1f5b268ff56622e9e125b792b4c3dc03ac ]

Record what we've learned recently about the NFSD filecache in a
documenting comment so our future selves don't forget what all this
is for.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -2,6 +2,30 @@
  * Open file cache.
  *
  * (c) 2015 - Jeff Layton <jeff.layton@primarydata.com>
+ *
+ * An nfsd_file object is a per-file collection of open state that binds
+ * together:
+ *   - a struct file *
+ *   - a user credential
+ *   - a network namespace
+ *   - a read-ahead context
+ *   - monitoring for writeback errors
+ *
+ * nfsd_file objects are reference-counted. Consumers acquire a new
+ * object via the nfsd_file_acquire API. They manage their interest in
+ * the acquired object, and hence the object's reference count, via
+ * nfsd_file_get and nfsd_file_put. There are two varieties of nfsd_file
+ * object:
+ *
+ *  * non-garbage-collected: When a consumer wants to precisely control
+ *    the lifetime of a file's open state, it acquires a non-garbage-
+ *    collected nfsd_file. The final nfsd_file_put releases the open
+ *    state immediately.
+ *
+ *  * garbage-collected: When a consumer does not control the lifetime
+ *    of open state, it acquires a garbage-collected nfsd_file. The
+ *    final nfsd_file_put allows the open state to linger for a period
+ *    during which it may be re-used.
  */
 
 #include <linux/hash.h>


