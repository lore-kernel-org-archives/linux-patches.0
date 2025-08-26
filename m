Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEDC1FECAB;
	Tue, 26 Aug 2025 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208553; cv=none; b=kJse8nolFtPtBR9fKsoYXijOH7ss6x13Siz9mbhGtWMlzM53lpmkkXzLqUq6cHOGEZ1hx3fZGwhyk1kp2IQOKjjp8GxaLnd34LkdPox6sboy0ed6DlrL3q90v8E35k6Wka2LM/amXseCz+Ww3UNhQ8MapIXYc7WaYjwtgamBQ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208553; c=relaxed/simple;
	bh=3vWyr/qVflU09CUJf8IS0spJ1WLMgXOKgB4XsC4dZ1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nu+7a7XoUYqjDX/w+5ELtAyVZJYz/eEElI+w8CNyUH0vSPj9crBp6gXoVYezOlVJRSKI8p5iWi9JLzuQL6jnHafqWvRlQP654wkKjrZffVA+SkNXtNUNTflI3bYV000EXh0zoZhsyo/3Mh9iBXCOhD8gzAN/iNxAPiRKmiqD0A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6sSIxOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6sSIxOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3953C4CEF1;
	Tue, 26 Aug 2025 11:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208553;
	bh=3vWyr/qVflU09CUJf8IS0spJ1WLMgXOKgB4XsC4dZ1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6sSIxOp4Qc7oapVBfiyAhDc6fZn5BfsPiT4QsdLn2x4gPb7SAmaHfwXg3btLODk4
	 yxxAfO0ytnXff+KMRmGNBzRpedbvN/qIYO6tQPXgsIhMJ3kec6BQXBMy2G9S6Ssm5L
	 A+kX2Q5pDw98pojwAMOFXPsmHstYwCexIEkTCxQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/322] btrfs: send: use fallocate for hole punching with send stream v2
Date: Tue, 26 Aug 2025 13:09:31 +0200
Message-ID: <20250826110919.671006815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 005b0a0c24e1628313e951516b675109a92cacfe ]

Currently holes are sent as writes full of zeroes, which results in
unnecessarily using disk space at the receiving end and increasing the
stream size.

In some cases we avoid sending writes of zeroes, like during a full
send operation where we just skip writes for holes.

But for some cases we fill previous holes with writes of zeroes too, like
in this scenario:

1) We have a file with a hole in the range [2M, 3M), we snapshot the
   subvolume and do a full send. The range [2M, 3M) stays as a hole at
   the receiver since we skip sending write commands full of zeroes;

2) We punch a hole for the range [3M, 4M) in our file, so that now it
   has a 2M hole in the range [2M, 4M), and snapshot the subvolume.
   Now if we do an incremental send, we will send write commands full
   of zeroes for the range [2M, 4M), removing the hole for [2M, 3M) at
   the receiver.

We could improve cases such as this last one by doing additional
comparisons of file extent items (or their absence) between the parent
and send snapshots, but that's a lot of code to add plus additional CPU
and IO costs.

Since the send stream v2 already has a fallocate command and btrfs-progs
implements a callback to execute fallocate since the send stream v2
support was added to it, update the kernel to use fallocate for punching
holes for V2+ streams.

Test coverage is provided by btrfs/284 which is a version of btrfs/007
that exercises send stream v2 instead of v1, using fsstress with random
operations and fssum to verify file contents.

Link: https://github.com/kdave/btrfs-progs/issues/1001
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/bsearch.h>
+#include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/sort.h>
@@ -5518,6 +5519,30 @@ tlv_put_failure:
 	return ret;
 }
 
+static int send_fallocate(struct send_ctx *sctx, u32 mode, u64 offset, u64 len)
+{
+	struct fs_path *path;
+	int ret;
+
+	path = get_cur_inode_path(sctx);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
+
+	ret = begin_cmd(sctx, BTRFS_SEND_C_FALLOCATE);
+	if (ret < 0)
+		return ret;
+
+	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
+	TLV_PUT_U32(sctx, BTRFS_SEND_A_FALLOCATE_MODE, mode);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);
+
+	ret = send_cmd(sctx);
+
+tlv_put_failure:
+	return ret;
+}
+
 static int send_hole(struct send_ctx *sctx, u64 end)
 {
 	struct fs_path *p = NULL;
@@ -5526,6 +5551,14 @@ static int send_hole(struct send_ctx *sc
 	int ret = 0;
 
 	/*
+	 * Starting with send stream v2 we have fallocate and can use it to
+	 * punch holes instead of sending writes full of zeroes.
+	 */
+	if (proto_cmd_ok(sctx, BTRFS_SEND_C_FALLOCATE))
+		return send_fallocate(sctx, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				      offset, end - offset);
+
+	/*
 	 * A hole that starts at EOF or beyond it. Since we do not yet support
 	 * fallocate (for extent preallocation and hole punching), sending a
 	 * write of zeroes starting at EOF or beyond would later require issuing


