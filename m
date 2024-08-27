Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9B1C57BF;
	Tue, 27 Aug 2024 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770376; cv=none; b=sWgM89Of5rtUsMLpmcnvE9OHzEAh0N5sYFWl4ynqcpSvqMdXhVUk/ZDBc+p1IKQpwXai7Gr/MJ9B1/jmBDmHHP5fDMDAW3zPp6W8c8BoT6Vx1eeHSE8+vPSGAckSmvDjtjNPB4i6jkIqVOM5Y5yv4kNo6AovR9MuOPG37DXzX64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770376; c=relaxed/simple;
	bh=6WTD6ODEuyYfrYcSP6FWBw013N/ua5sgminz1eyBLIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVq15kgpUccT5LnP57YlvzZNYmzBo3C/2Xh2p8MhTf3M3xjAGWZ/RnvALR/ri0sfDpvXXFlAhbVZ+eC90s7jZsI3O5zqa9nEnqqbMLnifFU5gujeYgDdd5n3EnSAAKGXfEV4bRgOZNfDEIs7akK88NsAC6SusUl9JEpT9i9H2jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frR3xl2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frR3xl2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC7C61049;
	Tue, 27 Aug 2024 14:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770376;
	bh=6WTD6ODEuyYfrYcSP6FWBw013N/ua5sgminz1eyBLIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frR3xl2KtfcH75771F5VLIn4GYWsdCNa5ThMV64kuDZW5ORZBNA9vx+F4Nxtf5i+M
	 mgj3v8/F5yoURI8Kt2oMlFmgPWkB8tp4+YP/1xI142zAQPp3vLPIjhZ1n8fpPb/SQw
	 u1zlHJ+nwofuQNdekdFPihlaAXHYcnExRpdaAt+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/341] ext4: set the type of max_zeroout to unsigned int to avoid overflow
Date: Tue, 27 Aug 2024 16:37:21 +0200
Message-ID: <20240827143851.404221587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 261341a932d9244cbcd372a3659428c8723e5a49 ]

The max_zeroout is of type int and the s_extent_max_zeroout_kb is of
type uint, and the s_extent_max_zeroout_kb can be freely modified via
the sysfs interface. When the block size is 1024, max_zeroout may
overflow, so declare it as unsigned int to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240319113325.3110393-9-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d393df22431a0..448e0ea49b31d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3402,9 +3402,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_extent *ex, *abut_ex;
 	ext4_lblk_t ee_block, eof_block;
 	unsigned int ee_len, depth, map_len = map->m_len;
-	int allocated = 0, max_zeroout = 0;
 	int err = 0;
 	int split_flag = EXT4_EXT_DATA_VALID2;
+	int allocated = 0;
+	unsigned int max_zeroout = 0;
 
 	ext_debug(inode, "logical block %llu, max_blocks %u\n",
 		  (unsigned long long)map->m_lblk, map_len);
-- 
2.43.0



