Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5809053A3B0;
	Thu, 17 Sep 2026 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664676; cv=none; b=JAmcBDbsFnlv5Ge12RNH/E37aEaBvQM2q48M/8UdLAr6H+C9MY0iEL6RBlghQ/eMLge80m9Ssc76D9TwlxmsgR7a6d9suxRH2a+MH4ld4SE46rWpbgc4npor1Jq7vWvrbZFjCLjmqkrNe/crf2Jculh+p4ZZ1iRG7U7vlER7jcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664676; c=relaxed/simple;
	bh=N0aRPt+3cf2mCyF0mGFgzlQaIxzCFKOgBpJO4q6IhxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDe1LjOizL3b6IA67kyjOEFCz0wNfYPKZ/XgOuH4dmBmb0UHw2lHUeD4NVS4j66blDVWwiMEE3YuJXYMqoLIBFIr6gRquXBoTRPTuAAwEdAhvGpwTE/Wg/YDJXUEVxQ5ElplIMlsGwZRnXOGqnk9l59ehBSSO4aSiQBRQxQttvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1p33vPb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1p33vPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2191F000FF;
	Thu, 17 Sep 2026 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664675;
	bh=tWa0a8tx4SAB+YK31A9v6hrvvxRz9OA91GXDHpc8h8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1p33vPbBFr28wajv54bex3MgOu86BhXv+i6mJIfy2n8HSTym9Lr9wJaJAlFeYGU6
	 3aOq6od6voMKjENLKuqmnJE2ZFLh1vC1yEJ9ij6PrqKfuaQkoT/KP/rKdDqfEl0QD6
	 i8QOXZgcdXU0f3m9rOISV7Os3Qt4Ii9btRMCL+4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0451/1250] f2fs: validate inline dentry name lengths before conversion
Date: Thu, 17 Sep 2026 16:04:06 +0100
Message-ID: <20260917151604.218061227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 486f0b4ce9a17..55dbbbfe738f5 100644
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



