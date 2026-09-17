Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0238E4ED1A0;
	Thu, 17 Sep 2026 18:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668200; cv=none; b=eS2qVGd9SjCwzc6jt6UJshiO5wy554gt1Ytxnn0ZXM3+b9zkVFZazCleeA9OrVH2O0LwspcfnF7UbFvPagD0c3J9KMp3BzKqUuEuG58sBUrLmmlGVmaCryZdYRjS/7gJr8BYXgpHLX6KqugoCirFPtWLUaO2Ob5YzpS5HojlRp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668200; c=relaxed/simple;
	bh=CFFnbQkBMV1/j2tbZE3flkpKPG+oM8hw8D8NwJhNNOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD+C6uGq6y5qhLi604HIr/EYJdV5ya25re21lBPDQ+2DQFfR1dggBs8vaBc5t2HwDTIs/SM4o+iRwH5ByEqvMu0JZQzgq0m6T/qrbFVs67+W+vrOT0KJd96Qt9aAM7CyJlIhvWizVOLejrZJxnU5O1ErWhjrrLTx/SJYVTS3gI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suza83Ki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suza83Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593051F000FF;
	Thu, 17 Sep 2026 18:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668198;
	bh=FfYGx057O7tIZfGg4nuo4HZyLcj9weYhviLm6TGyQ4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suza83KiKWTFuSvcl5e7+7/WtwIc6RJjv4ETkcCz2qt2ggYLvJNDKmJSr426ozgek
	 PZj46MjvJ9/vtfz1/Ou73cpuVuQMc0QMxhmyZ/nbFn1EHYb4a7pM9wyi/S6Vjs9dwt
	 0FlwbwjZQ5KM/uKYFZ6Ljhmbvd3UcpMghVNVH1w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0346/1102] f2fs: validate inline dentry name lengths before conversion
Date: Thu, 17 Sep 2026 16:04:49 +0100
Message-ID: <20260917151548.327100384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit cfcd0e49a178b3dac2c0ece656079081dbf5da74 ]

Inline dentry conversion copies names out of the inline dentry area
before checking that each recorded name length fits in the available
filename slots.

A corrupted image can therefore make the conversion path read past
the inline filename storage while building the regular dentry block.

Validate each inline dentry name length against the inline filename
area before copying it.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <samuel.moelius@trailofbits.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 758ec6d3ae841..b87a88c2e3c86 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -506,6 +506,12 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 			bit_pos++;
 			continue;
 		}
+		if (unlikely(le16_to_cpu(de->name_len) > F2FS_NAME_LEN ||
+			     bit_pos + GET_DENTRY_SLOTS(le16_to_cpu(de->name_len)) >
+			     d.max)) {
+			err = -EFSCORRUPTED;
+			goto punch_dentry_pages;
+		}
 
 		/*
 		 * We only need the disk_name and hash to move the dentry.
@@ -526,6 +532,7 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 	return 0;
+
 punch_dentry_pages:
 	truncate_inode_pages(&dir->i_data, 0);
 	f2fs_truncate_blocks(dir, 0, false);
-- 
2.53.0



