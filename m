Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F2A18B00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhQz0nRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C6BC433C9;
	Mon,  9 Oct 2023 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856957;
	bh=e1uZ4AEJYrs58ypu8pc1rZc9SlrGLusJIwAHVUeFQJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhQz0nRm5WewOc5q1jRuA92/telqfCH9v2dWf4jCYRWfiHDasYMytIqAFeTy8mCiT
	 VEEe9DnzDL7BwpvXSiLDa87rCfeUU7AU1Qm2kmCP1YqVhCqk+9+3pdNi19Sh1geet6
	 F75o2zV+OMhmnE9RekpQM/kwEhP/1ZFv9L6aMmUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 048/163] btrfs: always print transaction aborted messages with an error level
Date: Mon,  9 Oct 2023 15:00:12 +0200
Message-ID: <20231009130125.356987460@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit f8d1b011ca8c9d64ce32da431a8420635a96958a upstream.

Commit b7af0635c87f ("btrfs: print transaction aborted messages with an
error level") changed the log level of transaction aborted messages from
a debug level to an error level, so that such messages are always visible
even on production systems where the log level is normally above the debug
level (and also on some syzbot reports).

Later, commit fccf0c842ed4 ("btrfs: move btrfs_abort_transaction to
transaction.c") changed the log level back to debug level when the error
number for a transaction abort should not have a stack trace printed.
This happened for absolutely no reason. It's always useful to print
transaction abort messages with an error level, regardless of whether
the error number should cause a stack trace or not.

So change back the log level to error level.

Fixes: fccf0c842ed4 ("btrfs: move btrfs_abort_transaction to transaction.c")
CC: stable@vger.kernel.org # 6.5+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -218,8 +218,8 @@ do {								\
 			(errno))) {					\
 			/* Stack trace printed. */			\
 		} else {						\
-			btrfs_debug((trans)->fs_info,			\
-				    "Transaction aborted (error %d)", \
+			btrfs_err((trans)->fs_info,			\
+				  "Transaction aborted (error %d)",	\
 				  (errno));			\
 		}						\
 	}							\


