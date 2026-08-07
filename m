Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A214A343D85;
	Fri,  7 Aug 2026 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113910; cv=none; b=ABdUXxZK22zb9Nr+kX2Tl4FCM9Ngo3zC3sO+D5VYsLXSHF89ZZ/SUEpemFDSStAQTzi6OSfaKgk5UWwFPuBw3pWoGPhmfjkXbY/3rqLupm4l7SoHm+H3fG3OfHXv/fuiPXc8PcE6+qpud2A5MUD1G/7ptoguSMDlzhNRYc8c3yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113910; c=relaxed/simple;
	bh=FLuz0/o9UX3aldJsnJOfrPBACmPxtmu5pXE3or1Fm/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAwiJsr2H/Pa4EQS1Qp9cW9qVUjyHPMEq+yJPumegsQ79yqrEzsvvE4hgGWGhKmQWNMgR0bYWuxviRWCTQO7BbSYaxt7Fx3BretGeKlSryzodqTjBWvvTuP4Mi1oWOzERj7VfQRHMQVUmpmacAtIEGfCnf2OfJ81E4V+7Q2QbxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSluZwTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSluZwTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F2A1F000E9;
	Fri,  7 Aug 2026 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113908;
	bh=qjrgbFThSJdivD+XDXJ42dXI0hIwnxsaGwUFDZlTDT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSluZwTzAkMI+gH+LWxQtTcmwIOLs8ygEWfjyCmRTxuob14YQmuvrBlNf7K2Yugec
	 /p0zl03eTnWJb/bIlLIWB17EDOYVK6MiP+C8MUw3BpPTRzE4pI223cbPrK3cN7P0nu
	 RiN0IWa14cPER6U6t5hRf/IRi4bR+AuRCIgznUc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/337] btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag
Date: Fri,  7 Aug 2026 16:33:56 +0200
Message-ID: <20260807143419.234715620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 6881f45d0eb541f2cee8c37c84b3860a23823bb3 ]

[BUG]
The following script can lead to unexpected qgroup rescan failure:

  # mkfs.btrfs -f -O quota $dev
  # mount $dev $mnt
  # mount -o remount,rescue=ibadroots $mnt
    ^^^^^ This above command is expected to fail

  # btrfs quota rescan -w $mnt
    ^^^^^ The above qgroup rescan is not expected to fail

  # btrfs qgroup show $mnt
  WARNING: qgroup data inconsistent, rescan recommended
  Qgroupid    Referenced    Exclusive   Path
  --------    ----------    ---------   ----
  0/5           16.00KiB     16.00KiB   <toplevel>

The above short script will be converted to a proper fstests case.

[CAUSE]
Inside btrfs_reconfigure(), if either btrfs_check_options() or
btrfs_check_features() failed, we will always have
BTRFS_FS_STATE_REMOUNTING set for the fs until the next successful
remount.

That BTRFS_FS_STATE_REMOUNTING flag will interrupt several operations,
including:

- Qgroup rescan
- Auto defrag
- Space reclaim

[FIX]
Change the error handling of btrfs_check_options() and
btrfs_check_features() to goto restore label.

Fixes: eddb1a433f26 ("btrfs: add reconfigure callback for fs_context")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 21419bc33863b..c8ad43f94db0d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1509,12 +1509,14 @@ static int btrfs_reconfigure(struct fs_context *fc)
 	sync_filesystem(sb);
 	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
 
-	if (!btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags))
-		return -EINVAL;
+	if (!btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags)) {
+		ret = -EINVAL;
+		goto restore;
+	}
 
 	ret = btrfs_check_features(fs_info, !(fc->sb_flags & SB_RDONLY));
 	if (ret < 0)
-		return ret;
+		goto restore;
 
 	btrfs_ctx_to_info(fs_info, ctx);
 	btrfs_remount_begin(fs_info, old_ctx.mount_opt, fc->sb_flags);
-- 
2.53.0



