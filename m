Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F093F439331;
	Mon, 31 Aug 2026 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184582; cv=none; b=klEd/bJmR6R71utnvb9wkKitJ1xdkVN7bFOlD/hENby45S9n0Eq7AnAjl6QzExg1JyzCVHWsSnBrHIS6k4rxZujMFR8dxFkH8PQ6A+7aExUf0KauPlfjOcPlbPMpJGl0BQMFbhbqYjORSM3lgynI8UwLvAV+uuloo5HlR+VnuxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184582; c=relaxed/simple;
	bh=uwFpXiSEIOX3xZdl4VaHCuxfKMAswD5ReDSPDKAy+Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPsRYyRdHYWp4CvV+kimY5hmp0WXRMU23rV2KNopZ2iDtVxfYkHSD4jjhOizE0ddRQT7/kO1zTQZMkRtU/lrefY1JyUnCnjkkH+NYAFkzwIwkF5ArXC1dNGQ7nAjPmcGvMSkJwLW9m48WnYjuOu4pT3u1Fp2V+Y7xTXFuMHGp/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uS/8zVQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uS/8zVQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DB91F000E9;
	Mon, 31 Aug 2026 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184580;
	bh=dhSBzO63CFTHMhTpwCWDBxCcuH5cxB1mzR124tdNNrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uS/8zVQNn31frPB0lk6HbfQ+2mhkdXHfrL7aKKA9zRb7fXPZFx8zybsKi343PneCX
	 7JjOxLBLzX481WSSzSLhsuztIvs5W4yNzK+7awqvsJy4L9JJcP3XGf95+LfNW9NiLu
	 Wo5uQ/mGYjocYEi2HUVdGzMS7O4pEIk20jDF8WbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rostedt@goodmis.org,
	david.laight.linux@gmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH 6.6 56/91] xfs: remove file_path tracepoint data
Date: Mon, 31 Aug 2026 15:34:44 +0200
Message-ID: <20260831133402.649451301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Darrick J. Wong <djwong@kernel.org>

commit e31c53a8060e134111ed095783fee0aa0c43b080 upstream.

The xfile/xmbuf shmem file descriptions are no longer as detailed as
they were when online fsck was first merged, because moving to static
strings in commit 60382993a2e180 ("xfs: get rid of the
xchk_xfile_*_descr calls") removed a memory allocation and hence a
source of failure.

However this makes encoding the description in the tracepoints sort of a
waste of memory.  David Laight also points out that file_path doesn't
zero the whole buffer which causes exposure of stale trace bytes, and
Steven Rostedt wonders why we're not using a dynamic array for the file
path.

I don't think this is worth fixing, so let's just rip it out.

Cc: rostedt@goodmis.org
Cc: david.laight.linux@gmail.com
Link: https://lore.kernel.org/linux-xfs/20260323172204.work.979-kees@kernel.org/
Cc: stable@vger.kernel.org # v6.11
Fixes: 19ebc8f84ea12e ("xfs: fix file_path handling in tracepoints")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Karl Mehltretter: Omit the xmbuf_create hunk because that tracepoint
  is not in 6.6.y.  The xfile_create hunk applies unchanged.  This drops
  dynamically generated descriptions because 60382993a2e1 is not in
  6.6.y, but fixes the stale-byte exposure and matches newer stable
  kernels. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -784,20 +784,12 @@ TRACE_EVENT(xfile_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		*path;
-
 		__entry->ino = file_inode(xf->file)->i_ino;
-		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
-		if (IS_ERR(path))
-			strncpy(__entry->pathname, "(unknown)",
-					sizeof(__entry->pathname));
 	),
-	TP_printk("xfino 0x%lx path '%s'",
-		  __entry->ino,
-		  __entry->pathname)
+	TP_printk("xfino 0x%lx",
+		  __entry->ino)
 );
 
 TRACE_EVENT(xfile_destroy,


