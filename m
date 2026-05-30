Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A018C3242D7;
	Sat, 30 May 2026 17:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161689; cv=none; b=YS6VZVB7lXy3Dvi3Bz63xccSksSGjVcYjq3miJWyyn2baNj+YrZD6NXavvhQ2cEOt92yArMYZvjwAvWvtQ1TNuwvj6ZjB4IMMPVbe+UqJWfi+/nS3NrkCRv3Lv8ZNn+aeafkyY6IcH3uepJAsisXnJlHUPeTFnWaX+4mQPHAxNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161689; c=relaxed/simple;
	bh=jR73wVMChLV4RBzBdSoVistNTrvPlq9/SnUcMH2F+Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx80fraglrepeKMUKQenHlWoh41/BWoeJePW+ucKm2q8pKLpEVoEQ3VuIF1AdF9lBixHe/YhqRG1/F8MP+RPY+xLbfSQ4+jfMX+PSnlPzVqWlCx84sG8vOs/Yykal9MdvPFxTRM/94mbMxgZ45e56H/0wXawUBMn1Amh07olcnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXWAYFmB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXWAYFmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5271F00898;
	Sat, 30 May 2026 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161688;
	bh=G6wyqOdmkw4eZ93u4euCQn5z4rn8C5PfrVbN9y09n5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXWAYFmBGgAoWtd/wWVerwDPYAi/GP2bsV9heeb3EpKWNnSCmEGvPr9P06stsQwtD
	 77VfpjEQWcfDOF7QnGtWHWZnGxnOkL12gfx55lBu3E4nw5NWsGyBHxyI306iJgy6wX
	 14piDpwRjpTLhOmnf48qUBx3h0WLFzZ2To7iCZ2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 668/969] f2fs: protect extension_list reading with sb_lock in f2fs_sbi_show()
Date: Sat, 30 May 2026 18:03:12 +0200
Message-ID: <20260530160318.934415474@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aeb95c74710eb..503a50542ac53 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -306,10 +306,12 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
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
@@ -317,6 +319,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 		len += sysfs_emit_at(buf, len, "hot file extension:\n");
 		for (i = cold_count; i < cold_count + hot_count; i++)
 			len += sysfs_emit_at(buf, len, "%s\n", extlist[i]);
+		f2fs_up_read(&sbi->sb_lock);
 
 		return len;
 	}
-- 
2.53.0



