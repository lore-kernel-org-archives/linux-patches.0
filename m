Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91A92109;
	Tue, 23 Jan 2024 00:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969557; cv=none; b=kcJBpZd98fPYj3ivuR1SjWHPxhKca+HRzjJrC5SMTm3mvJp4+Tfdj9LjNn/i2uRRHyn64l0FdsG+OhtYyCmEV6kykiWF5tKeIdw1XYrfOagBmJ7ZxUBg3kTQsNbdu1yNI59cmDlEeFxhsyKvLbOiyScVnEI4+9SNOvB2bs33Uck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969557; c=relaxed/simple;
	bh=Ua1CXCaeAmImmosq6S8dCO+mvny0eg/EB1Qzhf25MYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adQZGAnoAuCc3aLeXVwMBKcmLtCU/8Gt/grPJPbvnLGxiT2FVQ9WzusvZu50s+tYU0TvBavImdmNR/DAF2IbnQEEfiEHqvHtLcFkubblPN5Cbxqm8iycL76IMN7Wzw+L5/KGaKpR9BAZT+XqETL7/d6Dh2iCotB1/T9c5VUKis4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLlixcRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLlixcRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FEFC433F1;
	Tue, 23 Jan 2024 00:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969557;
	bh=Ua1CXCaeAmImmosq6S8dCO+mvny0eg/EB1Qzhf25MYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLlixcRufEx109uOeRtng3UAkh53+6RHvvWH1dXZFdkXvS9ANPoLbUjoEteJ0vg91
	 AwJQ4q7rvctZ2qDLSvwmga2fioHTXLtSDpEXhg2sqpRHmKjHB8YAK+YUTAyhvQrWoG
	 6Tc1vR1hKSQm6Odem6eHX/I+wli5I7TzuSWuS1SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 315/641] f2fs: fix to check compress file in f2fs_move_file_range()
Date: Mon, 22 Jan 2024 15:53:39 -0800
Message-ID: <20240122235827.748239303@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit fb9b65340c818875ea86464faf3c744bdce0055c ]

f2fs_move_file_range() doesn't support migrating compressed cluster
data, let's add the missing check condition and return -EOPNOTSUPP
for the case until we support it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e50363583f01..37917c634e22 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2818,6 +2818,11 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ret = -EINVAL;
 	if (pos_in + len > src->i_size || pos_in + len < pos_in)
 		goto out_unlock;
-- 
2.43.0



