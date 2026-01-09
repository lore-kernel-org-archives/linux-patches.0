Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719FD35A93B;
	Fri,  9 Jan 2026 12:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960189; cv=none; b=W9P4OMvSa816f3XNEruD6La/uK78n56kU4+0kQbt1t9mSaSbeG3OQOcMNReQRJbVXL2ONSFiQZWOaV3gnGnf0VGs6dkzUTbHAFCtHOMzLOYd7txC89vzHXKVRxVkzsnLWSr0s+Q1sEv2UQQscgld4Wo1sb0gpFXSoksMuEIl1vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960189; c=relaxed/simple;
	bh=so+CwicG8gLN0wFF0RK15lJ4yYOvBSndTWxHZLfW/gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8m53QLRzETNNnCS82mam9kXlAGDGOczgtIrCmPKwPXp8JGi6oUYGLsRfmCK4PJpxZIGlpa8XDKfalHN25KpnYaSvwvNMlLrxvLy+1HXWQtMi9NIUZdWElwgnvlcODqvGVsft/hCH+8hVCV4QZgYUi7JfDoUXHrVH8FHjnV/GAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbEXtyXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbEXtyXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DAAC4CEF1;
	Fri,  9 Jan 2026 12:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960189;
	bh=so+CwicG8gLN0wFF0RK15lJ4yYOvBSndTWxHZLfW/gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbEXtyXWmz3TwHJR/cNSZVmWHfyA2+De55fTQ4kqjYQMOUM/nsJXwJgcLv73O+897
	 r/deI4sZ0IDzxsFp0ecVnoAv3g/zetj+2KHy6BrC3c0y77plm76M/1FBjeHiS3grWC
	 6QaruB31f1DPKT7UyZ6XOR5TS1JtUKX5Vg9IFA1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/737] fs/ntfs3: Support timestamps prior to epoch
Date: Fri,  9 Jan 2026 12:37:34 +0100
Message-ID: <20260109112145.850860996@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 5180138604323895b5c291eca6aa7c20be494ade ]

Before it used an unsigned 64-bit type, which prevented proper handling
of timestamps earlier than 1970-01-01. Switch to a signed 64-bit type to
support pre-epoch timestamps. The issue was caught by xfstests.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs_fs.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 72810d8f62ee9..31f57ee9a1a9b 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -990,11 +990,12 @@ static inline __le64 kernel2nt(const struct timespec64 *ts)
  */
 static inline void nt2kernel(const __le64 tm, struct timespec64 *ts)
 {
-	u64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;
+	s32 t32;
+	/* use signed 64 bit to support timestamps prior to epoch. xfstest 258. */
+	s64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;
 
-	// WARNING: do_div changes its first argument(!)
-	ts->tv_nsec = do_div(t, _100ns2seconds) * 100;
-	ts->tv_sec = t;
+	ts->tv_sec = div_s64_rem(t, _100ns2seconds, &t32);
+	ts->tv_nsec = t32 * 100;
 }
 
 static inline struct ntfs_sb_info *ntfs_sb(struct super_block *sb)
-- 
2.51.0



