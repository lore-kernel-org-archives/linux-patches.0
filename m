Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BC7410D1E;
	Tue, 28 Apr 2026 10:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372964; cv=none; b=U9SQkcpbkPAxK4V3ZfVt4kzJUx0e3KExuXj/Wo+Wz0SYOYOTdZFaFAviHGF67X6LjszsMKYPFf3zWu7T9xSDZFh4157cq2CKBMT9aP09+lWKM6HZbmpieWnlE1qr3vNPBv/sKH4XDVOT3VCZZVIExAFmBpCqPP+vOmtiii5Fz+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372964; c=relaxed/simple;
	bh=dXI/vAv/gyHdbSYvWO7nKusYRO6ZGRtYiYyEwaRHwo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFmoeXlI12QuA1i/zozvz0cc/zyt4nSxn/AY1GYMdRMLP1L/ZEJk95icdYwG2C9ARwxJGb3xiORF5lVmoJWB01OvZv9L3MU/q/TyrHavdldegT0vEeRMvX8T8Lfuvo8t1TXiUBgynIuaRDoOFCJFlcJd3YrY6R3ilZjh6ojES3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMD6OQCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMD6OQCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BB2C2BCB6;
	Tue, 28 Apr 2026 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372964;
	bh=dXI/vAv/gyHdbSYvWO7nKusYRO6ZGRtYiYyEwaRHwo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMD6OQCUgtx7Cb6d79PPq1r7/yWERdwgX5lLjYmwcCAPrWg9N8HiDvGGPwgkRVOBq
	 zOytDyy8MT+137jPfIFEZxWbzaOXDHrahs6kFjAlB0jfEESxClwVYNA6h9w2ojFTzi
	 X6oAOKiT5VD/nOhI0iNDKJbt0s9lHYRLkyFJfci2nMITzwZcZsM3PrgUyNicidI3CU
	 t5DiYA8CYgcX6rLFk6bLW08tesslf7c+z1Q/r3Q3qXBbyqIuTSH7YSRFYMHi1u4slu
	 lkkz+FL2xG6lDlkbhLWqR6N6RszpDxBL41fe4FUvVh7bcpV8sPfhizwf62xy8DoorF
	 1AhoIb+K9fRiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: 0xkato <0xkkato@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] ntfs3: fix OOB write in attr_wof_frame_info()
Date: Tue, 28 Apr 2026 06:41:01 -0400
Message-ID: <20260428104133.2858589-50-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: 0xkato <0xkkato@gmail.com>

[ Upstream commit 859d777646b56dd878b136392f3d03fb8153b559 ]

In attr_wof_frame_info(), the offset-table read range for a nonresident
WofCompressedData stream is:

    u64 from = vbo[i] & ~(u64)(PAGE_SIZE - 1);
    u64 to   = min(from + PAGE_SIZE, wof_size);
    ...
    ntfs_read_run(sbi, run, addr, from, to - from);

A crafted image sets WofCompressedData.nres.data_size to 0xfff while the
file is large enough to request frame 1024 (offset 0x400000). This gives
from=0x1000, to=0xfff. The unsigned (to - from) wraps to 0xffffffffffffffff
and ntfs_read_write_run() overflows the single-page offs_folio via memcpy.

Triggered by pread() on a mounted NTFS image. Depending on adjacent
memory layout at the time of the overflow, KASAN reports this as
slab-out-of-bounds, use-after-free, or slab-use-after-free all at
ntfs_read_write_run(). Secondary corruption/panic paths were also observed.

Reject the read when the offset-table page is outside the stream.

Signed-off-by: 0xkato <0xkkato@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 fs/ntfs3/attrib.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 6cb9bc5d605c2..89921e5091c9a 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1576,6 +1576,12 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 			u64 from = vbo[i] & ~(u64)(PAGE_SIZE - 1);
 			u64 to = min(from + PAGE_SIZE, wof_size);
 
+			if (from >= wof_size) {
+				_ntfs_bad_inode(&ni->vfs_inode);
+				err = -EINVAL;
+				goto out1;
+			}
+
 			err = attr_load_runs_range(ni, ATTR_DATA, WOF_NAME,
 						   ARRAY_SIZE(WOF_NAME), run,
 						   from, to);
-- 
2.53.0

