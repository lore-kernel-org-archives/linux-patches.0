Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038587;
	b=IFIVcmXDLSxArQEvDY1lXYtrpBI7vVmtYZwktYuGJoPzq0/iBb/0+Uds+UJYmCZJTLwP
	 Y3ELbKaa9fQ+d7zuqbEUlfs2dRX9Y/C4AjHEwN4hpqPlv97yFUWcluAbtTAnbGOlM5R9U
	 vaTsBRu6c2y2Aic1p8wg4iufV9kzAmPTGlh42zunxt1aMQAelE7kv+alcGiihvGKyh+eT
	 kC+02iQrv2wDJmPxx3zRtEiFb8a1UOhX6XrvVP7uUiJGOtzGGEASRWrnH6Ovmub8nc1Bf
	 hwK1tS/XS4Nf+5vV6W+52opCALBZALUON325LsXESn4bkyQPzpelcMikecCgSIJwZrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tOxGIw8YNZ1UOFv1ccUKjVG5k36wjCgJ41RUGjdf3wg=;
	b=SOzLXqeQf2/lJaJKKcISSHjWIEV5eWCLqg/HAwUtOzPFFmIsRaMIsLlQEvJxF31ktFwk
	 0g4w2tf8+0DRjCdq7JvQ2oBX6LlV8ElDAe5ztDaZqSnD+t+Bqo/POFNB1L2giX+/Eui4B
	 HSZfUu2IXqtppHivSxgGWhCOyUev7B/MUJpiTONCtnC/lQNnx/p0i8LR4cJ7AU445MK8O
	 yx0SZOM3M0rGzHoY1dLeZrLzqnsERz5r413PhfkGzpPVXE7Xlwbio6lR1o9j5r0ClX+pv
	 0V3BGjVLxa4RiTycy7sq2QKWksSYlSAZ8/KI+5G+W28tS+NzdsH0Vrmr6csnV5+L9XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1Stwu6w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C1E606A325;
	Wed, 18 Nov 2026 21:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1Stwu6w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2117B1F000CA;
	Wed, 18 Nov 2026 21:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038587;
	bh=tOxGIw8YNZ1UOFv1ccUKjVG5k36wjCgJ41RUGjdf3wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1Stwu6wvccf7qopBm6iCAZIyqhGPBVFrFglIZ68b+GRTjHuU7K/losn0m/bk5FSE
	 RbCNLoowrl8Qw0UjPOi1TGaqZatt0qOM98+dRm/qzLdbJ/s65ms2/nYSWih4jJQm7M
	 hmQPdWFFs9us0QDQdJ1CKlqgLZ0toFD5BLyFrOTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1797/3318] f2fs: fix defragment writeback range truncation on 32-bit
Date: Wed, 18 Nov 2026 15:40:19 +0100
Message-ID: <20261118150415.768120767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 92154fe28c3701bebf75176dc5522bec62519a8f ]

f2fs_defragment_range() flushes the range it is about to defragment:

	filemap_write_and_wait_range(inode->i_mapping,
				pg_start << PAGE_SHIFT,
				(pg_end << PAGE_SHIFT) - 1);

pg_start and pg_end are pgoff_t, 32 bits on 32-bit kernels, so both
shifts are evaluated in 32 bits and truncated before they are widened to
the loff_t parameters.  pg_end is only capped by the file's page count,
so for a file larger than 4 GiB the shift wraps.

For a 5 GiB file pg_end is 1310720 and the range collapses from
[0, 5 GiB) to [0, 1 GiB), leaving the rest of the dirty pages unwritten
before the blocks are moved.  For 8 GiB the shift yields 0, the minus one
makes it (loff_t)-1, and the range becomes [0, LLONG_MAX].

The matching call in f2fs_collapse_range() already casts:

	filemap_write_and_wait_range(inode->i_mapping,
				(loff_t)index << PAGE_SHIFT,
				((loff_t)pg_end << PAGE_SHIFT) - 1);

Do the same here.  On i386 the shift changes from "shl $0xc,%ecx" to
"shld", i.e. from a 32-bit shift to a double-precision one.

Cc: stable@kernel.org
Fixes: d323d005ac4a ("f2fs: support file defragment")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d92426073aecc..8561db9bd58d1 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2897,8 +2897,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 
 	/* writeback all dirty pages in the range */
 	err = filemap_write_and_wait_range(inode->i_mapping,
-						pg_start << PAGE_SHIFT,
-						(pg_end << PAGE_SHIFT) - 1);
+						(loff_t)pg_start << PAGE_SHIFT,
+						((loff_t)pg_end << PAGE_SHIFT) - 1);
 	if (err)
 		goto out;
 
-- 
2.53.0



