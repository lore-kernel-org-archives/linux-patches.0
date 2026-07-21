Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB5A46D0A2;
	Tue, 21 Jul 2026 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658104; cv=none; b=ufChd9scmjJi56YBAWlAZvr9GLTanugEqwaxnGhSHpKMIG1nnxfOtSSUOKZhRh+HJEQAmN12wTwIeqCvxzJwsg4pQqtdbzAQcVWgj3RjE58aArV5g6LKXqFBkiM/utLfEqGwyUPkydKrRC51uhsSM999q9rmfYNof9pVG3bp9pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658104; c=relaxed/simple;
	bh=9j05C6ujpwbszH7QSh+rtESoaZtFUfGxK+oaT7/hcwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf/xHkKdIm0uhHCMpLYcweKHI6F5sKsH9Hly1HXUJdUi5VRPcm2yI3Q+XBA/RvTVggxz/oKO4wPBZeD8ZXyiyXPtmyMf3/c5r7SHyJUe5apzUpxSQ878JqB67bM/PYIVD5dLBkjspOqTp3HX22ShkLIq8iSUBbR2aFo3QoisWs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFVw7kZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFVw7kZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59211F000E9;
	Tue, 21 Jul 2026 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658103;
	bh=x49Q7av7HMaI9gm4JRpWl4Vd68NEkoSm0pokRLtaF2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFVw7kZYOZBcvYJogak1UVu2qfyCDGtwXFuzegmQ9T2znqG0f58jC4ovlHvGdfUW3
	 SX6trNdAmNmNDSKmELPTk7OI27wQmjU0YHka4hy2sKFPRK3UO5nyxFenrSAhOJWPqz
	 5XpuTjGx6AkzkVSvHKv4odTWmfSqQ63kijjqMijE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Morduan Zang <zhangdandan@uniontech.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1015/1611] iomap: guard io_size EOF trim against concurrent truncate underflow
Date: Tue, 21 Jul 2026 17:18:51 +0200
Message-ID: <20260721152538.224167065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Morduan Zang <zhangdandan@uniontech.com>

[ Upstream commit 55ec50d046c03b3724741957f7b007856e36dbe7 ]

iomap: fix zero padding data issue in concurrent append writes
changed ioend accounting so that io_size tracks only valid data
within EOF.  This trims io_size when a writeback range extends
past end_pos:

    ioend->io_size += map_len;
    if (ioend->io_offset + ioend->io_size > end_pos)
        ioend->io_size = end_pos - ioend->io_offset;

However, if end_pos ends up below ioend->io_offset, the subtraction
becomes negative and is stored in size_t io_size, causing an unsigned
wrap to a huge value.  This can happen when writeback continues past
byte-level EOF up to a block-aligned range, or when a concurrent
truncate shrinks the file after end_pos was sampled in
iomap_writeback_handle_eof().

A wrapped io_size can mislead append detection and corrupt
completion-time size handling, since filesystem end_io paths consume
io_size for decisions such as on-disk EOF updates and unwritten/COW
completion ranges.

Fix this by clamping io_size to zero when EOF has moved to or before
the ioend start offset.  This preserves the original intent of trimming
io_size to valid in-EOF data while avoiding the underflow.

Fixes: 51d20d1dacbe ("iomap: fix zero padding data issue in concurrent append writes")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
Link: https://patch.msgid.link/9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/ioend.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index fb26cfd9c4cc3a..6c75fbf4d5af46 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -239,8 +239,12 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	 * appending writes.
 	 */
 	ioend->io_size += map_len;
-	if (ioend->io_offset + ioend->io_size > end_pos)
-		ioend->io_size = end_pos - ioend->io_offset;
+	if (ioend->io_offset + ioend->io_size > end_pos) {
+		if (ioend->io_offset >= end_pos)
+			ioend->io_size = 0;
+		else
+			ioend->io_size = end_pos - ioend->io_offset;
+	}
 
 	wbc_account_cgroup_owner(wpc->wbc, folio, map_len);
 	return map_len;
-- 
2.53.0



