Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9DF514749;
	Wed, 30 Sep 2026 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784608; cv=none; b=nCYCd29ZbsVZ5Gu+5g/OqL3stfT4WINXmsb1kBApysiqDzqfKEDfPsNsoqYGDqc6cNwdM5vyJFDoUsChis6KseT43tIQpN0OCxhv3Wdg0s9Ee3ehi/+xKguAPQ6JJALFVimk3VOfnDWohH411XrYoMlOZuYlh9pw2FEVv20svFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784608; c=relaxed/simple;
	bh=ao3FnrvVPbTIo7Ht1vU6k7BuunKH78NlrG9Dv+GTfUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utxYp9OjqcRLiA3F87xAA9ib4jZOoESxyT/UNETHuAZ2S8kIkBPAMb0eh+Ivpzx5p/S8Ole2ZYlvtoKVCqii3lDGsKOSoAhu15V1M6cjyJGkKyCCsSRvD/36cLbjBtw+4dxF7J7F+OpJq5wGPn0L40XHc5f6HaCjqQ5lYwrYpvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ql33o3Pc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ql33o3Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8834F1F000FF;
	Wed, 30 Sep 2026 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784603;
	bh=UeTkoDSXxILK62TUzmqIhp7IvzF03J+E2BIyvPX9JqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ql33o3PcyfYTik8ISk8zCtYr0e8+umCUFz/y6fiFiOso8ckkRehYASEiUBQDfPoxC
	 /epaikBUOdYX19jR+2D6hcQ4s1OVC1kxav+5xdISTtssKb/z9h9dEZgXpuniqgIB0Z
	 I7T6FqU1I0azktWAkgtijt6y4gCv6ksN0hUQggRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/982] f2fs: validate inline dentry name lengths before conversion
Date: Wed, 30 Sep 2026 17:15:51 +0200
Message-ID: <20260930152421.426392926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8e09832a0e692..e2dddced55afb 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -490,6 +490,12 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
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
@@ -510,6 +516,7 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 	return 0;
+
 punch_dentry_pages:
 	truncate_inode_pages(&dir->i_data, 0);
 	f2fs_truncate_blocks(dir, 0, false);
-- 
2.53.0



