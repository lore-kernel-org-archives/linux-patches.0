Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D3E15E5BB;
	Sat, 17 Oct 2026 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257909; cv=none; b=NHv7Dtccemcf+KkhKT6QWGfyev0KcxGqykmPAgpQAVonjFpv4lwSgp5SWsF0hw/MZSExwCFZOJakAykzFsc1l8/94WpADE6p+AdkGWw1jXFJv0p2B315kf7EDp4Yogi/XLsb0Z3tYvfiHaTFUJPYnTnlX3HpdDL2+xvqeKDWW+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257909; c=relaxed/simple;
	bh=Jg58NsYgY+TK1Fe99yiW0WjvuBX4OpWJ3GzykLX7oOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiSb4TZzA38vhXk0Ajk3Da5ZwhHBW7KECTB8GHslNWy7tavnp+RtTTSfYHXij/4e0lu1R1ArG7PL9FbRBt5zjLxli4FlUDdSPqtq0dTu/BU/LnduZKFl+i7O618KRe3uVvG3xNIG6S21Xmo1M00vTWwCbjsiZlt+gBNnOn+sB8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9lepDOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9lepDOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401C01F000C4;
	Sat, 17 Oct 2026 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257907;
	bh=fVJLfRqY4ni7cTJEkFZ7+RkVuSpfg8WAjAfs8FSYeiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9lepDOrQx7k6pvbZWQrkJ2B4ydvPKdLrsFI6lqnMPU7A53gddBT6QMR4398MkXxD
	 vd0xJiiUSiIZRv864jwlvi6N6uIg5Di+Ik6qhGFu0U6yGcesb8H1ohVBuZHXyUZ2ni
	 EXx+gCFRROFYArubrCyPAuA/7RYbjRFs8FO5xw2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0657/1674] exfat: fix out-of-bounds access of directory entries
Date: Sat, 17 Oct 2026 17:48:49 +0200
Message-ID: <20261017160447.974600810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 184fa506e392eb78364d9283c961217ff2c0617b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 257d153dbfac7..3549c80f927a5 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -657,14 +657,19 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 	info->type = exfat_get_entry_type(ep);
 	info->attr = le16_to_cpu(ep->dentry.file.attr);
 	info->size = le64_to_cpu(ep2->dentry.stream.valid_size);
+
+	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
+	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
+		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
+				info->start_clu);
+		info->size = 0;
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
-- 
2.53.0



