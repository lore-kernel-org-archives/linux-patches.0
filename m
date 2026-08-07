Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F246C4AD;
	Fri,  7 Aug 2026 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116618; cv=none; b=ltDOk7vO4Q+Qm70IOyv2Evgh6/M1hl1S4QIEvg06lFVBTvwOyllSo7gq2T+fV+UtWFjl0xaQ/vtTebv7mQImCskJ/jAY36nIydE3qp60cIXwOoMCBSczHD+ULadnbx8Vk72pRkLvyCj8MV2ay1l7XaNonWg3G14ZwTJAdfTO6xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116618; c=relaxed/simple;
	bh=vstINQE4znyG3NvikBpOetupI2Tjw82EXg0z/KK+lxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+ZKpNNhpG6+Zs9EoTgD3Yd2eR6Xdo+75YXMQf2GLfHGUF7AaaT5/IOlhKs1VAzB6g0sNupoxfOI06LX6iCfu4/mELFOEbIgdobdER/0cSErI5glPB482d17eEJa7xxE2j3FLjuqW4TD0+d61VeV12UyOY2zJhbgTwarbuHSVoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YR0PMnXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YR0PMnXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4EB1F000E9;
	Fri,  7 Aug 2026 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116617;
	bh=dKOCJsDrwyeDXmHr3v9WrXkPlwvanef+jlvgVwFMPJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YR0PMnXNDc6hgRCuS0H07jSGL+PXkQD+E0J7dPFawVid0lSihhGMJzRnDA/C4Ck7Q
	 HXSRZvgDKUzScdKXNCCmGDMfhZqt5GAvuGFGGM/jfGNrutPmiVwVvl7Xx5UgKiSny6
	 dyPNuV1HNAHGaXVHungOS1u0zrClic4/qk7SHwF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Mudar <kommandant_alper@proton.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 032/438] ntfs: harden runlist realloc size calculations
Date: Fri,  7 Aug 2026 16:33:48 +0200
Message-ID: <20260807143428.694183470@linuxfoundation.org>
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

[ Upstream commit 8bed376124ab4505b70083a2b91f2c7ef6d51e24 ]

Add a shared helper to safely convert runlist element counts to byte sizes
using overflow checks, and use it in both ntfs_rl_realloc() and
ntfs_rl_realloc_nofail().

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Co-developed-by: Alper Mudar <kommandant_alper@proton.me>
Signed-off-by: Alper Mudar <kommandant_alper@proton.me>
Tested-by: Alper Mudar <kommandant_alper@proton.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/runlist.c | 50 +++++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index 15f1ae530ae13..8d2740cfddd73 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -71,29 +71,46 @@ static inline void ntfs_rl_mc(struct runlist_element *dstbase, int dst,
  * On success, return a pointer to the newly allocated, or recycled, memory.
  * On error, return -errno.
  */
-struct runlist_element *ntfs_rl_realloc(struct runlist_element *rl,
-		int old_size, int new_size)
+static inline struct runlist_element *ntfs_rl_realloc_gfp(struct runlist_element *rl,
+		int old_size, int new_size, gfp_t gfp)
 {
 	struct runlist_element *new_rl;
+	size_t new_bytes;
+
+	if (old_size < 0 || new_size < 0)
+		return ERR_PTR(-EINVAL);
 
-	old_size = old_size * sizeof(*rl);
-	new_size = new_size * sizeof(*rl);
 	if (old_size == new_size)
 		return rl;
 
-	new_rl = kvzalloc(new_size, GFP_NOFS);
+	if (check_mul_overflow(new_size, sizeof(*rl), &new_bytes))
+		return ERR_PTR(-EINVAL);
+
+	new_rl = kvzalloc(new_bytes, gfp);
 	if (unlikely(!new_rl))
 		return ERR_PTR(-ENOMEM);
 
 	if (likely(rl != NULL)) {
-		if (unlikely(old_size > new_size))
-			old_size = new_size;
-		memcpy(new_rl, rl, old_size);
+		size_t old_bytes;
+
+		if (check_mul_overflow(old_size, sizeof(*rl), &old_bytes)) {
+			kvfree(new_rl);
+			return ERR_PTR(-EINVAL);
+		}
+		if (unlikely(old_bytes > new_bytes))
+			old_bytes = new_bytes;
+		memcpy(new_rl, rl, old_bytes);
 		kvfree(rl);
 	}
 	return new_rl;
 }
 
+struct runlist_element *ntfs_rl_realloc(struct runlist_element *rl,
+		int old_size, int new_size)
+{
+	return ntfs_rl_realloc_gfp(rl, old_size, new_size, GFP_NOFS);
+}
+
 /*
  * ntfs_rl_realloc_nofail - Reallocate memory for runlists
  * @rl:		original runlist
@@ -118,21 +135,8 @@ struct runlist_element *ntfs_rl_realloc(struct runlist_element *rl,
 static inline struct runlist_element *ntfs_rl_realloc_nofail(struct runlist_element *rl,
 		int old_size, int new_size)
 {
-	struct runlist_element *new_rl;
-
-	old_size = old_size * sizeof(*rl);
-	new_size = new_size * sizeof(*rl);
-	if (old_size == new_size)
-		return rl;
-
-	new_rl = kvmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
-	if (likely(rl != NULL)) {
-		if (unlikely(old_size > new_size))
-			old_size = new_size;
-		memcpy(new_rl, rl, old_size);
-		kvfree(rl);
-	}
-	return new_rl;
+	return ntfs_rl_realloc_gfp(rl, old_size, new_size,
+			GFP_NOFS | __GFP_NOFAIL);
 }
 
 /*
-- 
2.53.0



