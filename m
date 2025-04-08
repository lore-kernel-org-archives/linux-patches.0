Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704BE268FE7;
	Tue,  8 Apr 2025 11:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110748; cv=none; b=mms065pEJzkzWr/wBzGrWcgo8cYUoHe6fvDhtFGRnJ6t1R88A0sUopWTmVq2TOcp27CEcPKXv8NQfZ92jIoX0DI6UtvPSzeUKWLy5fqB4dqqrlDGXit+lcoxE/bEQcRy4paEd2rDcTDhtPosPefMyWn6ho4ZR+0ugAXdlfg16eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110748; c=relaxed/simple;
	bh=DZvcKluCoEXd0Los201Usg/1HYpFgrxboTCF+NqDF7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9IyI+1kbOZrhFA9gjy0QzrGUWQN6LCxcPJ3L9rdr9C8bIPOcrBToX4U7rJHLpQYu5t8U94TX9mrRV4HkFEobT/40leES+xnMOr46YKV531AO/Zvul3+0AEhpJ4FRukSEaVlzMHRXSXeH8AEqf0qfOyoVtTKbcz4JSEanyOUedo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWQC7Xb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWQC7Xb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B1AC4CEEB;
	Tue,  8 Apr 2025 11:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110748;
	bh=DZvcKluCoEXd0Los201Usg/1HYpFgrxboTCF+NqDF7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWQC7Xb4GF5HkbkRTDjUfbkjibnmAIq3VcgbuzZENIDru/8ziP7/KyQL+sy6bRchs
	 FM2T5X4xhiwQamaCLi/KmL044R/DsBIP4jmEHIQwq1yK/ZfCT3GANVzUZDpkqZ0dft
	 OMQ8AIHICW/pzafeILmpQmvqDTswXP+LvFKeSaYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 180/731] ext4: add EXT4_FLAGS_EMERGENCY_RO bit
Date: Tue,  8 Apr 2025 12:41:17 +0200
Message-ID: <20250408104918.464153265@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit f3054e53c2f367bd3cf6535afe9ab13198d2d739 ]

EXT4_FLAGS_EMERGENCY_RO Indicates that the current file system has become
read-only due to some error. Compared to SB_RDONLY, setting it does not
require a lock because we won't clear it, which avoids over-coupling with
vfs freeze. Also, add a helper function ext4_emergency_ro() to check if
the bit is set.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250122114130.229709-3-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8f984530c242 ("ext4: correct behavior under errors=remount-ro mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b3528e4eba180..7f5fd1a433662 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2236,6 +2236,7 @@ enum {
 	EXT4_FLAGS_RESIZING,	/* Avoid superblock update and resize race */
 	EXT4_FLAGS_SHUTDOWN,	/* Prevent access to the file system */
 	EXT4_FLAGS_BDEV_IS_DAX,	/* Current block device support DAX */
+	EXT4_FLAGS_EMERGENCY_RO,/* Emergency read-only due to fs errors */
 };
 
 static inline int ext4_forced_shutdown(struct super_block *sb)
@@ -2243,6 +2244,11 @@ static inline int ext4_forced_shutdown(struct super_block *sb)
 	return test_bit(EXT4_FLAGS_SHUTDOWN, &EXT4_SB(sb)->s_ext4_flags);
 }
 
+static inline int ext4_emergency_ro(struct super_block *sb)
+{
+	return test_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
+}
+
 /*
  * Default values for user and/or group using reserved blocks
  */
-- 
2.39.5



