Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623379;
	b=TQjbDHnZ1oG90A0hdNhcXClTnJUJWhl0UrtvFwM07jI1B52Mo90e1hAXb0c0pXYiW8uX
	 bCqwfsiisqQiQNbqwJphw8lgjyWZP3A+GYIp/j9UD0B5LEtD3ghFh2XXXnSamHmWNOytm
	 MejQnRsNtH56pexqex2mle22nnQ4HD8FSbZHooSNmWTSWnLh7xbA1RWFrRf9y8PYfJQzk
	 77oGlODrRWRE3wdCbsr9ECnonwmiFdpUEgbH2OJuiWmOTXia/II1RsB1IqA4x3Mscmll8
	 XadXLwsjWLvCILWHjU4nJ6MBPVutoYkUrOjVqBok/9kSwKyjZDiZMQdH52ym8z8nvLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5h8B03Q/xlx5p5Pza5tholm7igwkoV5JAaL3wsa9Do=;
	b=R5iFvvnm0xHH0Dj7FJ1v0XMkfPxLxtZ5i6+zV+n3nmCSd05Hmlaj4ZPhPgM123KbyT/0
	 b/R/3RTwuPzrO0lvcXWqMY1IzH77ctvoPxrAgzGFQt0PE3XXPO59EjOO/kAupBgxWH2VN
	 RfI2OwRm0Jam8tHVrgV9Op59EQyrP/q15YrwuwU1zYOQESGlKor1IZw6SOSLo+u1KvGMU
	 lCFKWIDIjzhqq5aO4iXCct5sYzye+/SL9kB9vOpSJ5co0Msx2+FMYQnwKlPX23yngOIOC
	 KIIg6u6ENKo028aH45ztWXaQh9FFjtez3T3OfJKtAZujLysR+vH2ZCRM3k2CRC96KGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TktzbIrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9ED606A329;
	Wed, 25 Nov 2026 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TktzbIrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05ED1F000C4;
	Wed, 25 Nov 2026 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623379;
	bh=T5h8B03Q/xlx5p5Pza5tholm7igwkoV5JAaL3wsa9Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TktzbIrkPnh25R9NfPGNy+5ZgMl41zBN8Dky8JuerVxWILoiQo0HTssqmWp+QLjYG
	 xaVuhGw7hsynPC4Lsi0KVI33KWyctwd+/TiQQc+26ZAznzdpffC7P4jVYAgY4PUDi0
	 xhGEK4mi9o86hIhusdGUMmSESLeHuDB0SpwZt3aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 841/990] smb: client: fix OOB write when compounding SMB2_IOCTL with encryption
Date: Wed, 25 Nov 2026 15:36:48 +0100
Message-ID: <20261125143841.730599967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Andrey Misiurov <andrey.misyrov@gmail.com>

commit 73a0060cb22a1d2bd8bff364c18a4259ec0cb528 upstream.

On an encrypted ("seal") mount, SMB2_ioctl_init() keeps the IOCTL input
in a separate iov (iov[1]); iov[0] is a 448-byte buffer from
cifs_small_buf_get().  When such an IOCTL is not the last request of a
compound, smb2_set_next_command() pads it for alignment by copying the
whole request into iov[0].  A large enough input overflows that 448-byte
buffer and corrupts the slab; the copy also sets rq_nvec to 1, so the
input buffer is leaked too.

An unprivileged user can trigger it by creating a symlink with a long
target on such a mount: the native symlink is sent as
FSCTL_SET_REPARSE_POINT + QUERY_INFO + CLOSE in one compound, so the
IOCTL is not the last request.

With slub_debug red zones on the cifs_small_rq cache, the overflow is
caught on the next allocation from that cache in the same compound (the
0x61 bytes are the 'a' characters of the symlink target):

  BUG cifs_small_rq (Not tainted): Object corrupt
  [Left Redzone overwritten] 0xffff8a59c7790500-0xffff8a59c779053f
  First byte 0x61 instead of 0xbb
  Call Trace:
   check_object+0x1a8/0x350
   alloc_debug_processing+0xab/0x110
   ___slab_alloc+0x7e/0x2f0
   kmem_cache_alloc_noprof+0x28d/0x4b0
   mempool_alloc_slab+0x16/0x30
   cifs_small_buf_get+0x1a/0x30 [cifs]
   SMB2_close_init+0x8a/0x100 [cifs]
   smb2_compound_op+0x2571/0x2b50 [cifs]
   smb2_create_reparse_inode+0x27e/0x490 [cifs]
   mknod_nfs+0x1ce/0x2e0 [cifs]
   create_reparse_symlink+0x119/0x180 [cifs]
   cifs_symlink+0x19f/0x8e0 [cifs]
   vfs_symlink+0xa3/0x1b0
   __x64_sys_symlink+0x41/0x70

Pad the input to a multiple of 8 bytes when encryption is required.  The
request is then already aligned and smb2_set_next_command() no longer
copies it; InputCount still carries the real length.

Fixes: 90f7c100d2dd ("smb: client: fix compound alignment with encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3354,11 +3354,12 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 		char *in_data, u32 indatalen,
 		__u32 max_response_size)
 {
-	struct smb2_ioctl_req *req;
 	struct kvec *iov = rqst->rq_iov;
+	struct smb2_ioctl_req *req;
+	u32 in_buf_len = indatalen;
 	unsigned int total_len;
-	int rc;
 	char *in_data_buf;
+	int rc;
 
 	rc = smb2_ioctl_req_init(opcode, tcon, server,
 				 (void **) &req, &total_len);
@@ -3366,15 +3367,18 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 		return rc;
 
 	if (indatalen) {
+		if (smb3_encryption_required(tcon))
+			in_buf_len = ALIGN(indatalen, 8);
 		/*
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool
 		 */
-		in_data_buf = kmemdup(in_data, indatalen, GFP_NOFS);
+		in_data_buf = kzalloc(in_buf_len, GFP_NOFS);
 		if (!in_data_buf) {
 			cifs_small_buf_release(req);
 			return -ENOMEM;
 		}
+		memcpy(in_data_buf, in_data, indatalen);
 	}
 
 	req->CtlCode = cpu_to_le32(opcode);
@@ -3398,7 +3402,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 		rqst->rq_nvec = 2;
 		iov[0].iov_len = total_len - 1;
 		iov[1].iov_base = in_data_buf;
-		iov[1].iov_len = indatalen;
+		iov[1].iov_len = in_buf_len;
 	} else {
 		rqst->rq_nvec = 1;
 		iov[0].iov_len = total_len;


