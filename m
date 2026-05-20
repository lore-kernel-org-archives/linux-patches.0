Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA9C3D7D7B;
	Wed, 20 May 2026 17:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298907; cv=none; b=qW3QEHbSLreTQithgw/sCnPtieYZhhwO4wMyTwX71VLU7dRXfZKuYkre7IX+og9eqNBPMHEes5Apsjqo9nX9M7eqCOPErvv0yyIxfisa4+IDmAIrnJ0Ib8AwcRbgJhypkh5KSvKGt4WSmbPnazsk932rRwCExgW+4nsfQrsLosM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298907; c=relaxed/simple;
	bh=ElAxiPCs/N+GxrnFoQvMF32F59UKRR+7AyGhv64Zm1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j07FgdynagYvpJVtWidg/aNTUINPQ5IC2VXQ6tzMy+UBZeqHVNIniKanGxq77uWQ8N2XZ3j594EE6c8Tm4YZ3z9H+u1pivfZf7tB0Bl4E26ePxjuSYiOildZ3aopk5AV0CnXUX1DbDFMB2bw6DJ6joObQZdHRCo3Gt0db0A1BFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiBv1zS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiBv1zS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAAC1F000E9;
	Wed, 20 May 2026 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298906;
	bh=Ju19b2qCMUofhEbMqoDAZOOvvSIhx/tdtJ1R/crApXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiBv1zS0I1xtm8fg0oqS1YLH35saSjyPZ4SoG1s/ljT6uDq3M94qvY6CSz1JauVV0
	 RGhwYZNz2dJ0/dhIX3cVsseyHkY12biA2peKDDsqmG58ce8X5GKykDLyzIZG3YcpP/
	 bmZ1fMqMaTq3tswJoxi7Nujbo65DVvfzRa5DG7m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 590/957] f2fs: protect extension_list reading with sb_lock in f2fs_sbi_show()
Date: Wed, 20 May 2026 18:17:53 +0200
Message-ID: <20260520162147.326520452@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 5909bedbed38c558bee7cb6758ceedf9bc3a9194 ]

In f2fs_sbi_show(), the extension_list, extension_count and
hot_ext_count are read without holding sbi->sb_lock. If a concurrent
sysfs store modifies the extension list via f2fs_update_extension_list(),
the show path may read inconsistent count and array contents, potentially
leading to out-of-bounds access or displaying stale data.

Fix this by holding sb_lock around the entire extension list read
and format operation.

Fixes: b6a06cbbb5f7 ("f2fs: support hot file extension")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index a75c3ef300bd2..1f5982a0a6326 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -377,10 +377,12 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 	if (!strcmp(a->attr.name, "extension_list")) {
 		__u8 (*extlist)[F2FS_EXTENSION_LEN] =
 					sbi->raw_super->extension_list;
-		int cold_count = le32_to_cpu(sbi->raw_super->extension_count);
-		int hot_count = sbi->raw_super->hot_ext_count;
+		int cold_count, hot_count;
 		int len = 0, i;
 
+		f2fs_down_read(&sbi->sb_lock);
+		cold_count = le32_to_cpu(sbi->raw_super->extension_count);
+		hot_count = sbi->raw_super->hot_ext_count;
 		len += sysfs_emit_at(buf, len, "cold file extension:\n");
 		for (i = 0; i < cold_count; i++)
 			len += sysfs_emit_at(buf, len, "%s\n", extlist[i]);
@@ -388,6 +390,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 		len += sysfs_emit_at(buf, len, "hot file extension:\n");
 		for (i = cold_count; i < cold_count + hot_count; i++)
 			len += sysfs_emit_at(buf, len, "%s\n", extlist[i]);
+		f2fs_up_read(&sbi->sb_lock);
 
 		return len;
 	}
-- 
2.53.0



