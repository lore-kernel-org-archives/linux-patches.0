Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216731;
	b=dwsbekH0/r8pUeQSg22eT6ZWsTYKOQ34s/2cLPh+/8+EpJZGMhc8ZPmMhsIz7KqHkshH
	 +JfE+J+bDh4aUacXV8O96w+oNxbFIs/6FtCB8TuzJoNSbgqjkwUPSxI24Fx8JNYUdp4X9
	 uwabn8WdLjDOq7qnGn3rgDoITA5wc1P9K4XEfDIX8T4FiHQbnctFFEfGPXV9mcdnioaFS
	 ZIo8qxsvA0c5+PBuqFGyRlwONb9wvN2RZ0qKnjbwSlIIaA4yqziEBBityBJdUpOiWdQ+B
	 Gqv08seaQUOp13pC7ZrjvoasWUoqMyd1ceYhGyic/tK6XuvMWFFMdHGlA5A3KzeTd7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOqZYfffyxCiJwRX2o9XiSamZOM7LgPevwm8GhhSzQM=;
	b=apHGC83L8UdzcX2lxTWHfsg1cH0JVtR4PA6/YgkW7jm2MjecqyrWJeiS+SqJkAD+HIgY
	 ONF+KjhcNTIXaFdw3PctoH3EY/cds/LseRLbls7/jq22okUEZNXixci/8sWI95txVXTjG
	 zSlwrc9zYif1iiNc10B6NPHp+OLlwIoVdaCXjRjHRbgDRdsA0j/6BWAcd+VF3CZp/UcTz
	 SchLiReBrhdMgj+IqCO0BHCDV0nemtEdLzbY6rvkYLXXkygqg+PUqr2tIVlp7jUNEFFmi
	 71sZtPBQ2srVdYfj9WZwNlL+B0EsUi8GzU5ZbrX0p2+pe3ZKFr61KBe0sdIFgr5mnAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OY4z8sDH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0BF606A31A;
	Wed, 28 Oct 2026 19:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OY4z8sDH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D23D1F01825;
	Wed, 28 Oct 2026 19:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216731;
	bh=WOqZYfffyxCiJwRX2o9XiSamZOM7LgPevwm8GhhSzQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OY4z8sDHV+q5otnD0Ak84sNOOdkeQnnXDnXavfkXN3bBDFKyR15WKijZ9VxdZsoY9
	 RGC5olom53VI3akxNgutzInjYHRhQu9WywzPB5EIXDbE+C5e+LU2zGySzqisa3TTRn
	 ig2k3LbYdnmkvSQpS2MYm2bguonQJ0Ts6Mn6qUmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1660/1887] smb/client: flush dirty data before punching a hole
Date: Wed, 28 Oct 2026 18:02:36 +0100
Message-ID: <20261028170537.233554875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit d7d2adcd022baade5cab65ca492ce63421ce3a6e ]

Punching a hole after a large buffered write may leave the range
reported as data. Reproduce it with:

  xfs_io -f \
    -c "pwrite -b 3m -S 0x61 0 3m" \
    -c "fpunch 1m 1m" \
    -c "seek -h 0" \
    -c "seek -d 1m" \
    /mnt/test/repro

Punching 1 MiB at offset 1 MiB should produce:

  0          1 MiB       2 MiB       3 MiB
  |  DATA    |   HOLE    |   DATA    | EOF

Instead, the entire file is reported as data. SEEK_HOLE(0) returns EOF,
and SEEK_DATA(1M) returns 1M.

This happens because a dirty folio spanning the punched range can be
written back after the punch and refill the hole.

Fix this by flushing and waiting for dirty data in the punched range
before invalidating the page cache and issuing FSCTL_SET_ZERO_DATA.

The xfstests generic/539 pass against Samba/ksmbd with this change.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 590f8d44279a9..ecc5f27ff1413 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3599,6 +3599,15 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 
 	filemap_invalidate_lock(inode->i_mapping);
+	/*
+	 * Flush dirty data first, otherwise a dirty folio spanning the punched
+	 * range may be written back after the ioctl and refill the hole.
+	 */
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto unlock;
+
 	/*
 	 * We implement the punch hole through ioctl, so we need remove the page
 	 * caches first, otherwise the data may be inconsistent with the server.
@@ -3615,6 +3624,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
+unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
 out:
 	inode_unlock(inode);
-- 
2.53.0



