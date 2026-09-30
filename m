Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655CB501F59;
	Wed, 30 Sep 2026 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782715; cv=none; b=irqyTyQ56rsutOYAPOu/LeBWibAf1mOM/rWAAYWshqzDcuX/ibHx/z1NNdo/6TNiuh4TgbkJOcIAuHomw9kvTxVJIbIoGm9PW+68MydXBhzSoN9jUZiYQNX529oSZ557bHw8xT2BGV/O+/URPre0+pIRI93KVyHBkBttKsXlHz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782715; c=relaxed/simple;
	bh=WzjA+7Isa62Aj1aJUO9+1tOQoXOI7XbELoLvLTlJKzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddWQSNKInIZtzQ9dMiSx/srsA2ShZaIdhMvVRpVj6qf6jhTKpjzENdSaiqYH+7CAHrHMcXt5hsj6MqRn1eD1b4mwEIreOABPsN2GIxou4iX+3raH+bGfReiEJV0xMD3l4cZyZaeqeilBYyzcZXVYHG0qZ9PMVOJOcwiuPZ2KYVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxlwG7k2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxlwG7k2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978581F00899;
	Wed, 30 Sep 2026 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782712;
	bh=5FrTE1TXClXxIuU/7Esbwi2DwQAPof6V34BjfffdjU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxlwG7k23p+OTpx8QSroSjzXW6X4BUFR/AfvFWrijW04tyPJnXk3NikUQ7zVOsWZp
	 v/GAplIXhwzuNenizpT79Sio0ZMBtsP2ojW2VYmd1OJSQ0eHZiBjVI7O9ouVmm+0xh
	 C6Ax/tkQE/PadauWSEXzGvtrY7e4D44hXrjNZYP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/595] f2fs: validate inline dentry name lengths before conversion
Date: Wed, 30 Sep 2026 17:20:35 +0200
Message-ID: <20260930152350.787107620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8cd6383be3325..5393190f9d1e1 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -478,6 +478,12 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
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
@@ -498,6 +504,7 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 	return 0;
+
 punch_dentry_pages:
 	truncate_inode_pages(&dir->i_data, 0);
 	f2fs_truncate_blocks(dir, 0, false);
-- 
2.53.0



