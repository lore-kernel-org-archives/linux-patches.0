Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625737;
	b=aMEz4HnrhAbfyzxO3Lyaaesi58QCl+VBsFeQ1UWdkiUXU3/B+8Xx2oSDXRQu17U8Hf6b
	 uCnezj0C9wUGceT60lMu7EYVJypiUhNlueCyNhDaNLH9kZgXFJS+rUz3jSXMM5sJsWCc8
	 okJY6GiO5yhYW7Cs1lW1QngTN3qGiY8G3VVNKUNrhwcZb9pA2DL94TG+h/P04m1EqkGLs
	 pP3aCsWAsV+ASZgjR03ZVgBTzTblvl4GU6fjWjfLzosVT1tdheu0/qv1RDEFUxIlY3ZmX
	 COnGBqQB2MxdRdP0na19EIZ5RVDmxREr/oxfUEw0fRMsDu6rj5l0e0o8jWOZ1lYPeqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rv+aVL0gUIlkdFojZPfaEb0CaZJC512gUO72T9uYvGg=;
	b=nWjCV3JJhcwINqDQZwzG6eqbkK7cB/EXrXzmtJu88LeEW1zgAwU4+Vm0qSrxnI9U1wnt
	 3btAtstH+W1LiDh3B4rKl7V4Q8+pSnIFzd24NVfE5qL9LtPLZYsWsgprsWZeEdi5iKv8/
	 C/ry+9WpWOEy5WBcTd5DlW1GGzC9prEVfrtGsF/jJiyZh2JS1PdC5fWcwuP+hnUccibo+
	 Lld53heeoyCOyKHoV5clVbHWXmp8sz99G2jqMChg36ABfMaM0BUaPVHk1BJoyufY82H5h
	 QwnmY2RXKVR7UxRrU4fgoGg8BtDwvl/KPyE3rG1jEtC6md0QK53iDgZABh3oj0dagnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQVI2VT1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7433D606A31E;
	Wed, 25 Nov 2026 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQVI2VT1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF17D1F000C0;
	Wed, 25 Nov 2026 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625737;
	bh=Rv+aVL0gUIlkdFojZPfaEb0CaZJC512gUO72T9uYvGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQVI2VT1HjtwFHfyJiIcyCJQHy6/dyuOgg9Xv2W+uhbYNG28YXeISQp6kUOQdD3dI
	 hmjihObClAf/3eDAhEoFMQ5YAQwuP0y1uycxJFIqMc07VOEgrt9q85V1tdoubYS7My
	 wIUR3N4V5jyXl93cPWp1NA4v8gCAXTKuRwyRQ/ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 617/816] fs/splice: clamp an over-reported write_iter result
Date: Wed, 25 Nov 2026 15:36:05 +0100
Message-ID: <20261125143903.462929086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yongkang <teel4res@gmail.com>

commit 2d956723e82cddae8ff8e9da99a666217b02065f upstream.

iter_file_splice_write() builds a bvec iterator of at most
sd.total_len - left bytes and passes it to ->write_iter().  It then
subtracts the returned length from sd.total_len and walks the pipe
buffers by that length.  A ->write_iter() implementation that reports
more bytes than the iterator held makes sd.total_len underflow and the
dismissal loop advance pipe->tail past pipe->head, releasing a zeroed
pipe buffer:

  Splice Exceeded! ret=7 tot=1 left=0
  Oops: general protection fault
  RIP: 0010:iter_file_splice_write+0xb6f/0x1170

Commit a3de58b12ce0 ("netfs: Fix unbuffered write error handling")
added the warning for this condition but only reports it.  Clamp the
return value to the size of the iterator that was actually handed to
->write_iter(), so the pipe accounting stays consistent even when a
producer violates the iterator contract.

Fixes: 8d0207652cbe ("->splice_write() via ->write_iter()")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314072.648427.13388575162083843840@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/splice.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -744,9 +744,12 @@ iter_file_splice_write(struct pipe_inode
 		sd.pos = kiocb.ki_pos;
 		if (ret <= 0)
 			break;
-		WARN_ONCE(ret > sd.total_len - left,
-			  "Splice Exceeded! ret=%zd tot=%zu left=%zu\n",
-			  ret, sd.total_len, left);
+		if (unlikely(ret > sd.total_len - left)) {
+			WARN_ONCE(1,
+				  "Splice Exceeded! ret=%zd tot=%zu left=%zu\n",
+				  ret, sd.total_len, left);
+			ret = sd.total_len - left;
+		}
 
 		sd.num_spliced += ret;
 		sd.total_len -= ret;


