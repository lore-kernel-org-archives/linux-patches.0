Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEC533F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301189; cv=none; b=i3HmFxzfBYvdOxZl6NIdfXW97S36y9Yu2UIG879h58B8KcctU+7+TY6NfkFXp5vgDgKXEy+iY7/OEVKd4Z2GpM8+acOmf/rnIJ/aXDWoqB10KHlCNmWDykuDU+JsmtYclXClG61pht5ekj2z5bfOqPzBPsbUO0EbYwTYadc1/Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301189; c=relaxed/simple;
	bh=JDedQdr+8yaAWoZz/IMw+sWnA2zqUVdG0nqQvdXGazM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXnFvlnzimAZqdAslM1ZwF1UuihWvHEEa1ISbiO4DEBtfbP/L+RVY1M9j0GJRocagzNrL8zWpjoUvwrKXQeY/uTdWUW4GfCaisP2tXdvTvSm/r8Vz3BAT0hPQIsGURsKam2+kFSZ1IT6BwN322TW57OZTANYYHwotT3SWGWpRUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYZCwqaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYZCwqaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B2CC2BC9E;
	Sat, 28 Feb 2026 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301189;
	bh=JDedQdr+8yaAWoZz/IMw+sWnA2zqUVdG0nqQvdXGazM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYZCwqaKq71Hg5v5AHi3n1fffmyHbrde07DzLyiMqrOjuGLApr+tFlJcE5eEq0gK3
	 OWYkJXYwrrEVO5yS5fLRlZup8PLmkDKnrzAboG+lf0VZUNzCKReQrCVhlb6hYvCpQf
	 nz2bLPUbx62xNxGZNBIsR4VHutXhpfquEWqFCLQ4cRyO5uYt1d0Y9BToPw49N9mVca
	 0w5tNMEDvdBwdDgiuIknAzTL+Z93nWZr/dnkY2ZeDEAJ9NXGlcp/HF3wiM9q0fLTIr
	 +H+v164SEWZ8R+d1eZ3Q8M+7yNiKk0/hDvE4g7RZ5KT4xt42ylcny84GGxlc2YII56
	 5jB3IV2M8pFjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jaehun Gou <p22gone@gmail.com>,
	Seunghun Han <kkamagui@gmail.com>,
	Jihoon Kwon <kjh010315@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 359/752] fs: ntfs3: fix infinite loop in attr_load_runs_range on inconsistent metadata
Date: Sat, 28 Feb 2026 12:41:10 -0500
Message-ID: <20260228174750.1542406-359-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jaehun Gou <p22gone@gmail.com>

[ Upstream commit 4b90f16e4bb5607fb35e7802eb67874038da4640 ]

We found an infinite loop bug in the ntfs3 file system that can lead to a
Denial-of-Service (DoS) condition.

A malformed NTFS image can cause an infinite loop when an attribute header
indicates an empty run list, while directory entries reference it as
containing actual data. In NTFS, setting evcn=-1 with svcn=0 is a valid way
to represent an empty run list, and run_unpack() correctly handles this by
checking if evcn + 1 equals svcn and returning early without parsing any run
data. However, this creates a problem when there is metadata inconsistency,
where the attribute header claims to be empty (evcn=-1) but the caller
expects to read actual data. When run_unpack() immediately returns success
upon seeing this condition, it leaves the runs_tree uninitialized with
run->runs as a NULL. The calling function attr_load_runs_range() assumes
that a successful return means that the runs were loaded and sets clen to 0,
expecting the next run_lookup_entry() call to succeed. Because runs_tree
remains uninitialized, run_lookup_entry() continues to fail, and the loop
increments vcn by zero (vcn += 0), leading to an infinite loop.

This patch adds a retry counter to detect when run_lookup_entry() fails
consecutively after attr_load_runs_vcn(). If the run is still not found on
the second attempt, it indicates corrupted metadata and returns -EINVAL,
preventing the Denial-of-Service (DoS) vulnerability.

Co-developed-by: Seunghun Han <kkamagui@gmail.com>
Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Co-developed-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jaehun Gou <p22gone@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index eced9013a8818..f0ff85b7d76dc 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1354,19 +1354,28 @@ int attr_load_runs_range(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	CLST vcn;
 	CLST vcn_last = (to - 1) >> cluster_bits;
 	CLST lcn, clen;
-	int err;
+	int err = 0;
+	int retry = 0;
 
 	for (vcn = from >> cluster_bits; vcn <= vcn_last; vcn += clen) {
 		if (!run_lookup_entry(run, vcn, &lcn, &clen, NULL)) {
+			if (retry != 0) { /* Next run_lookup_entry(vcn) also failed. */
+				err = -EINVAL;
+				break;
+			}
 			err = attr_load_runs_vcn(ni, type, name, name_len, run,
 						 vcn);
 			if (err)
-				return err;
+				break;
+
 			clen = 0; /* Next run_lookup_entry(vcn) must be success. */
+			retry++;
 		}
+		else
+			retry = 0;
 	}
 
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_NTFS3_LZX_XPRESS
-- 
2.51.0

