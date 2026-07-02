Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB633246EC;
	Thu,  2 Jul 2026 17:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011610; cv=none; b=BmwhgJ/1pmRmMMqX1qdGcg1N0X0jTkibpOhArf+ElhOVfCwZSGA1tisx9cPAYrXHJMdvP+5anbOuRs3yBrC1ZyoVmZi0roMml5fRQWNz/pE3XcUH1Q9/g0PAu7/kK9/hvsxQvbOPkdJ2n75Z5y2E9fAJRINJhKwxail8zT11Ihs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011610; c=relaxed/simple;
	bh=fW8Rm7MnWZ1Eamd9zxKPPVaoYvLmLbdXX3zYDj+CShA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBD9fayxdN/qHbbEr4czJD6mJmdA4fZUSXSyjwnhz/Q/A68SZWMiXPpMzg3PTbFvqimn7FqBm6ly85eGMiA7aVkcVyhuyghgJKoLrirDLe3WrKspCAkz+yAwJHHBFpItHUS5gZUiOGjX8OlXYqMNcEcEt3ebQxikcpA68w7lrOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCQq4xFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCQq4xFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84271F00A3E;
	Thu,  2 Jul 2026 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011609;
	bh=oq5tiJmGmTmt79Jk1/MDjihg8+p/66t2VPK1B+e9yjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZCQq4xFCbEux+i+9ol6Qzu6d0mfARutawhqcIW0vztnuUBvlmrdJHZ8LAXE684djY
	 JVplUQBdJGt7GI23bPTaDxPGt0c4m+ptTbcREcJydqAsGOPCxNRqm+1GB5OEsoyDi2
	 fJQrTRqXXYPYaDEZ/P1pt7D93fRJTO2J17BvBylg=
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
Subject: [PATCH 7.1 066/120] f2fs: fix to round down start offset of fallocate for pin file
Date: Thu,  2 Jul 2026 18:21:02 +0200
Message-ID: <20260702155114.324688093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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
@@ -1916,8 +1916,15 @@ static int f2fs_expand_inode_data(struct
 
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
 		f2fs_down_write(&sbi->pin_sem);


