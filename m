Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CED3101C8;
	Thu,  2 Jul 2026 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011058; cv=none; b=mogyaUEErybgS7+EulemQOzvzjP13elf+5t/BRyX8LXdnVbeGSrTNFVBKjNJ29JkIDQvA2bM4SlNxEYXeTc0tnMa6OtvlMTqJZ7sccc9w7L38ZPA4khtKCMOjZAlxr28KGaNAp3D6kq8hPhCWCvI+Bbh8uixzgw6vChmKeD4u14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011058; c=relaxed/simple;
	bh=1XasSclNf/CdFerYrKfLq75Y1bjmG3hgIq95Pr+Wmhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNe/TOFFvMm5U/RMt5QxWIyou7OxHh/n0dYbTk/x2h/+9pJmCXTT7xfFudCRzyKeRBPL76/Cpe+PNgX4pZ6a2m8CTxf9IK4ZF1LHzyka82Qpw6zB5shxSgI5YBRXPJMd285olJKKHMDz+Su+M8+R5gZml5CTW6Eje4k7W1+HLjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0oa49OD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0oa49OD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FED1F000E9;
	Thu,  2 Jul 2026 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011057;
	bh=TUh5hDT0oWXNhH7+dMFh+EkBGkc2qn1E1YnvxSBow/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0oa49ODIF1y6w9cQyVFwBR+Fnod+ccxpzr7WB3M7d0Q/OLRmkv4xBm8keg22AyaP
	 9On0gUEvrAdZTev3uaENJgpBoVdv38mQDobOZCQTgAHi741IkyhJytxGnPLSz2NaAp
	 Y9N2QF01kheaEM7gsBmZAvs5yusbvWlMfOeYn7Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunji Kang <yunji0.kang@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 138/175] f2fs: fix to round down start offset of fallocate for pin file
Date: Thu,  2 Jul 2026 18:20:39 +0200
Message-ID: <20260702155118.715919644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Sunmin Jeong <s_min.jeong@samsung.com>

commit 4275b59673eb60b02eec3997816c83f1f4b909c4 upstream.

Currently, the length of fallocate for pin file is section-aligned to
keep allocated sections from being selected as victims of GC. However,
for the case that the start offset of fallocate is not aligned in
section, the allocated sections can't be fully utilized. It's because a
new section is allocated by f2fs_allocate_pinning_section() after using
blks_per_sec blocks regardless of the start offset. As a result, several
unexpected dirty segments may be created, including blocks assigned to
the pinned file.

To address this issue, let's round down the start offset of fallocate
to the length of section.

The reproducing scenario is as below

chunk=$(((2<<20)+4096)) # 2MB + 4KB
touch test
f2fs_io pinfile set test
f2fs_io fallocate 0 0 $chunk test
f2fs_io fallocate 0 $chunk $chunk test
f2fs_io fallocate 0 $((chunk*2)) $chunk test
f2fs_io fiemap 0 $((chunk*3)) test

Fiemap: offset = 0 len = 12288
    logical addr.    physical addr.   length           flags
0   0000000000000000 000000068c600000 0000000000400000 00001088
1   0000000000400000 000000003d400000 0000000000001000 00001088
2   0000000000401000 00000003eb200000 0000000000200000 00001088
3   0000000000601000 00000005e4200000 0000000000001000 00001088
4   0000000000602000 0000000605400000 0000000000200000 00001089

Cc: stable@vger.kernel.org
Fixes: f5a53edcf01e ("f2fs: support aligned pinned file")
Reviewed-by: Yunji Kang <yunji0.kang@samsung.com>
Reviewed-by: Yeongjin Gil <youngjin.gil@samsung.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1826,8 +1826,15 @@ static int f2fs_expand_inode_data(struct
 
 	if (f2fs_is_pinned_file(inode)) {
 		block_t sec_blks = CAP_BLKS_PER_SEC(sbi);
-		block_t sec_len = roundup(map.m_len, sec_blks);
+		block_t sec_len;
 
+		if (map.m_lblk % sec_blks) {
+			map.m_lblk = rounddown(map.m_lblk, sec_blks);
+			map.m_len = pg_end - map.m_lblk;
+			if (off_end)
+				map.m_len++;
+		}
+		sec_len = roundup(map.m_len, sec_blks);
 		map.m_len = sec_blks;
 next_alloc:
 		if (has_not_enough_free_secs(sbi, 0,


