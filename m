Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0AF309EF2;
	Wed, 30 Sep 2026 18:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794550; cv=none; b=nvtsiT9vwPdIaF8HB1Ijdv+CfzprmJWSX7haOdXgrjeQIpFl6XUSQ+uSbM+5L8qHTcQGe50+j/VGQda3cI1kJHpt/Ji60KhOrm6bvgkFzHb5UDPL9trhje088uiVSrlz8Qp0eVwKyjbMO2nsadD0TJ2yvBm6go38HyNFF5iVY10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794550; c=relaxed/simple;
	bh=YyF3Ruri83s9+WGJZFGP8/M98f1Eev/ruJ9WH1xFhOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+/mPKD7LRTL1fR0kykEO/hqLEigzKF6aHAkKlxo6ScWbNKOUh2ToAUwRi1OLRoqAkXO0v/aYZeCoUjHZP76rRxvl5FolazMwLORsxkpwiHQ6Sm5tOy3/i5N9+kaye6WW9qK8PPk0LTK6IkVUevFq5tz71iZWC0vcqvjhdsFO7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmPpdkLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmPpdkLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96C31F000FF;
	Wed, 30 Sep 2026 18:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794549;
	bh=ckq3s+8ZAmdS7/EbvcKKEXn0rgNq5vf1r8sNMt4eB0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmPpdkLMaqZCYb6l0tJ2k0wXiaZZxprrVLBc4Qu4Cc+5lxsZ0n+pdatocYKDyO0EH
	 LPg5C2SrEUFpWIeTs6++i2nQ8NcMgM9MvuQ06yGgJcSN4+gyYPU+xMzUHIQCjlH9Sg
	 XJC+6A57iWxa4SP8NMlLTaljcpsNy8pJBZbxRexg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0250/1193] f2fs: validate inline dentry name lengths before conversion
Date: Wed, 30 Sep 2026 17:15:34 +0200
Message-ID: <20260930152439.739863632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 92bbdb272a6d9..0d81bd25c6620 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -507,6 +507,12 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
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
@@ -527,6 +533,7 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 	return 0;
+
 punch_dentry_pages:
 	truncate_inode_pages(&dir->i_data, 0);
 	f2fs_truncate_blocks(dir, 0, false);
-- 
2.53.0



