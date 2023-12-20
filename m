Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8D847A4D;
	Wed, 20 Dec 2023 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxTVbXGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A350C433C7;
	Wed, 20 Dec 2023 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088972;
	bh=AoPD5bPBspOw/zY6MP8AnuIaVH7Tb3niSFJp+DULjZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxTVbXGAcGm/uCjqbA93SlUVjUe4Tw3ZpaEDrk5bxrrxRldW4+6G/xS++oqb6OfZA
	 bxJWwAXGZPSMHzYBzF2fu3nsFm0sW1Zgja9XuyOdcNBBdVre+Ew4W3KkRX4QQD+2xa
	 u2kpPjCx0Sjtd4aZAKXVd9NK6zzTbr5yd8mSzBUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 122/159] ksmbd: reduce descriptor size if remaining bytes is less than request size
Date: Wed, 20 Dec 2023 17:09:47 +0100
Message-ID: <20231220160937.021750907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e628bf939aafb61fbc56e9bdac8795cea5127e25 ]

Create 3 kinds of files to reproduce this problem.

dd if=/dev/urandom of=127k.bin bs=1024 count=127
dd if=/dev/urandom of=128k.bin bs=1024 count=128
dd if=/dev/urandom of=129k.bin bs=1024 count=129

When copying files from ksmbd share to windows or cifs.ko, The following
error message happen from windows client.

"The file '129k.bin' is too large for the destination filesystem."

We can see the error logs from ksmbd debug prints

[48394.611537] ksmbd: RDMA r/w request 0x0: token 0x669d, length 0x20000
[48394.612054] ksmbd: smb_direct: RDMA write, len 0x20000, needed credits 0x1
[48394.612572] ksmbd: filename 129k.bin, offset 131072, len 131072
[48394.614189] ksmbd: nbytes 1024, offset 132096 mincount 0
[48394.614585] ksmbd: Failed to process 8 [-22]

And we can reproduce it with cifs.ko,
e.g. dd if=129k.bin of=/dev/null bs=128KB count=2

This problem is that ksmbd rdma return error if remaining bytes is less
than Length of Buffer Descriptor V1 Structure.

smb_direct_rdma_xmit()
...
     if (desc_buf_len == 0 || total_length > buf_len ||
           total_length > t->max_rdma_rw_size)
               return -EINVAL;

This patch reduce descriptor size with remaining bytes and remove the
check for total_length and buf_len.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1364,24 +1364,35 @@ static int smb_direct_rdma_xmit(struct s
 	LIST_HEAD(msg_list);
 	char *desc_buf;
 	int credits_needed;
-	unsigned int desc_buf_len;
-	size_t total_length = 0;
+	unsigned int desc_buf_len, desc_num = 0;
 
 	if (t->status != SMB_DIRECT_CS_CONNECTED)
 		return -ENOTCONN;
 
+	if (buf_len > t->max_rdma_rw_size)
+		return -EINVAL;
+
 	/* calculate needed credits */
 	credits_needed = 0;
 	desc_buf = buf;
 	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+		if (!buf_len)
+			break;
+
 		desc_buf_len = le32_to_cpu(desc[i].length);
+		if (!desc_buf_len)
+			return -EINVAL;
+
+		if (desc_buf_len > buf_len) {
+			desc_buf_len = buf_len;
+			desc[i].length = cpu_to_le32(desc_buf_len);
+			buf_len = 0;
+		}
 
 		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
 		desc_buf += desc_buf_len;
-		total_length += desc_buf_len;
-		if (desc_buf_len == 0 || total_length > buf_len ||
-		    total_length > t->max_rdma_rw_size)
-			return -EINVAL;
+		buf_len -= desc_buf_len;
+		desc_num++;
 	}
 
 	ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
@@ -1393,7 +1404,7 @@ static int smb_direct_rdma_xmit(struct s
 
 	/* build rdma_rw_ctx for each descriptor */
 	desc_buf = buf;
-	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+	for (i = 0; i < desc_num; i++) {
 		msg = kzalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
 			      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
 		if (!msg) {


