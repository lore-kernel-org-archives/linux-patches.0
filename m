Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678053081AB;
	Tue, 11 Nov 2025 01:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825222; cv=none; b=K3OC2x8PknqOZKtzhfdNjyq17YYkRVFACVWWr2X2h482uCIeuEiCpzX+vmcwP33nkMxA1zbV9F3qd/CBvAB9SI8dedwR9LtApnaD+YQZPnvm1fUvXNk2yUZa35Fdnx4oVJJ1ogDMU5Epu4jTKvlrn7G8rV2OJTcXacBlvEn+gdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825222; c=relaxed/simple;
	bh=d60mMrOMkltGPQSWdDny0lxGi9yMjLTJvlQ1kgVJyOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N85rhTk0dgmJyCD/a3gKmTnAb2vf5mADDvAtzMQx2ekKPc7hcnVy9Qm5V9h8ehh9dGsmnoSq17A/lYLcAGMFiL2xZEEuf+W5834A9DTIbQSUKRTuQJ1Wa7VLO5V3WES6Z37q6T3L7NEVtkEPrce9xVy5mmxJ0KAEZ0rAXoOTl2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeyXuDp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeyXuDp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DE9C116B1;
	Tue, 11 Nov 2025 01:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825222;
	bh=d60mMrOMkltGPQSWdDny0lxGi9yMjLTJvlQ1kgVJyOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeyXuDp8Aad9v3RVNRB3U2GnIF8qcuGmWGGQfaYnKTxy8kD9q9VdXH/sO0/3GHuw2
	 yc8WY9ySTkPnUvbyatpHGl8ZT9TQ0HSL05djB/XvVxxB7siXFRzuP2wG/WpvPs2AKs
	 Ygt9tJXeyBrhkeHGfZOtRhW2GaeWkBeJv8dtsMPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 669/849] exfat: limit log print for IO error
Date: Tue, 11 Nov 2025 09:43:59 +0900
Message-ID: <20251111004552.595998494@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 232cc7f8ab92f..825083634ba2d 100644
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



