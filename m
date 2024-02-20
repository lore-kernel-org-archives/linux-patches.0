Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC282DF9F;
	Tue, 20 Feb 2024 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464201; cv=none; b=QHIlGbTw63e0RdMAcgdQf83zM2Nejyy2G56SPqikf64ap+ekGPOFUUrcdNw6hQCHrmD5jrZW/ghxkpqz/9jIL69Uj1tk+FZyGHYn/pDOBRNliQZpvKrkQojK3zznpkUX2TpG6tkk7kyQQlgtfbOuCMZryhy6jSAg7iHaAfNNi5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464201; c=relaxed/simple;
	bh=DCNXIC8pmSL1o8EUmqRcKGtv1TlQ9To9dClIkRJylWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdl7UyfeVSfsvRqHZxnZpiBNupX6d2VEzCSNNsg3Pak3/gaM7NJI00BlHlgwiwIFFDvBFnHt/V/6dituC58IAFDHDp5ahUhqFlpx/18Ec0BOApaziIUw7lM4BPzwA99Jb41h7+9YkT0QZHGkM5uTk1W8GqghvgWYeTr/B0ElYx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yA6KSJq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yA6KSJq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E154C433F1;
	Tue, 20 Feb 2024 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464201;
	bh=DCNXIC8pmSL1o8EUmqRcKGtv1TlQ9To9dClIkRJylWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yA6KSJq/oLKKwg2Jj/oQ8ow2ITR49jYRMvMcwLpVHOdKRq2naVOsmcVpXGZb+6dd5
	 JN5fYOYdvwlo8vVeNSVvv5kIafWm0vllfxdhsVwYULMmKW78Dvl3kQaFSpb8nm+2Wj
	 jqhQIk9qRpdecLJCpevYSU3V49dhoF0/r3oC23Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Josef Bacik <josef@toxicpanda.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 283/331] eventfs: Use GFP_NOFS for allocation when eventfs_mutex is held
Date: Tue, 20 Feb 2024 21:56:39 +0100
Message-ID: <20240220205646.856232235@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 4763d635c907baed212664dc579dde1663bb2676 upstream.

If memory reclaim happens, it can reclaim file system pages. The file
system pages from eventfs may take the eventfs_mutex on reclaim. This
means that allocation while holding the eventfs_mutex must not call into
filesystem reclaim. A lockdep splat uncovered this.

Link: https://lkml.kernel.org/r/20231121231112.373501894@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 28e12c09f5aa0 ("eventfs: Save ownership and mode")
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -95,7 +95,7 @@ static int eventfs_set_attr(struct mnt_i
 	if (!(dentry->d_inode->i_mode & S_IFDIR)) {
 		if (!ei->entry_attrs) {
 			ei->entry_attrs = kzalloc(sizeof(*ei->entry_attrs) * ei->nr_entries,
-						  GFP_KERNEL);
+						  GFP_NOFS);
 			if (!ei->entry_attrs) {
 				ret = -ENOMEM;
 				goto out;
@@ -627,7 +627,7 @@ static int add_dentries(struct dentry **
 {
 	struct dentry **tmp;
 
-	tmp = krealloc(*dentries, sizeof(d) * (cnt + 2), GFP_KERNEL);
+	tmp = krealloc(*dentries, sizeof(d) * (cnt + 2), GFP_NOFS);
 	if (!tmp)
 		return -1;
 	tmp[cnt] = d;


