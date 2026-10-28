Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208292;
	b=iHYBh+glILLnLFl3prH0tWMGqpUUTq5YCWJOIb9tUn32JirkwqPCUUkfBKPj/TmKhgUp
	 UaxqYUVMfd6n/LlqOcAe2gsO8T3i+9nTcMK0Dkmh4ArkaYbqS2f2fyiHy+htgKmcMrfD5
	 IariUEptujm2NgE9up0gMWQEcxu9C93KDt6Bd6wRyMEz7kxSGP32rMNwLEZ7x8BBRsQi0
	 7vfUm/7HHKs9dEgE+Od37mcZgfkcIiDVkgI3IFRthv6npYKr9mkZKxoZRXd54WjkThu/Q
	 xC4Us+Dw9bxK3ieILBKA6+LyKoQWq5YqotibByb3T8qEqXHogfytRHJxfTgfHceB1pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jm0X0d7IVRrUN78rD+P8RIZEewk+7Z5NbeG3N1ZCEaM=;
	b=48FbqROv3Iow7DeURL8oIhYmUatyjWKqwdxeUMse1uE3HnP+uNE3s1uSATcykHz9DL55
	 PWUqv9zkULXHBZU2N+ER+s66M8F/meOY/VAzcMhVjSe1It8o/bOI41o12Kt4cL9qUeEYU
	 ZSagLb7ngbRO1DtvFNhTCV3RypJtL/hKB1SvYeppwyU3LxedWTtyxPdzLV+DRo6p2epiu
	 eXSusf5XRi8CvXU4LMJuT5hWOmYMX1boNiYmrWI3K6rCWO72EWr7ENhSAKXHhsu4CUCew
	 NTl6nx+sNCqYwFZCe3Gj70q739i74M4dLZo8u5HlLriUdbb27ug3Wzq5CAqJjnLug/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNIKNiYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4523606A32A;
	Wed, 28 Oct 2026 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNIKNiYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF321F01828;
	Wed, 28 Oct 2026 17:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208291;
	bh=jm0X0d7IVRrUN78rD+P8RIZEewk+7Z5NbeG3N1ZCEaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNIKNiYZWGrYDU4srtjRoLlwx3Rp9J35mDT3mCfEi4niHW8HjvMUMeb2zmC6ASy4B
	 sUugFUeJSRmSEDrzYy9sox73UG/ThdKNpBfbMso9AdvFTb9GXOF7q8JeoXDnKfNKm2
	 xo4cnc+auZui9F+fyBHKJhKJF5C6x2ucfnZJKETE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/516] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Wed, 28 Oct 2026 17:53:23 +0100
Message-ID: <20261028170004.740910519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 6c322f5cf7476ded7a9a20f7be72462065a03c68 ]

With len == 0 (clone to EOF), the effective length is computed as:

    len = src_inode->i_size - off;

If off > i_size, this is a negative loff_t, corrupting the ByteCount
in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
in filemap_write_and_wait_range().  The existing off >= i_size check
fires only after the ioctl has already been sent.

Snapshot i_size_read() once for both the bounds check and the length
calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
off > src_size with -EINVAL.  Treat off == src_size as a no-op,
consistent with __generic_remap_file_range_prep().

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ added the missing unlock label at the existing common unlock path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 900ac4d04d901..228087c90de25 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1117,8 +1117,19 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	if (len == 0)
-		len = src_inode->i_size - off;
+	if (len == 0) {
+		loff_t src_size = i_size_read(src_inode);
+
+		if (off > src_size) {
+			rc = -EINVAL;
+			goto unlock;
+		}
+		len = src_size - off;
+		if (!len) {
+			rc = 0;
+			goto unlock;
+		}
+	}
 
 	cifs_dbg(FYI, "about to flush pages\n");
 	/* should we flush first and last page first */
@@ -1134,6 +1145,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	/* force revalidate of size and timestamps of target file now
 	   that target is updated on the server */
 	CIFS_I(target_inode)->time = 0;
+unlock:
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
-- 
2.53.0



