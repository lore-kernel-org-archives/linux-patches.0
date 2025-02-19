Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9151CC8B0;
	Wed, 19 Feb 2025 08:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955573; cv=none; b=NkOuqAA93in8uVf1rCvpi+Wet0izY8q4+RO+SYPsjpWnIbWGT7yVSfiMoRI2KdLJkdxoRS2NrnBSEIHkFTEfiHzoEeyDAvkIk6UYVOpFH50CiM6aBgUOgqnrmtN6ZkpVFsVKQ6tPrELNUKli8eY45yeBeFL22tW0BqrfUxPpLxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955573; c=relaxed/simple;
	bh=Puu1Yx6EuPH9A99UP3quQiiU9goZ1tYCjzhnrgwr/hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeuNrzJ02B8fubx5oRnX1AGyAq0qiTLJ21qTcf3ncz1GCc4zN6WkMw451z7P/wyt08KkjM3RZWdriwlwErX/yt1qT3qYRoN25klAu3NMWyhONhjALDriwTQDdR5p2Oc2kKpVp8VOPjfvvi/XQo/W3L5Ra11p9IGXC/7Usc7t4a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYu4giIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYu4giIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97E4C4CEE6;
	Wed, 19 Feb 2025 08:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955573;
	bh=Puu1Yx6EuPH9A99UP3quQiiU9goZ1tYCjzhnrgwr/hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYu4giIRTj010PmgkGDsd26Q4LLEAdFzkP2YWrSsvab+f9bj18n/18zEM7YLTv1Oh
	 6elJZq19fE1b+lUTuA/56p9E/CRse0HehSEclj1ecxgpx74q4bmmZnbciSBToV9atX
	 pYyv2/JRPHuaWh4O5kmUJkrWJJcHPiVbk0HGGB5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/152] orangefs: fix a oob in orangefs_debug_write
Date: Wed, 19 Feb 2025 09:27:40 +0100
Message-ID: <20250219082551.907576146@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit f7c848431632598ff9bce57a659db6af60d75b39 ]

I got a syzbot report: slab-out-of-bounds Read in
orangefs_debug_write... several people suggested fixes,
I tested Al Viro's suggestion and made this patch.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 1b508f5433846..fa41db0884880 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -393,9 +393,9 @@ static ssize_t orangefs_debug_write(struct file *file,
 	 * Thwart users who try to jamb a ridiculous number
 	 * of bytes into the debug file...
 	 */
-	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN + 1) {
+	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN) {
 		silly = count;
-		count = ORANGEFS_MAX_DEBUG_STRING_LEN + 1;
+		count = ORANGEFS_MAX_DEBUG_STRING_LEN;
 	}
 
 	buf = kzalloc(ORANGEFS_MAX_DEBUG_STRING_LEN, GFP_KERNEL);
-- 
2.39.5



