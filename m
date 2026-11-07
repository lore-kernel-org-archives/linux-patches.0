Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062840;
	b=VoDotzAVw+odzap5qXjVR3axOiZJWsOtkRNEPxsqRNMW5C9HjPzw/AXay6/s3raAqkP8
	 RVvaEYx8y6wF+RvtipTHspwh0Snox/fNfM4x9mDaIx9nALO68OWh+2fXc0UAtsSbHDJWd
	 xxazBuZvrd6dsPYum54bBn+Epj3yCuPTVYwIUkf+i0zUB0gsCuK2P0+3YtjMO70iccsr0
	 Llr70A2yaSzMNr/FuSvXKk3nj4IutlPrVujyr7W7EV/cU7Qk45l+JwWF3IOrHWtR4btdv
	 V8I5cNNWQzMUy522Oxz1UAfV1l2mcDEZIWO2mgPlD5M/cySX+vN1A+d/Hu6CESPaMGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pmqL1OvHL6JISJiTDx4xOVSewg+MfTZZ80fSOLmfzu4=;
	b=lv5lle7qEa0fogaG3yVKlf3i25ezDp1vo/BzNf5lznCat+4vobXTDnEN54T/YU1PAJn5
	 MDBLTO8i9ZOhmuratrmfDSEvKSvZlabpdudoHXybulg85a/6AOLSLX98srfjKJAO8dY1g
	 U/o3ObztzdCsS6Q4gr84KX9WPpKvaMQg5dQDABZiq3S6I4/W7KE0LBciepKrQdcfqT3M2
	 xQ85exV828o1fjO1SZAGgAsHYV6SpEkaPy6fUBpTRVEblYtGEpzDAG/ZOdKQ7ZeMQuf3O
	 6CJCCPLbXujTVqKTG/wsTA/E5boLnTxIOGkk3LcbojHvMoPNSToyAm0Ng5i2+NdtfDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bbRDjyv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A6A606A32F;
	Sat,  7 Nov 2026 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bbRDjyv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089521F0089F;
	Sat,  7 Nov 2026 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062840;
	bh=pmqL1OvHL6JISJiTDx4xOVSewg+MfTZZ80fSOLmfzu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bbRDjyvNllhbd3uhsuIm+hUX2kSkjShNoJZ5K+t0WjPEc5ELTx1TLgoxk4HIOGXI
	 +1mRnhGLVx9FBRCOs0iSRu6nWL+BpTURlRvjsow5JYmx4ZaaycwXOiOluzd3szDRtp
	 KWfw2xbBO48m0pSdVs7j7iVRuQVaDDXI9GtulTJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/869] f2fs: force out-place update for all writes on compressed file
Date: Sat,  7 Nov 2026 08:46:57 -0500
Message-ID: <20261107134857.008901705@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

[ Upstream commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3455565b82451..aa6a844ed34dd 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2675,10 +2675,12 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 	if (f2fs_used_in_atomic_write(inode))
 		return true;
-	/* rewrite low ratio compress data w/ OPU mode to avoid fragmentation */
-	if (f2fs_compressed_file(inode) &&
-		F2FS_OPTION(sbi).compress_mode == COMPR_MODE_USER &&
-		is_inode_flag_set(inode, FI_ENABLE_COMPRESS))
+	/*
+	 * rewrite low ratio compress data w/ OPU mode to avoid fragmentation.
+	 * If IO comes from compressed write path and fallback to raw write,
+	 * force out‑place to prevent metadata‑data inconsistency.
+	 */
+	if (f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



