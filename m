Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B391B309F10;
	Mon, 13 Oct 2025 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369464; cv=none; b=t8k2gxdPrORLvob/CxshQcqh7UwnV8lAovmgW9f+DalFrp/gYKk9GsYZQ1+3CBoZBpWl/YD5D8N5cqB7AC/dghldC6NO+Dlx8AGXZ0238h2AInHd5bIzgUdXEd9lR4Pz6AdTyTXmhM8UrZoTEVjh23rYQmOLyIC4vBPN+DSSO+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369464; c=relaxed/simple;
	bh=pRbHE63nhPV10hUgdA8KGsvcaEXiNeeOYKs+3SsNl2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4DBoP2xwbQXi6/WrNc8eB8q+ZNiXWYV7KhgdVU2L7tzxawfIAaNKSZvUS2+QMKJKjsrb/Y25Ey5IxAAdLFf46ro+4ZPOVo7W6nLhlcr/va1LZ8LvGcIZBXyA19SwEyo97NE2Jn83Q2CvGPAkjJHxrWd4XOcgGro0OucWej/tnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pP2cKfNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP2cKfNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BBFC4CEE7;
	Mon, 13 Oct 2025 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369464;
	bh=pRbHE63nhPV10hUgdA8KGsvcaEXiNeeOYKs+3SsNl2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP2cKfNWJq70L4OYRTaq/jLyztHVCpmf8C+lEM7WGseN9RYOrDfItvXrWrh0vKAx/
	 k9fzGAov8XkfBahs9HEwOBnLJABvSQgRsgyeUbxE1geBjhFX1J6ly7AO388AByVAKZ
	 nqXGC5eYdt8Ee5mtxS3xvKRwe99gmdPcsZUSsabg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 255/563] f2fs: fix to allow removing qf_name
Date: Mon, 13 Oct 2025 16:41:56 +0200
Message-ID: <20251013144420.517667398@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit ff11d8701b77e303593fd86cf9ef74ef3ac4048e ]

The mount behavior changed after commit d18535132523 ("f2fs: separate the
options parsing and options checking"), let's fix it.

[Scripts]
mkfs.f2fs -f /dev/vdb
mount -t f2fs -o usrquota /dev/vdb /mnt/f2fs
quotacheck -uc /mnt/f2fs
umount /mnt/f2fs
mount -t f2fs -o usrjquota=aquota.user,jqfmt=vfsold /dev/vdb /mnt/f2fs
mount|grep f2fs
mount -t f2fs -o remount,usrjquota=,jqfmt=vfsold /dev/vdb /mnt/f2fs
mount|grep f2fs
dmesg

[Before commit]
mount#1: ...,quota,jqfmt=vfsold,usrjquota=aquota.user,...
mount#2: ...,quota,jqfmt=vfsold,...
kmsg: no output

[After commit]
mount#1: ...,quota,jqfmt=vfsold,usrjquota=aquota.user,...
mount#2: ...,quota,jqfmt=vfsold,usrjquota=aquota.user,...
kmsg: "user quota file already specified"

[After patch]
mount#1: ...,quota,jqfmt=vfsold,usrjquota=aquota.user,...
mount#2: ...,quota,jqfmt=vfsold,...
kmsg: "remove qf_name aquota.user"

Fixes: d18535132523 ("f2fs: separate the options parsing and options checking")
Cc: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bf0497187bdff..8086a3456e4d3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1189,8 +1189,11 @@ static int f2fs_check_quota_consistency(struct fs_context *fc,
 				goto err_jquota_change;
 
 			if (old_qname) {
-				if (new_qname &&
-					strcmp(old_qname, new_qname) == 0) {
+				if (!new_qname) {
+					f2fs_info(sbi, "remove qf_name %s",
+								old_qname);
+					continue;
+				} else if (strcmp(old_qname, new_qname) == 0) {
 					ctx->qname_mask &= ~(1 << i);
 					continue;
 				}
-- 
2.51.0



