Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7617017CA1F;
	Sun,  1 Sep 2024 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208801; cv=none; b=elK/dbfwAGpNNSYFf3ciQvLy1OM6jSFy3kwOPJk0wBI7OtgU/XbqBWSI21L8FBdR3gmFqDm2FfgUxVPKYvyazLFIcYBzz3E5bd7gX8rO46TUahWFRXYL4HWGa9B4F0tbRoDzUevKtDyMIIAyw9WeV7N5aartxuk+ai4eDlTQY2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208801; c=relaxed/simple;
	bh=GIWAkQh48s0DqtXV086qIrmt4+aHMokbbdnkesBK3sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFmcpwy1xMAK81l4VTC6wIQ1dGd+maecITD8ZzcDgADeeydbj7/uPDDztMvctS0Q+srx7HtwbXNLlQzlPRbN/oRtWxRAbneH8LnsoquVy7iVBJxoN3nHA+fQFP6LesoAxgmHuOjsPhtMBbd0Mw2EtLm+VfSMuh9vGb2EuqrKhOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQL58L49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQL58L49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0495C4CEC3;
	Sun,  1 Sep 2024 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208801;
	bh=GIWAkQh48s0DqtXV086qIrmt4+aHMokbbdnkesBK3sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQL58L49geq8wB+ABEK3en8aNdn8ERfPrCmH3j673bmGq7I+7ymbT7Kh8FPJD5TAn
	 tE7rFQXLXwQVm2uyxtRS5zyb1hVQfLlTtosm8OeCghXtnlYll1OQF/fN2CDI9pf5iR
	 GxOJLfXess20yG3yYaP0B6m6swqB0IWpnygdKbxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/134] ext4: do not trim the group with corrupted block bitmap
Date: Sun,  1 Sep 2024 18:16:29 +0200
Message-ID: <20240901160811.729818450@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 172202152a125955367393956acf5f4ffd092e0d ]

Otherwise operating on an incorrupted block bitmap can lead to all sorts
of unknown problems.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9bc590564ea1f..b268dc0e1df44 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5227,6 +5227,9 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 	bool set_trimmed = false;
 	void *bitmap;
 
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		return 0;
+
 	last = ext4_last_grp_cluster(sb, e4b->bd_group);
 	bitmap = e4b->bd_bitmap;
 	if (start == 0 && max >= last)
-- 
2.43.0



