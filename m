Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037970;
	b=SIkfG6sKqezQ5Dn0vskkPWIcft/UZFMKYf1STjEn2v6Rv5zBTYCjQhwpuBnAMwfPJlLZ
	 RMkH9JonVZH+ADgsbKhnMvdVeahm25JKXzGtzxx9sP3TOLtC8idxJoq4ZhgRrJgOywYpB
	 dvZKwiDLrfmabIADLt+2CYP+RKITiS7Bp1zCwIeAXJYsFxjhA40E8B2JKMobatlFCIgYF
	 Z4X3oAKr0ZAXDVdSmV7/Ov2uWv38b0qeW11KqXHp2f7VT6DOysldJ4HxYRDiBKyFfrNFe
	 cs7kXmzWTrr3Wz5KaCTXMhySI77/VCVtffmHiB3HR/c7obh1lwujMUs3azCubbzbGkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TzSddSmcDHkFNHtT66iGOCE2cXd/yVJJYq42q6iNMRs=;
	b=5JPpBaLXsnocM5d/jg5rcsmTPTv1w3NE3GlWUpubleyZ8zBmLbKjREAXGI0m6F6J8UQr
	 4W8PAbTwjH0ZJdoY4RHp6xJbE2idMZMRoui6n18SEDIrTn7FrtZ96AZd5mVVTh/TJFmB1
	 ULywEJseRHMYTjB8co8tIiXRJQNd01c8PWU5sB1zkug1XwRM1VbFUlZvj88milR4rSgYo
	 m+X2UsfWBJldW/gZTMxFhCawCMF7k+lLhUlLyuqW+1lGfE77aHXDlpf9naAtonip9xqU+
	 /gp6XevIbv3vfV7VmoSADKS+9VKovHV5fmF0dKXZjTRkSmusJcxwBptL34kaW/eKj4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nNSZ/FDf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154C0606A32A;
	Wed, 18 Nov 2026 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNSZ/FDf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6211F000C4;
	Wed, 18 Nov 2026 21:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037969;
	bh=TzSddSmcDHkFNHtT66iGOCE2cXd/yVJJYq42q6iNMRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNSZ/FDfgxgm8J61rXB93PTYzY501BGlwdlEGOuEvaKY46yTYZNtLIIdYT4YuTlyu
	 L6i9OgSSZzA9uLUq2iBm186hLQ7aEt3HiGLn9ly8bjeCzV6zx7CealmyjCK14mShsr
	 z+BjJ5MA88GOgQN33cEcwRw3CMRhh2SnF6Z/47Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1581/3318] f2fs: force out-place update for all writes on compressed file
Date: Wed, 18 Nov 2026 15:36:43 +0100
Message-ID: <20261118150408.551839288@linuxfoundation.org>
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

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4 upstream.

For compressed file, compressed write may fail and fall back to raw
write.

-Thread A                                         - Thread B
  - f2fs_write_multi_pages                          - f2fs_down_write(&sbi->cp_rwsem);
   - f2fs_write_compressed_pages                    - ...
    - f2fs_trylock_op                               - ...
     - f2fs_down_read_trylock(&sbi->cp_rwsem);      - ...
   - f2fs_write_raw_pages                           - ...

Thread B acquires the lock first, which causes Thread A to fail lock
acquisition and fall back to raw-data write.
IPU_FORCE is enabled on small-capacity storage devices (< 16GB),
so f2fs_write_raw_pages() overwrites the original compressed data
in-place.

The in-memory node has been updated with raw-data addresses, while the
node metadata stored on eMMC still remains in compressed state.
If a power-cut occurs before the node is flushed to disk, on-disk
inconsistency arises: disk data is raw, yet metadata treats it as a
compressed cluster, leading to decompression failure.

To eliminate this risk completely, force out-place update for all
write operations on compressed file.

Cc: stable@kernel.org
Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
(cherry picked from commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4)
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b0c633c5deb75..65f933d24fe8f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2629,6 +2629,13 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 	if (f2fs_used_in_atomic_write(inode))
 		return true;
+	/*
+	 * rewrite low ratio compress data w/ OPU mode to avoid fragmentation.
+	 * If IO comes from compressed write path and fallback to raw write,
+	 * force out-place to prevent metadata-data inconsistency.
+	 */
+	if (f2fs_compressed_file(inode))
+		return true;
 
 	/* swap file is migrating in aligned write mode */
 	if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
-- 
2.53.0



