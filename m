Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1862634679C;
	Tue,  6 Jan 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719724; cv=none; b=A8nKO4jWWjoNnBdn5LRCiuQBuwcaFJWMxLtDinwRmLusna1En5z652co1XMMdnIsVm9R9dpfmwuv8JQLitAC/9QsrlL3nW0pqg4hYCBmnu6CtHgvNrm8Zen4aNjQL8hYyR4D0RiJFeJRqn0WR22ZBhNMU2HeVYGNQKFup710P3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719724; c=relaxed/simple;
	bh=kLQOaamVBlocJ8A7n225Htr2sPyD2TSY/EAaoaTY7sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjJLheqFZYVwK8GOLS0wUzcn7D+l1k+K+pZslTgCaEhKjnXYiIMCutuc0EidfJV7euSC8zQxjO6rS5kImPsuq19zL6mKaiATZPEY/4R2ZA/4Crcz3kX76bc1E98zfggdRv9hO2p/ib6OHaHAvsCm0GIrkuxSdOjdPqTJJIntmqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYbRUKHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYbRUKHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42623C116C6;
	Tue,  6 Jan 2026 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719723;
	bh=kLQOaamVBlocJ8A7n225Htr2sPyD2TSY/EAaoaTY7sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYbRUKHbkSCqcqTpeoA80dCA7XqhEcVA3G7InyiDl2vfQuXmoy83E/7TLRUjsnnfO
	 +13sxTMhIGp4tw/AKNfzirIo9DFEUeIGPxmb7qndH11+aqurUkdp1IEr822RO4pItl
	 MFIsLkdBkceKFy8G18SJ6EvraVLNR1hph/Ij7TQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/567] fs/ntfs3: Support timestamps prior to epoch
Date: Tue,  6 Jan 2026 17:56:42 +0100
Message-ID: <20260106170452.089768440@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff7f241a25b24..a1040060b081f 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -980,11 +980,12 @@ static inline __le64 kernel2nt(const struct timespec64 *ts)
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



