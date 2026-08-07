Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559EA33C1AD;
	Fri,  7 Aug 2026 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116738; cv=none; b=CBDGxA1iCV13ebPe2dv+DPsK0IvoK3Q2akwpqRZ9+/SAiNww3jOdWCJU18Yoem2fbJ5CxDt/W1F8IX1m8Yb4vqCqxXinVPkjtXdog/xIKEXs3BwbSInHi4mB7k7F1kVByWu8JB5pRXVnrGMJERnRKh0l1pVY7kgQGgNGs1S2d3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116738; c=relaxed/simple;
	bh=Rp4ITDuwkitu5R6mlzAiU0Eyb//EHNcjykAYUAQlWV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXEANi/B2Ku36qNO9IgWq7Yk8d25BOU6W21HQv4C41rFSPdq28phlkP95pON79dm088bWTBCTANSpFfJLnr5/N4YTMC9BMAtVchdvunsC4Le72Ah0AxEH7fxYl8iEdwatA7T45F+WmcWKDiTAGJvQfPGXH+qTN6ddllSgwWeSYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5qz/6nv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5qz/6nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83D91F000E9;
	Fri,  7 Aug 2026 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116737;
	bh=z4edLT1XVxIOnSxEh8pL3xq3dSU0xpuTrmMGtb/9FfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5qz/6nvrwEeqeVqPdUEu5uVIucLaVf8qvj6yOJj5EvjPFehJNxdTRul/rx+Ba7eL
	 knIwnROQyl8VrB9lLAwNmntw1xEc4gIn7e24mb4gvzD3SBRn1PJbXyw8T/7W96TeFy
	 cPsbC1yn6yiv5V8rvFAdn/VF/+11qxJIhd9cWYZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 018/438] ntfs: preserve RECALL_ON_OPEN on WSL special-file reparse points
Date: Fri,  7 Aug 2026 16:33:34 +0200
Message-ID: <20260807143428.399015236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 523307b8516fc740895238af8473aa0630b3e088 ]

When creating a WSL special file (socket, fifo, character or block
device), __ntfs_create() sets FILE_ATTRIBUTE_RECALL_ON_OPEN in ni->flags
as valid_reparse_data() requires for these tags. This flag is
intentionally absent from $FILE_NAME, so the subsequent reload

        ni->flags = fn->file_attributes;

drops it from ni->flags, the authoritative copy written back to
$STANDARD_INFORMATION. The on-disk file_attributes becomes 0x00000404
instead of 0x00040404, and after a remount valid_reparse_data() rejects
the reparse point while fsck reports "$REPARSE_POINT data is corrupted".

Preserve the RECALL_ON_OPEN bit across the reload. Symlinks do not set
that bit, so they are unaffected.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index a20ef06087368..712c9ccc8b254 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -683,7 +683,8 @@ static struct ntfs_inode *__ntfs_create(struct mnt_idmap *idmap, struct inode *d
 	mutex_unlock(&dir_ni->mrec_lock);
 	mutex_unlock(&ni->mrec_lock);
 
-	ni->flags = fn->file_attributes;
+	ni->flags = fn->file_attributes |
+		    (ni->flags & FILE_ATTRIBUTE_RECALL_ON_OPEN);
 	/* Set the sequence number. */
 	vi->i_generation = ni->seq_no;
 	set_nlink(vi, 1);
-- 
2.53.0



