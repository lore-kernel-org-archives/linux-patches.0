Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8548634EEF7;
	Wed, 20 May 2026 18:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302515; cv=none; b=YNSBd60l088umoTW3Td2eex+bvrDoLEFUdneFCnlJIHeqbleND7vWpV4IHE9GlAAQO2voK06GhCH0CYmUJwE/p6a0HIUnIwyg7BXATsYp9yjwXC1QGLIkpZk2VbjDKX4PGp56KwQX0IhUKiRwqwLtyGcReyKV2/lz3xOHqXG6O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302515; c=relaxed/simple;
	bh=UngvQd5qgJy3YgVy227pA8aaMXWOH+aLYeDvbpjOJi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uctTaXzmkVWx2VmxZi5Sf2errg75vGCWU5/qs4KNqXGhLroPbhZlm8YwhvajOjv4zSVIhZBnMtoZ1SMoaVSr51KlRbgNfp1tdcUb7y3h5o2TmB2ZiQC4urzTU5mfPsolxPjPPtRSoHgvfFFzkMY+AmPmWCuWDX2LR93BemZpaNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAbW6pmO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAbW6pmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA541F000E9;
	Wed, 20 May 2026 18:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302514;
	bh=Y2IBCAJhWkdCcBuvST3ByhjAoJsJ/KvtpAZRfHS2ZM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAbW6pmOxcbO1xiSbzh25s2yJgnzOcO5RORvM9aQmXgP6p/UcIvtB0GRm4kgJbYQi
	 B8LY1HK/pSNw9A3LlVVcry6cOgHsd5d4SGmBDFWbogLf49QhexbVly9eZwaKxTrL4Y
	 QdkgbwveuTdw/kdQt6T5m3hrT+fqOH9QAIuxcVtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/508] f2fs: protect extension_list reading with sb_lock in f2fs_sbi_show()
Date: Wed, 20 May 2026 18:21:57 +0200
Message-ID: <20260520162105.016359415@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 7d377da9c2631..4cd2d4bde217a 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -318,10 +318,12 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
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
@@ -329,6 +331,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 		len += sysfs_emit_at(buf, len, "hot file extension:\n");
 		for (i = cold_count; i < cold_count + hot_count; i++)
 			len += sysfs_emit_at(buf, len, "%s\n", extlist[i]);
+		f2fs_up_read(&sbi->sb_lock);
 
 		return len;
 	}
-- 
2.53.0



