Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623086;
	b=kAA9g/7hip1T7IAeZnZYHWIWTrNIEBYxbbL+SnnKvbl144SqaLQb9r1n1sW8bf7k3A8j
	 teeCaL6wT2ymTVadh67dPDpuUVIvdQTWcWB74POozh9GtWsx38SxEFh7J7rmL4ASkJxH2
	 IobAb+EwBKU3a20vmceSyaddzB2XJVFhMhXCilXpQuWKWAkUYzEJ8pqo+6fEuqtfHYyj6
	 xe4B1ReyWJBOIleJ5+MvYrTtI2oEP3p4Kl0WoIr70jjlQ/J6F1WloEtZDor25uMThDqeR
	 0DkUUsYmmq1K1VBmIBrY/U8NLCC61hbR5xJb0e78mXwUMwI/8cJ1nJgc2GK8EEVEpqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u3k+f4S4vQFstRA7vDe/yV+8TxOqHXoO/LKWfPEWLMs=;
	b=qs1bgj5EsDBtSvHGDHvxpVYNLq4/iKz8NBszNDSuHjtSqCZr9oUIBZ9Pzh8E0mf3pf0K
	 LRSzW0z2gSyFAI/QcygyTfKENb7sywhQeBepr6u1leX5JVqrEVsnzEo2ubmnxwR9D5nYP
	 YOT+n2O/khg8O2x0TyjKQH+pkgoZ6xDHSk8Uu/4QDB+HY0/cfm24Cxqed3bRsj3QIvrr6
	 zDxlRkJXCI0+Hz5uKz0tMCNarxDznkdJ9apY4Yrs3PAO2dx6vsX65xqdmkbV6GzB1VQz5
	 Y9BORGm1w75bO7+oiO7sD96P2NbjMhv6py9E8UUCQZ2vYYp/tyer+Fgh5AgzewlrXFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bh7CK6uO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3DE606A326;
	Wed, 25 Nov 2026 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bh7CK6uO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16571F000C4;
	Wed, 25 Nov 2026 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623086;
	bh=u3k+f4S4vQFstRA7vDe/yV+8TxOqHXoO/LKWfPEWLMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bh7CK6uObKr4e2mbevZo+rbVNu5GEQZGhKx2jXr5OqgRaHHQknF0sEYetFJc7suNU
	 K1q+oROswa8FgUCtdzLPue1oYayhLQGMB1GWpjvlkb4cjJn+0JKxO/YhMIUyBx+7fr
	 xfBDnB2cJ4wBX9hr+TUVxd1xysP2tTwEBRfARmI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 747/990] fs/splice: clamp an over-reported write_iter result
Date: Wed, 25 Nov 2026 15:35:14 +0100
Message-ID: <20261125143839.559843537@linuxfoundation.org>
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
@@ -739,9 +739,12 @@ iter_file_splice_write(struct pipe_inode
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


