Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136194B44D0;
	Thu, 17 Sep 2026 18:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668103; cv=none; b=Z9PHEeWZ7Dk3v47XzbI5AiM7IH969+56oWTQRNVVHcP8y4WlCboApNH3JHy4LPQz7ueXCvheK8ROCZcTKEX1HoXVE3GfsR7IiVyobDHznHbfVQTQMsuqflRn8USCar9cUNBuxLP9iL2Q6jheVzHj4xlspbfopZp5yIPOYGQL+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668103; c=relaxed/simple;
	bh=BmmjmFXikXV9YmToOB3+W0Ye58mlolZDiyq4Qa/pOdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSFgGEWBzQz58kcXUT/7mobjEPV46TGttk6OfkTrxRt/fsAswYzw1kwgzBjcJrdGSLQsFeGHWwgV337oKuUYsN7/J9qwRgf7GSN0dUa5vqro0lZaQSz/IGe6LAvZz0rC2yl2rRS+1rclu65JKn5xYmyj7Sx6+fNg6MrXn69yFgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF+uXw2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF+uXw2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5781F000FF;
	Thu, 17 Sep 2026 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668102;
	bh=8+0VmasDWdOTek80u7yJfi+ZzGScAqUTJyRmmsRaL5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jF+uXw2CSXHxfHA024JIdrHo2ULUIgfPjzeXoBUekkHMKVbfnOGDidS9COxTGK/iG
	 gga7K6gjENt3Fv9bRqEu8fwf2pmItB9DGTJqVaVGIvbn6CePUuXik8ds16lJJPLLdM
	 WykPecd3fYi0cSxYAmrYSv/mWS/NqjZX79bcUM/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Timber <dxdt@dev.snart.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0313/1102] exfat: fix handling of damaged volume in exfat_create_upcase_table()
Date: Thu, 17 Sep 2026 16:04:16 +0100
Message-ID: <20260917151547.481008896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: David Timber <dxdt@dev.snart.me>

[ Upstream commit 20dd3185d13865214ff25b0bf7b931e8d73be1ac ]

When the size of the upcase table is set to zero in the dentry for any
reason(e.g. corrupted media or misbehaving device), an integer overflow
causes the module to loop indefinitely.

If the size of the upcase table is read zero, do not attempt to load the
table. Instead, fallback to loading the default upcase table. If the
size of the upcase table is zero or no upcase table is found, raise
exfat_fs_error() to mark the volume read-only.

Signed-off-by: David Timber <dxdt@dev.snart.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 1729bf42eb516..b0e7d554535c0 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -772,13 +772,18 @@ int exfat_create_upcase_table(struct super_block *sb)
 
 			tbl_clu  = le32_to_cpu(ep->dentry.upcase.start_clu);
 			tbl_size = le64_to_cpu(ep->dentry.upcase.size);
-
-			sector = exfat_cluster_to_sector(sbi, tbl_clu);
-			num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
-			ret = exfat_load_upcase_table(sb, sector, num_sectors,
-				le32_to_cpu(ep->dentry.upcase.checksum));
-
+			if (tbl_size) {
+				sector = exfat_cluster_to_sector(sbi, tbl_clu);
+				num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
+				ret = exfat_load_upcase_table(sb, sector, num_sectors,
+					le32_to_cpu(ep->dentry.upcase.checksum));
+			} else {
+				exfat_fs_error(sb,
+					       "bad upcase table size (0 bytes). Please run fsck");
+				ret = -EINVAL;
+			}
 			brelse(bh);
+
 			if (ret && ret != -EIO) {
 				/* free memory from exfat_load_upcase_table call */
 				exfat_free_upcase_table(sbi);
@@ -793,6 +798,8 @@ int exfat_create_upcase_table(struct super_block *sb)
 			return -EIO;
 	}
 
+	exfat_fs_error(sb, "no upcase table entry. Please run fsck");
+
 load_default:
 	/* load default upcase table */
 	return exfat_load_default_upcase_table(sb);
-- 
2.53.0



