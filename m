Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827002;
	b=xmIeP2rMbOYEoCPWoJcsIpf/cTRU+5ovo/ZuV6PORc7kWgxf//MDfcrZkit/z/Wzd7w6
	 RJvCzOAMs/ko2jU5KF73NbMoOGU6jcQz7A27vEM/2hmQIEFQSU6vXIu6xd2iRRyV9UDHo
	 hPMcu8LheY5zcTfE5/37ogC0/YCFfmMCLs7B/OYe+2ytagrWkdMbGYYDHhS6CMGjIm7rt
	 XR/q2+jcdCDK+5J+gkv98DlV/r1EuC7ohlrvOIiHj48A4S8msPPNefO925OiifTu0jLu/
	 pc7h0BRoFUY0F0mbeEwjngpe/1djE9CZtnY3laIzIT9Uy0lS8eEpbH1ffMb7d705qnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KnhIWLHRH8ILrrCUFIcukGCvjuIjlnwZJ+4TwtLl0xU=;
	b=UlvwxjDNcZLYlJ0rhgvMtrJXEEzdtEP7hG6f5leFTnGb2RHk5Cs1pXuTVrfLUqw4dUFr
	 gO+BL29lpb4Wj58o/Hor5Z2i/ZUXgd8yRBOHisoCHYv8p3DzAeGYUATskeLUlAW1b86ua
	 IjAiIU3dj7rb3b2ZTF0dsunksv0XGgFMQQLJbtYmqfVdtLnJbK55cqR4Vn+SP96EaNltC
	 vp2ovPM7I+A/dXwfebKMQLHCN49x7iiVvzqBN8DhUq+BDa5LGrsMrNqZrjI7B6VOeXRqP
	 8R7Idc9gtD9V5H7ZyoYC4KjKHEq8z+BtnPn2Yj3txsnrDhNwGU2NbHz6PB6o1tiX6PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adMPZiOA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA196086624;
	Wed,  4 Nov 2026 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adMPZiOA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CA31F000C1;
	Wed,  4 Nov 2026 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827002;
	bh=KnhIWLHRH8ILrrCUFIcukGCvjuIjlnwZJ+4TwtLl0xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adMPZiOA5XPNIZvMy4yL/eBWby8sB0M7Yz6aD6FjSzuD2+FDLKagmXUwZC71rFvzm
	 EyTilkFUbWwxBxQLYUEGUF7xX2Gmfn6giopBdq9eVWRDStR1B3lth5RsMxboykdtYX
	 qgd/MQmUmuRhX8UabXfCKkeawahlis/0m2dwgRQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 133/547] ksmbd: return end of file for reads past a named streams data
Date: Wed,  4 Nov 2026 16:05:17 -0500
Message-ID: <20261104211041.953818612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -272,7 +272,7 @@ static int ksmbd_vfs_stream_read(struct
 		return (int)v_len;
 
 	if (v_len <= *pos) {
-		count = -EINVAL;
+		count = 0;
 		goto free_buf;
 	}
 


