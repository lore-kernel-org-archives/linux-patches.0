Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212B533BBA0;
	Fri, 21 Nov 2025 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732921; cv=none; b=NBGAb7SfTHZHBsV4Nl4aisILHgkqldMmVuKLX+4Fy1pWnR80knhCEUVap5Tj3Hhz0ow69XpxlaCNAVJtOkQHJfhdisx5r3m8K+OgbnRmrmJptjgOh6CMqeaaE183RsMnynZxncWaOWK5QybuCgUD9CgddXmlGlzqG73Oriq75lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732921; c=relaxed/simple;
	bh=IC0lLrjeCrxLAehc/cU7MPFhGdIz7M7ElLRa7UQQC/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5F3C6wdSv1kshusC9zSDNHKwMlaX/UQk3g6ZDJunvR3h7qdhL5hW3yyStHjD3zAXs4XTozqW/aNemxHM8cAcNyO+JHb3KUtM0bbfed3yqIa8cQ8PjCfbjIKGlpm4SCipR3uAnXO12MDHgFwJiYWWjK8T1IXO0RPfMJ8TzlK0Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+dEVHCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+dEVHCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94893C4CEF1;
	Fri, 21 Nov 2025 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732921;
	bh=IC0lLrjeCrxLAehc/cU7MPFhGdIz7M7ElLRa7UQQC/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+dEVHCJRM0c6IK39vsCBmxlPDI4HgO1Thfo3i3bNuFvjQmhqnjFbEbkenI1xSf27
	 Nicuy5QT7B6tam1ndWSpg3xT20DwLvThcReOFBO6HPNp0+qxClap1ID9BnZrkKafDJ
	 Jcb8zOAFKvkMvMGmQFMCNAUhA7cqw+bwlmlsVQ3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/529] exfat: limit log print for IO error
Date: Fri, 21 Nov 2025 14:09:49 +0100
Message-ID: <20251121130241.346945677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 6dfba108387bf4e71411b3da90b2d5cce48ba054 ]

For exFAT filesystems with 4MB read_ahead_size, removing the storage device
when the read operation is in progress, which cause the last read syscall
spent 150s [1]. The main reason is that exFAT generates excessive log
messages [2].

After applying this patch, approximately 300,000 lines of log messages
were suppressed, and the delay of the last read() syscall was reduced
to about 4 seconds.

[1]:
write(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072 <0.000120>
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072 <0.000032>
write(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072 <0.000119>
read(4, 0x7fccf28ae000, 131072)         = -1 EIO (Input/output error) <150.186215>

[2]:
[  333.696603] exFAT-fs (vdb): error, failed to access to FAT (entry 0x0000d780, err:-5)
[  333.697378] exFAT-fs (vdb): error, failed to access to FAT (entry 0x0000d780, err:-5)
[  333.698156] exFAT-fs (vdb): error, failed to access to FAT (entry 0x0000d780, err:-5)

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 407880901ee3f..e5f4ce8c38e1a 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -89,35 +89,36 @@ int exfat_ent_get(struct super_block *sb, unsigned int loc,
 	int err;
 
 	if (!is_valid_cluster(sbi, loc)) {
-		exfat_fs_error(sb, "invalid access to FAT (entry 0x%08x)",
+		exfat_fs_error_ratelimit(sb,
+			"invalid access to FAT (entry 0x%08x)",
 			loc);
 		return -EIO;
 	}
 
 	err = __exfat_ent_get(sb, loc, content);
 	if (err) {
-		exfat_fs_error(sb,
+		exfat_fs_error_ratelimit(sb,
 			"failed to access to FAT (entry 0x%08x, err:%d)",
 			loc, err);
 		return err;
 	}
 
 	if (*content == EXFAT_FREE_CLUSTER) {
-		exfat_fs_error(sb,
+		exfat_fs_error_ratelimit(sb,
 			"invalid access to FAT free cluster (entry 0x%08x)",
 			loc);
 		return -EIO;
 	}
 
 	if (*content == EXFAT_BAD_CLUSTER) {
-		exfat_fs_error(sb,
+		exfat_fs_error_ratelimit(sb,
 			"invalid access to FAT bad cluster (entry 0x%08x)",
 			loc);
 		return -EIO;
 	}
 
 	if (*content != EXFAT_EOF_CLUSTER && !is_valid_cluster(sbi, *content)) {
-		exfat_fs_error(sb,
+		exfat_fs_error_ratelimit(sb,
 			"invalid access to FAT (entry 0x%08x) bogus content (0x%08x)",
 			loc, *content);
 		return -EIO;
-- 
2.51.0



