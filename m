Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DFD2676C0;
	Tue,  8 Apr 2025 11:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110753; cv=none; b=jtttf4g70nuAVfacwo8ego0wl0hjWlUQHiZDgdK5ffcRJuRswY0ubBUOwgcLA6BT31zI0dIZ63xccC5Q+ecijmfwc5p1ltVfY9ElZgFLQHHIujlYGZAdg1IdSmCioaqrVIfcvssN06IRqXNQa01Elw36bEK4ckb+3fkfBBsnFwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110753; c=relaxed/simple;
	bh=AQLrFiohK7uqvlv5h+LDK7K8me5SlqCOP6hqSNCSw5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWO7YU+i3rCcPU+fjXF62GqYIF9arIKRp6J1mkLUn4KI0HLnIaS+pMfCLoGXXzb9EtocIP0Z0q3PRbNxatLwC0XUceQhT2k2jQTr6IABeQQnh7q0jaQyOtb9cx7aEILa7hfchYyvCkfIcD3VXqVxqGxTKVO1i3RNHxdeu540lGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGCEfejK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGCEfejK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B468C4CEE5;
	Tue,  8 Apr 2025 11:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110753;
	bh=AQLrFiohK7uqvlv5h+LDK7K8me5SlqCOP6hqSNCSw5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGCEfejKdK/MfLf9I1RyDIVtEndKggjCrVwBC7yrgAaml7LW7KMrs/2AC1QuqE7Ll
	 EYvW9f8kBb2DhxRPU7HLSEty3c/XZwqXOz6/oJvGCNXgghRV5RPiaaC7rERi7Vda/3
	 iP8Eqz+nOm+tY6ohaR6kA12PluWqjl3r6gc1Dx94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 182/731] ext4: show emergency_ro when EXT4_FLAGS_EMERGENCY_RO is set
Date: Tue,  8 Apr 2025 12:41:19 +0200
Message-ID: <20250408104918.512000537@linuxfoundation.org>
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

[ Upstream commit 6b76715d5e41fc332b0b879e66fad6ef3db07a3f ]

After commit d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
errors") in v6.12-rc1, the 'errors=remount-ro' mode no longer sets
SB_RDONLY on errors, which results in us seeing the filesystem is still
in rw state after errors.

Therefore, after setting EXT4_FLAGS_EMERGENCY_RO, display the emergency_ro
option so that users can query whether the current file system has become
emergency read-only due to errors through commands such as 'mount' or
'cat /proc/fs/ext4/sdx/options'.

Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250122114130.229709-7-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0ff0c3d0a3c08..0d1c3eefe438a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3035,6 +3035,9 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 	if (nodefs && !test_opt(sb, NO_PREFETCH_BLOCK_BITMAPS))
 		SEQ_OPTS_PUTS("prefetch_block_bitmaps");
 
+	if (ext4_emergency_ro(sb))
+		SEQ_OPTS_PUTS("emergency_ro");
+
 	ext4_show_quota_options(seq, sb);
 	return 0;
 }
-- 
2.39.5



