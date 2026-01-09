Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E6B33C53A;
	Fri,  9 Jan 2026 12:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962075; cv=none; b=eG0nYiK8LwXb9e7N9QGjk35fpHsJJ1C48VvkS9VddprcwJ6hz6f4OQwIrFhNt3i0DZi3QUP748kIcazug+P/aMMTq7sg/Yuygew3PtDbWGuAsxZgfv1LLSFj8zON/9XICMTqwvh0xud+LL7HxW2D/Yc0iLGaWR8RLgcpwpz95eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962075; c=relaxed/simple;
	bh=wIrwfX4mV3KebnyHD694pxaRlxPFC9BcDT2FY0XYgro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftUcgjC4SRpey/hdISxYW8XEnP5z8LUNLSPpVQ/stUCSkl7RYQsS3BxszHFclZZiQvbdPNzQLE5NxPLag3WOnjGRR3ndxbqZNu6LFWzVc5OT/UvPKwNnHYN2xZZyBYRxmXHqFIJSFNTmnbtL/Mj1h9NJYg+SjFfYW+pORqG6aXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJSHaFea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJSHaFea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B810AC4CEF1;
	Fri,  9 Jan 2026 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962075;
	bh=wIrwfX4mV3KebnyHD694pxaRlxPFC9BcDT2FY0XYgro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJSHaFeafDHz8SHzIGHt+E9urJ4PWF60CL6hkbht5UQ0T7PdVrJHFcQZbsKDzthz2
	 uSuQicImNNMn77XhLzf6fcHt9Qsi/CwiFJdBubL8pSCddOK3pvmEC46uTy7t6n/LSm
	 SOTkrxBgMF0EeyfSolSC81D1fp2xxKmytDmjND4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/634] fs/ntfs3: Support timestamps prior to epoch
Date: Fri,  9 Jan 2026 12:38:34 +0100
Message-ID: <20260109112126.423256392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index f2f32e304b3d3..c93217ed3f6c1 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -978,11 +978,12 @@ static inline __le64 kernel2nt(const struct timespec64 *ts)
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



