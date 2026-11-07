Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063677;
	b=JU3pO2Ya9PRJ6/1Wdu9I8vwsz1qaE+qHZBmkiDNinJJifRpRhNRJHrMhKI1cvz84ZUKa
	 1CSSOtA/PMV/i/yWaSBqf1bVZJ9fDbKIWwL5d2UUep3huNZDBw05uQOiFOYhUtUiXk65A
	 SSOtPJ626RmM9Cpq6Y460vY2CZ1NtW6PQlo9pbIXG3rdPoQYvaBX97cPQCMahDT+oH4Oa
	 pHGhQ8Cp/Qknprv+b89t/xlqA5Fo6yfJwuQIjghzFNMOojucZQk16qbf9AZPdIRQendgi
	 QBp1FiM6ksTCR9712nN9Tu9+smmW+zrNg9VjvKrE+gTTJkZRkF/H6NwKRJfemlmJv3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N/R+aOVANEgpgBMzIx+9gr7YJsANL3+oHSFhZV+lXKw=;
	b=kM7waABoOVVjciDawV/a0g6ViyGJjP/2g6GOdfj/WsR/56a9uM7lcGQD+bcZKvjClVkR
	 4gFhAiLL0M1EZ/NvfjWKN3oODH9fItRf6IjN2GVAWQcW+8qgq1jpOOwFhR4NpFY5xX756
	 J8UowgKkopBo1mLWs2VoCrtn0pc9qD0URiXjFsCCy6kvvVRYbItU96ovJs/h5Mn3lp7sE
	 ptIRmGJlw1rsV1iM1CLYvdVutnh0FmrAWbNMp3pJOnOf/Y20m8IDH4nQ/vNsH03TFWqg5
	 GQcr8Zs36be7Byw7XYo9ua4E4eYj+PbnLgNw9hFE9CPU8Oxp023PluhB+RPUUGRc2eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6hDOeF7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF0A6082BF9;
	Sat,  7 Nov 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6hDOeF7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D491F0089F;
	Sat,  7 Nov 2026 15:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063677;
	bh=N/R+aOVANEgpgBMzIx+9gr7YJsANL3+oHSFhZV+lXKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6hDOeF7qx3F2whqzwiaEwBD1D/9KAro76GfbRk7p4WXUI6J5/NnRoJou7NywqJB8
	 OprXO9OWmPcuwO83JnlUabC0cknB2Ez78Xr6N5orqTfRXJ4qWk1tFMTNb/wADPjxup
	 tNerjrIUwEPasFV7448W01PsNaFU7+AXvcKF6JaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 787/869] f2fs: fix to update superblock crc in sanity_check_area_boundary()
Date: Sat,  7 Nov 2026 08:57:49 -0500
Message-ID: <20261107134919.412152507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit f8f956c7ec8c0285d7a80bed497d2f7adcbded15 ]

This patch fixes the bug reported by Sashiko:

We should update superblock crc along w/ raw_super->segment_count in
sanity_check_area_boundary() if sb_checksum feature is enabled.

Cc: stable@kernel.org
Fixes: d440c52d3151 ("f2fs: support superblock checksum")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 11d218b415b0d..69d36e1a301bf 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3920,6 +3920,12 @@ static inline bool sanity_check_area_boundary(struct f2fs_sb_info *sbi,
 		/* fix in-memory information all the time */
 		raw_super->segment_count = cpu_to_le32((main_end_blkaddr -
 				segment0_blkaddr) >> log_blocks_per_seg);
+		if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_SB_CHKSUM)) {
+			__u32 crc = f2fs_crc32(raw_super,
+					offsetof(struct f2fs_super_block, crc));
+
+			raw_super->crc = cpu_to_le32(crc);
+		}
 
 		if (f2fs_readonly(sb) || f2fs_hw_is_readonly(sbi)) {
 			set_sbi_flag(sbi, SBI_NEED_SB_WRITE);
-- 
2.53.0



