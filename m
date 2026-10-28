Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208203;
	b=wX2JWdJzhm2LtELhPO/WH4wbL3X8ukaISUYw+qglBLYe8IWzBgYJfrCAo52CVHhCcDli
	 fr5odJ+G8GolDgCDqIKmHH2hJUpsfwi7ufn3jp5Gv58zDFBenP32mHWG2LTTq4FR56PQ5
	 3nAHrI5wJCXbvgcsGW7SNvSgCSihVxSek8nYZLrVFydRbfxNyjag72FEPVThivx7OHIX5
	 aN9yiT8sYZEu+iRfmRO69mUbD3BSGqWYLKtdkmXJbJCD1Wy6d3JtwjBKQLT7eWuUR2JCW
	 zxkfMLT2ozB2pOl3uAXhlO5e8lKY3ft7MA3JkG0DLKHOpPeteu9UP4wAFwO/UrSxHGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o6vhZKsUPTEXMaV2itdjy05DiEsWxCcoFKfdYhnP+kM=;
	b=pSB3kDwN9MTYpjlX7AdKxxEqBxK8spsdsubGpG256JOta9vwY1DQt7E6U/MEM7fpDCcT
	 79NuBH0/EI0+Kop7r+95mWmrR2sLTvn/c68vkesYpMeAnpxiQsSmk0OrJQPKETjfgCdmC
	 DuKtu42bsphD/2QmznEORqs2jQBgvlhnepRDYRRAm32wjngXCaDLOkkw8tCGn6cpHhtTG
	 NKPGlPtPWVvOh8S/BMeX6rJzlOWYd/ibFenMmojSVd0YIYKh5MdX5mNEBTLnYMICXONyP
	 WGP8Gg943ySryZ84vmm5KMUn2nA9USkdUq8FWsAVuU/w+Tgt//PBIt4C56l+j5GN1Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZ6Y+JQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FF3606A31D;
	Wed, 28 Oct 2026 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZ6Y+JQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79311F01825;
	Wed, 28 Oct 2026 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208203;
	bh=o6vhZKsUPTEXMaV2itdjy05DiEsWxCcoFKfdYhnP+kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZ6Y+JQTZzMDgjBlI6VR98fC5Nz9Lm6j8b4kUdpeBhpzTZp/UwkBGOdPNZIaaoMQx
	 nyGAx//lLmjuGMbZ/f1jPlpU/JhxD8tf+UhcdAkTa0cZYHnTMLL9YE0d0CH+ECPVib
	 E+FRlhojlvyVBj2/rUNEpJwf78pEI8Zx+CIIUrNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/516] smb: client: fix potential OOB read in smb3_enum_snapshots()
Date: Wed, 28 Oct 2026 17:53:08 +0100
Message-ID: <20261028170004.384819817@linuxfoundation.org>
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

[ Upstream commit 4775c3b7a597907e0b97556c7986fda238a377ae ]

If snapshot_array_size is smaller than GMT_TOKEN_SIZE,
smb3_enum_snapshots() sets ret_data_len to
sizeof(struct smb_snapshot_array) without verifying the actual length
of the server's reply.

Because SMB2_ioctl() places no lower bound on the server-supplied
OutputCount and allocates retbuf to exactly that length, a short reply
results in ret_data_len exceeding the size of retbuf. The subsequent
copy_to_user() then reads past the end of retbuf, leaking adjacent slab
memory to userspace.  The subsequent clamp check is ineffective as it
only reduces ret_data_len.

Fix this by rejecting replies shorter than
sizeof(struct smb_snapshot_array) with -EIO. Note that the bound is set
to the 12-byte struct size rather than the 16-byte
MIN_SNAPSHOT_ARRAY_SIZE defined in MS-SMB2 3.3.5.15.1, because 12 bytes
is exactly what copy_to_user() attempts to read.

Fixes: e02789a53d71 ("smb3: enumerating snapshots was leaving part of the data off end")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 51f8ea0c89065..8fb3db801d3ab 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2165,8 +2165,14 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 		 * and retry the ioctl again with larger array size sufficient
 		 * to hold all of the snapshot GMT tokens on the second try.
 		 */
-		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE)
+		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE) {
+			if (ret_data_len < sizeof(struct smb_snapshot_array)) {
+				rc = -EIO;
+				kfree(retbuf);
+				return rc;
+			}
 			ret_data_len = sizeof(struct smb_snapshot_array);
+		}
 
 		/*
 		 * We return struct SRV_SNAPSHOT_ARRAY, followed by
-- 
2.53.0



