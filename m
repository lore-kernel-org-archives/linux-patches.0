Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8711836E2;
	Sun,  1 Sep 2024 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207695; cv=none; b=DHtbhglupH6zVr8Fv0fClY5CvEIHYI+PpSsmf1DT3ejrAeIy0eYot01BVIeYTmI4AbCE/rkcNWwHQHMm7vTSM01yQh5nUzpRmAjhbNfNYARTYh+OTapeHXejVUerGy0dQl26t0+IOWbD4dj0di5zJGRvCSw/7Jw2c7gY0BxSoMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207695; c=relaxed/simple;
	bh=5U1SMmzPGnJlXzpzvr6EpU4keEXHtrbe8S8VX9ZTfQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNXe5zN9N8MhdMEPbo7ib2ORHCLtomV11PcCBqB+v/kH51Ohpfi7CUkuMfzbQaT0IPNymb7tzNoMN90fPmBdozwiBRn2BpiwCBp+EKBYBb//UlCuWbDI50leUDpuBrog1m81J7bO0MqVmL+14dI6+CULjHn1i6/KBFQsdDlWZOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2j7GMwNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j7GMwNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABC7C4CEC3;
	Sun,  1 Sep 2024 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207694;
	bh=5U1SMmzPGnJlXzpzvr6EpU4keEXHtrbe8S8VX9ZTfQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2j7GMwNsLLyfWgeXc8dMOVTScwcd/90T0etgxWd68HdC5hFLZWEuyw6ibU+yE7D1t
	 1YIipRi7RHaXFGDaZsURAkIbkkjeghtS0hEVV7qRfoOKCvAUC52cnYCpiMqa5BrUs7
	 gv4ihvfGN/ARkFi5OaYUCneBmx/SNUDNwXvSIyn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/98] ext4: set the type of max_zeroout to unsigned int to avoid overflow
Date: Sun,  1 Sep 2024 18:16:19 +0200
Message-ID: <20240901160805.550075135@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d931252b7d0d1..d162cc0590533 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3445,9 +3445,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_extent *ex, *abut_ex;
 	ext4_lblk_t ee_block, eof_block;
 	unsigned int ee_len, depth, map_len = map->m_len;
-	int allocated = 0, max_zeroout = 0;
 	int err = 0;
 	int split_flag = EXT4_EXT_DATA_VALID2;
+	int allocated = 0;
+	unsigned int max_zeroout = 0;
 
 	ext_debug("ext4_ext_convert_to_initialized: inode %lu, logical"
 		"block %llu, max_blocks %u\n", inode->i_ino,
-- 
2.43.0



