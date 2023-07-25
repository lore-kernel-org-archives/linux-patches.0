Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57DD1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5472AC433C8;
	Tue, 25 Jul 2023 10:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282742;
	bh=rOPkcVZo97jOqtpgu7S2ZEpvotSZL9u3SxSmgcePGqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gtq1DsIfdrTcE+LUbn1nhOH9z9ZmX+k4H0RnVTGzxOMsApD5ATmRoSgVAu1bAXrPA
	 Bl4ZcELx5/OlHKiUVIa7Fzg/e8eraeMt7BQlc+6nMYwCc5ktYcZL8drVMsg+p3Tq59
	 SvXA8nsLSUD8nLCktiLF2oEcYdCwF5TSNJveAwzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 011/183] fuse: Apply flags2 only when userspace set the FUSE_INIT_EXT
Date: Tue, 25 Jul 2023 12:43:59 +0200
Message-ID: <20230725104508.222712449@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bernd Schubert <bschubert@ddn.com>

commit 3066ff93476c35679cb07a97cce37d9bb07632ff upstream.

This is just a safety precaution to avoid checking flags on memory that was
initialized on the user space side.  libfuse zeroes struct fuse_init_out
outarg, but this is not guranteed to be done in all implementations.
Better is to act on flags and to only apply flags2 when FUSE_INIT_EXT is
set.

There is a risk with this change, though - it might break existing user
space libraries, which are already using flags2 without setting
FUSE_INIT_EXT.

The corresponding libfuse patch is here
https://github.com/libfuse/libfuse/pull/662

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Fixes: 53db28933e95 ("fuse: extend init flags")
Cc: <stable@vger.kernel.org> # v5.17
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1127,7 +1127,10 @@ static void process_init_reply(struct fu
 		process_init_limits(fc, arg);
 
 		if (arg->minor >= 6) {
-			u64 flags = arg->flags | (u64) arg->flags2 << 32;
+			u64 flags = arg->flags;
+
+			if (flags & FUSE_INIT_EXT)
+				flags |= (u64) arg->flags2 << 32;
 
 			ra_pages = arg->max_readahead / PAGE_SIZE;
 			if (flags & FUSE_ASYNC_READ)


