Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80E34DDB2B;
	Wed, 30 Sep 2026 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791064; cv=none; b=eHHyRDNZIXaxz+9dklOrZvrEiEuN1vFWmPfnxAPqPEPHS8SIEvKys9mnQ9vuE+pa/pJ14G+ys/c9ltWj/S61mRkOdvn5NbiDuUVLSxVl4UeP6cGKMyncagAmHKBN9CAay8CUmZdhecH1h6Qrs0HcSs5gYT3Z3O25sjGSwFWeI0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791064; c=relaxed/simple;
	bh=PxHdcoqi6CzdiBgsm1ipgD2kCoJ5uBsO1EVaBWaSGX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN+6t5GCCx19qcRWk+E+llHxCnMQHOSGTlIS0pBy9r2Gg7mMuySLcDbmKM9t6AMyjtI35SkPOurle3HF2eFSzUXNRWnHtVl0LKVMsFMxVHhcjvlVHa92L3VK/mh/ejxgluShQb5UjjD40uzI2zycviPxKQYqHVsyJvkDVF2CThE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n63IaAs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n63IaAs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E8E1F000FF;
	Wed, 30 Sep 2026 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791062;
	bh=vxf7oasvgHLLQJsZRuNiHu+eKRk28IwZoDVwegVdYVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n63IaAs71FYGPc+otoJSwg9u2UOUkW6CW4Ggi94MzoV8MhCET44D4yNlENbv2U7GA
	 czRVQOrbkYmO4QjHTAhfEKeuLmnt+5JU4MWmYdxHgNDyp5AtAf0Kmjb9advCtmpdiC
	 +ajik+/g0mH235kWCeHehQmdH6P/D61JsXSoTI0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/752] f2fs: validate inline dentry name lengths before conversion
Date: Wed, 30 Sep 2026 17:20:39 +0200
Message-ID: <20260930152401.859692612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0efb4a02ea9d..de17e93cdc3e9 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -488,6 +488,12 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
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
@@ -508,6 +514,7 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 	return 0;
+
 punch_dentry_pages:
 	truncate_inode_pages(&dir->i_data, 0);
 	f2fs_truncate_blocks(dir, 0, false);
-- 
2.53.0



