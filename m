Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16B5264FA0;
	Tue,  8 Apr 2025 11:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110778; cv=none; b=mbylxUzTPWyWSFC0ZZs27A93ejc53OHzLYL7zD0xzxQIH6P7pkGAqY8WFshCZ7mwWU3J4i37Rer/GYOhw4XqYLuaBULG5zirNasvQMWwQEiRnRB3GD3sw6XLG0bm2WXCvdgRrHOcMT2gTmmT0dTZNL1VgN7vfoD9kx2jSmQ3byM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110778; c=relaxed/simple;
	bh=Dae6A5SWUU5gPSj8b1fkufk1etswjRhmHHHqKuJRhYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd711wKF+lufFWxujNvs69LOoXc6zsniNaN4GCEp0M4mN1bKFYOrA1sOuCuF4Nn+VsNUoZ03MZBZayr/M+L9GKQ3OpnGKFdlubZCTd5FZjSxrnUXOpxf+lPS8+hxL/dXRA0P96MZRpgX7i5urnQikT4evQqKVzkYv8NcV75RifE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXBsnucc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXBsnucc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7133EC4CEE5;
	Tue,  8 Apr 2025 11:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110777;
	bh=Dae6A5SWUU5gPSj8b1fkufk1etswjRhmHHHqKuJRhYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXBsnucc2sEPgjUcKih9IfKmTEq8/gYigCf/GejO0pZxsFXwMfy5OirdgTjZjrMff
	 Wx76MJ4o1ZtEQAets+qweLtIi5eHxr1v2JFkdXgfXFKlLWJb89LO62+P/UyYZFJxcF
	 smEQv/k3rtjoQUVTjVjA43y10LMujrXJUMXrQouc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 190/731] erofs: allow 16-byte volume name again
Date: Tue,  8 Apr 2025 12:41:27 +0200
Message-ID: <20250408104918.699556536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 579450277780159b8ba94a08b2f1d1da2002aec5 ]

Actually, volume name doesn't need to include the NIL terminator if
the string length matches the on-disk field size as mentioned in [1].

I tend to relax it together with the upcoming 48-bit block addressing
(or stable kernels which backport this fix) so that we could have a
chance to record a 16-byte volume name like ext4.

Since in-memory `volume_name` has no user, just get rid of the unneeded
check for now.  `sbi->uuid` is useless and avoid it too.

[1] https://lore.kernel.org/r/96efe46b-dcce-4490-bba1-a0b00932d1cc@linux.alibaba.com

Fixes: a64d9493f587 ("staging: erofs: refuse to mount images with malformed volume name")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250225033934.2542635-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h | 2 --
 fs/erofs/super.c    | 8 --------
 2 files changed, 10 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 686d835eb533a..efd25f3101f1f 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -152,8 +152,6 @@ struct erofs_sb_info {
 	/* used for statfs, f_files - f_favail */
 	u64 inos;
 
-	u8 uuid[16];                    /* 128-bit uuid for volume */
-	u8 volume_name[16];             /* volume name */
 	u32 feature_compat;
 	u32 feature_incompat;
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 827b626656494..9f2bce5af9c83 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -317,14 +317,6 @@ static int erofs_read_superblock(struct super_block *sb)
 
 	super_set_uuid(sb, (void *)dsb->uuid, sizeof(dsb->uuid));
 
-	ret = strscpy(sbi->volume_name, dsb->volume_name,
-		      sizeof(dsb->volume_name));
-	if (ret < 0) {	/* -E2BIG */
-		erofs_err(sb, "bad volume name without NIL terminator");
-		ret = -EFSCORRUPTED;
-		goto out;
-	}
-
 	/* parse on-disk compression configurations */
 	ret = z_erofs_parse_cfgs(sb, dsb);
 	if (ret < 0)
-- 
2.39.5



