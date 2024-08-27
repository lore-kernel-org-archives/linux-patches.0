Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310A1C5792;
	Tue, 27 Aug 2024 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772254; cv=none; b=mo22tzTW3Kh9DfRJR9NzhqKDgNDyk84I2JCxldEt9j8/rOB5WgYGgRQrDyVLXKywGocNANI2bSj0JPbyOhvU6BQvEKi7FkgQ4sCL9VQ+4C50qqDUtrGBXtIxZh7nbQzp7lGMWLxgHcAri9hJDmLHaEma1BqQpv99zR5IEN+W+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772254; c=relaxed/simple;
	bh=Bp3lMuKaweEgA8OCc0Ki8L4PeLPiFKNtHJrg0HOQrEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGj1yd4G0YzPwqi4mPY8bhgHVBsC2iQtInJtaXzbpsFZGdLSIgfU4LsDsW+sIfFjXAo9qovYEz9xCVCfWo2u/8krXn/MCvpcHluj15+3pzy8octJd89SmlJuSkfvxKmdiH2ZofckotPD7dm7Dbv9upRuizXd5I9P8hsQ9hy7Gck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQx0haCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQx0haCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB4DC61069;
	Tue, 27 Aug 2024 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772254;
	bh=Bp3lMuKaweEgA8OCc0Ki8L4PeLPiFKNtHJrg0HOQrEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQx0haCNHKQ6/noo13Ji4V5vjOupSuggWCoCxOWwB52DXWH1AosMRyVBEDd/fdSdf
	 +Q7l4CmTNtIfTfx1fS/k+/MOMAcIxq2WZ+Q3w3yhFh4vQsJpjJAiKnrxY48mF0WQ23
	 YZt1L2SnLqtTvfy582Rp3yhKi00r4+p3poZQs2XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/321] ext4: do not trim the group with corrupted block bitmap
Date: Tue, 27 Aug 2024 16:37:47 +0200
Message-ID: <20240827143844.283686736@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 004ad321a45d6..c723ee3e49959 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6483,6 +6483,9 @@ __releases(ext4_group_lock_ptr(sb, e4b->bd_group))
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



