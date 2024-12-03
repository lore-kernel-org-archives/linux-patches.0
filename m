Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F311F707A;
	Tue,  3 Dec 2024 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239611; cv=none; b=iKshAxWX+OxEN6k5jkieP+XEgy1ifOgHRNk28BoQzcv3fZPtaW96ipRHxPRimA1V+JKMeY3NNZW3JDkSl+PAIiGGq4J8k21vm44pxRCBtGpNaiug/ieyEYR+jfer5vGe/dph9FCk3GCCuxRXbfBrZDax9BiExbkMHf8TwacHTGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239611; c=relaxed/simple;
	bh=+nPgtdtshirxVEaGowCvaM6ZbyeLlgJh0cl4+peDJ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyxditvjaXcuHfvP0C5WMlVueny/40vs7H81DHYUv4H9+7ERZjPggNwrnQ1RO4kSj55NwEQwa8OuDu5wWzsftppmESusSrxUVA59iGXmcN/M+tqI3dCAlgM1rtRWKaTACnwRuxKdhav0zM4ahhJRR/mKhXzf3bcDNNWueV/8JLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYBg2Jhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYBg2Jhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCF5C4CECF;
	Tue,  3 Dec 2024 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239611;
	bh=+nPgtdtshirxVEaGowCvaM6ZbyeLlgJh0cl4+peDJ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYBg2JhvLxcFdZtLvhN8WuxRvM0mNt4urfPD04ZnYEF6n8EWmJs+1yceImOGV4Vdt
	 Flc1wVqJlrDVvftjo03166GE8CGwd3Wv9FgmlbHVIDCmTmk+RRmnjPlMriDyVbWPqx
	 Z46EMqp4moVPcMY6E8xL9ITdSBbqNqNISYZ8gNr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.11 672/817] exfat: fix out-of-bounds access of directory entries
Date: Tue,  3 Dec 2024 15:44:04 +0100
Message-ID: <20241203144022.188136788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 184fa506e392eb78364d9283c961217ff2c0617b upstream.

In the case of the directory size is greater than or equal to
the cluster size, if start_clu becomes an EOF cluster(an invalid
cluster) due to file system corruption, then the directory entry
where ei->hint_femp.eidx hint is outside the directory, resulting
in an out-of-bounds access, which may cause further file system
corruption.

This commit adds a check for start_clu, if it is an invalid cluster,
the file or directory will be treated as empty.

Cc: stable@vger.kernel.org
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -637,14 +637,26 @@ static int exfat_find(struct inode *dir,
 	info->size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
+
+	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
+	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
+		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
+				info->start_clu);
+		info->size = 0;
+		info->valid_size = 0;
+	}
+
+	if (info->valid_size > info->size) {
+		exfat_warn(sb, "valid_size(%lld) is greater than size(%lld)",
+				info->valid_size, info->size);
+		info->valid_size = info->size;
+	}
+
 	if (info->size == 0) {
 		info->flags = ALLOC_NO_FAT_CHAIN;
 		info->start_clu = EXFAT_EOF_CLUSTER;
-	} else {
+	} else
 		info->flags = ep2->dentry.stream.flags;
-		info->start_clu =
-			le32_to_cpu(ep2->dentry.stream.start_clu);
-	}
 
 	exfat_get_entry_time(sbi, &info->crtime,
 			     ep->dentry.file.create_tz,


