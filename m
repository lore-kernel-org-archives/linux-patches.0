Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2DA145B27;
	Mon, 29 Dec 2025 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025002; cv=none; b=pw6Iziv87nzZQ+q6tyyc0jQzff2tz96jxINw7hTVu2rrSyxAy0IRp1yECB3daRpZiV0XJjIEbfbukKbCZ7Hk2Zbo20TUQ2p4icUFaFEwN4Sx65sJxMir/NM2XwY3jTjZjczymSOl8laO0U4WIYyY2laS+0RfMPdH6umgOtHwSgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025002; c=relaxed/simple;
	bh=G133j5kxnd2Fd0MBMQKa0j20x35ZDbeR9UQ38SbkeEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itIB2ON6RmUSURHhkYAU1oXxIPOQ2lZXobJhwZkK0z7cV0HE6zJe9U6yn9DIOtCiVAsF0kdIfY2Qz0vUF+3YpJjdjuC02egrTmFynEqbR66T53DMaEcdlzb+5W5Ahr5Wu+Z0cuY7Mchg7hF8Q9Hzm40GBOqxB1BUPReojkRkjA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blZlJw5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blZlJw5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD73FC116C6;
	Mon, 29 Dec 2025 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025002;
	bh=G133j5kxnd2Fd0MBMQKa0j20x35ZDbeR9UQ38SbkeEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blZlJw5apK+g4iWpjkPjaBtEF+p7e0lio84J//9tLwuYJ/tdDNDEkaHys4lpWGUu5
	 2V2U/dApqjZ+KJLiIofAo8uUvSuNVjVoXVkeNhE0RGH5BAvh5KS8sWlvG/jxrykZRo
	 jQYvKBRhFBHl1ERIOT28k1kImamhsiWnaROV2a7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/430] fs/ntfs3: Support timestamps prior to epoch
Date: Mon, 29 Dec 2025 17:07:08 +0100
Message-ID: <20251229160725.121847500@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 630128716ea73..2649fbe16669d 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -979,11 +979,12 @@ static inline __le64 kernel2nt(const struct timespec64 *ts)
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



