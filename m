Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044463;
	b=q4HtptAES4pud8O5lAI0OR10tvLbkbridlTq04KuD2iPgZ71RgU6WUOb1tFqXHlM+oSv
	 ediWo2khJzeDcIKMA3q76l+ZfOXNK1uVU6jB086D6SPdC1bBnlkZi35ZW+9YqFYxP7nJX
	 JLFmmc1UE+1OaogMU5UdQ9iPde5bUnXIK2ZpT193W/1gAKSiZqqTb5c2zgsgSceui3t7J
	 +Y6iRN8Aa5P1sGq7/d/xUmhUXDV0Bor926+H7IADoBQwo2PmHVQIlJwQgU4Rx61hfa0lB
	 0UCJg7gX8fSFttkgzqPJRX+rDK2I8Z7gaht3oOY0PL63eHYcJAegZUnoUfaVZr4Xklw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vcIrJzU/sCtb3OKfa4nfkyPIB9OTa2NWTV5SHUwo560=;
	b=teP0XXHzNu1FnxEuV241UB2DocePVuGT/dCUyHz3elODbj/DnYw4KxahEAUFct6EzCea
	 3lBAS59mZ7fZ4czs+sv4ar93sBoOjwmCkjzDphQoi20c3ttKmXYJF6EJTeJNaTsgDOGKx
	 nkib9Lry91gkuvp3vs7Ph03WIQoi2+LklTnCP3/AxLnieYZsIzjHB5CQAxZx4k9ExV/8C
	 S+tCAc3cb0trcWefxSk9gJ/2NkwKcoO/EM76DsHZy3SLJ1Rr15ql63d7vn/W7L0eckL14
	 BAlA1VhhZHFjsPa/O9HfT7lrYisFA5vR4RRDArBBFV5qsJkmaZRd7ZT0ciuPkuXebOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2MX3KMS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F352B606A32A;
	Wed, 18 Nov 2026 23:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2MX3KMS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB991F000C4;
	Wed, 18 Nov 2026 23:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044462;
	bh=vcIrJzU/sCtb3OKfa4nfkyPIB9OTa2NWTV5SHUwo560=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2MX3KMSMLQ1ASUBm+4QMBBxeaK8ZyKoUqr5yA6FB2g4cYTyrGVzu0FeQ6OGn4ktH
	 rJRXP5C/AvOUaxNInjLfa19cIXkB174vxyM0TXV5sFDjCrJf1vSBR3DNfJvPhbO/3n
	 IhtcKP7xl44lpJTE75PRwdQtg00xkas7J6T1wb/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0517/2857] ksmbd: return end of file for reads past a named streams data
Date: Wed, 18 Nov 2026 15:25:51 +0100
Message-ID: <20261118150220.083420846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit 626611dc22a3b63b3264a7a797d9dbc530234fcd upstream.

A READ on a non-empty named stream at or beyond its end fails with
STATUS_INVALID_PARAMETER. ksmbd_vfs_stream_read() returns -EINVAL when
the offset is not below the stream length, and smb2_read() maps -EINVAL
to that status.

smb2_read() already turns a zero-byte read into STATUS_END_OF_FILE, the
status a regular file returns at its end, and an empty stream already
takes that path. Return 0 instead of -EINVAL so that non-empty streams
do the same. Clients that read a stream until end of file otherwise get
an error once they have read all of its data.

The buffered copychunk path converts a zero-byte source read to -EIO,
as it does for a regular file that shrinks during copying.

Fixes: 2ae1a6cc4302 ("cifsd: fix potential read overflow in ksmbd_vfs_stream_read()")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -303,7 +303,7 @@ static int ksmbd_vfs_stream_read(struct
 		return (int)v_len;
 
 	if (v_len <= *pos) {
-		count = -EINVAL;
+		count = 0;
 		goto free_buf;
 	}
 


