Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8F14C81;
	Thu, 15 Jan 2026 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497836; cv=none; b=mkD3se16gZmDhqzHnj96rgEyVm80bXBqBOtJWUDoarmLDzOpkUJIJvdUnrj/Apb5XNv+kkD0TgIwtz05Kd20ZP7dU+iz6+SDaaGXXB+gklqx4v5pm8sAFbhCXV86lrL1N1RPBXyvZFg4QYQZZpqP9Z4MzNm4RdwvXi6gBDrD31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497836; c=relaxed/simple;
	bh=hgvxBlpTSTMDBvIm8gAEtSJsW3PMZEaHKrX7HIozog4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snIPDv8FknFvhd876zCAUTIxHVBfIjxFTp05lBI1Ow1ucKsZw3D8P3bhvk24rgvD3PiAou07XEWYFQP2b8s5WSaozjr449bhWtQwHkSX/SIXxYcLVcTPC05xLzGZH9AJUj5VGnmr4CdkWkBtYmzwT+Kk2m65wiF9mj8R+It7pSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hu5VW+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hu5VW+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D50C116D0;
	Thu, 15 Jan 2026 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497835;
	bh=hgvxBlpTSTMDBvIm8gAEtSJsW3PMZEaHKrX7HIozog4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hu5VW+9pt7YuQUulLj0oi6aD8bzJfOgHhJzsfTUl5BMg4Bp34CTRqDzaxLoLWEuv
	 a3ZFdruJXV0jer3T2DR7k91pxYvE/mHFhRG7lR5uCWMRXt6rYGA22JveQ68crZQMFg
	 j+eY36js+GRPH+I7WHCS7dkPcWcd52ELkBCTuyHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/554] btrfs: scrub: always update btrfs_scrub_progress::last_physical
Date: Thu, 15 Jan 2026 17:44:47 +0100
Message-ID: <20260115164254.246669092@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 54df8b80cc63aa0f22c4590cad11542731ed43ff ]

[BUG]
When a scrub failed immediately without any byte scrubbed, the returned
btrfs_scrub_progress::last_physical will always be 0, even if there is a
non-zero @start passed into btrfs_scrub_dev() for resume cases.

This will reset the progress and make later scrub resume start from the
beginning.

[CAUSE]
The function btrfs_scrub_dev() accepts a @progress parameter to copy its
updated progress to the caller, there are cases where we either don't
touch progress::last_physical at all or copy 0 into last_physical:

- last_physical not updated at all
  If some error happened before scrubbing any super block or chunk, we
  will not copy the progress, leaving the @last_physical untouched.

  E.g. failed to allocate @sctx, scrubbing a missing device or even
  there is already a running scrub and so on.

  All those cases won't touch @progress at all, resulting the
  last_physical untouched and will be left as 0 for most cases.

- Error out before scrubbing any bytes
  In those case we allocated @sctx, and sctx->stat.last_physical is all
  zero (initialized by kvzalloc()).
  Unfortunately some critical errors happened during
  scrub_enumerate_chunks() or scrub_supers() before any stripe is really
  scrubbed.

  In that case although we will copy sctx->stat back to @progress, since
  no byte is really scrubbed, last_physical will be overwritten to 0.

[FIX]
Make sure the parameter @progress always has its @last_physical member
updated to @start parameter inside btrfs_scrub_dev().

At the very beginning of the function, set @progress->last_physical to
@start, so that even if we error out without doing progress copying,
last_physical is still at @start.

Then after we got @sctx allocated, set sctx->stat.last_physical to
@start, this will make sure even if we didn't get any byte scrubbed, at
the progress copying stage the @last_physical is not left as zero.

This should resolve the resume progress reset problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index aac4ee5880952..3d5cb6e6b3bbe 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4090,6 +4090,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	unsigned int nofs_flag;
 	bool need_commit = false;
 
+	/* Set the basic fallback @last_physical before we got a sctx. */
+	if (progress)
+		progress->last_physical = start;
+
 	if (btrfs_fs_closing(fs_info))
 		return -EAGAIN;
 
@@ -4126,6 +4130,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
 	if (IS_ERR(sctx))
 		return PTR_ERR(sctx);
+	sctx->stat.last_physical = start;
 
 	ret = scrub_workers_get(fs_info, is_dev_replace);
 	if (ret)
-- 
2.51.0



