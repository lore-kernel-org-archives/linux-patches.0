Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625883;
	b=M8b1zoan+SpdZxztnG0f1WN3pqvgYg652rZgC5WnI/wHXF631+lqBtGEWu+5rLA6b5uU
	 JmC3anzCjJaPIwNjFBh1di5Dnr3RfK7C8cYpzfp5/old6wf9bLSrAtoq84LxA/Ip0YYdj
	 Hyt5dN6/8uRq+C0ExUfmHYEu7iQkZYh5NO/+FU3TqiK+j0jbk3bGIQEpTX2LrmhvKXVk6
	 wWoM+YWrnU0QXVDg/5a9SNWoFasLRdyYnnypgRcbDN3ETjPZUqLzH/7t/9NTs4fN6ZnDD
	 ZNDgvxzwX7M1uou6q9Ezy7w1DUZDx1tiGPP1UR1TGLIpS6m30UBFsD/uIe3GRuiRUPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OXO9ms6dNztFj8At+v4irJzxaX7QMsuokc7Gpvq4LDY=;
	b=pS3JbKfDPFaU+aRI9uyoDto4whiLVIcVQh5T8XepsZMsLUx+gopHtFo2X9kCEFLAnA8Z
	 e/6oCrKODbyqpZl/OJr9JFoZkk/05rIak59F7T6+qHBD74rn7t5ucUWRzaQeUas2LtG7x
	 pXfbZaamsVgGiy3gJIPiQtOX5zsMRpMRwNCCIo4ju1Pp07P6+Zi+J6bmTAWesbJ2UxXWA
	 QmRFIzPvgp4oMBs1k7pG7wDsSp7QeMW4etOugjpgF5PA4dAYWTBwSYwauX9/llI/TC6yx
	 Iyxh4toUw3/sSdX5mLYXcPJ1Vu6tX1Eu6ahO2iL4CZntbRFn1QVFtkkFwHeIY+ImNVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9ldH0qZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39730606A31E;
	Wed, 25 Nov 2026 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9ldH0qZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0201F000C4;
	Wed, 25 Nov 2026 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625882;
	bh=OXO9ms6dNztFj8At+v4irJzxaX7QMsuokc7Gpvq4LDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u9ldH0qZxnWtAHB6U9EgGEf+JrewujeXXf1+/PpLoQkvT6mD3Pc8beimxAgOIVnM4
	 LWihKGoYMWSkh6s0X+9MIKYSCfisABX0w/sWKHr1IWfjhAI42EIte8ulgCY740jZsr
	 P0dQKJWEDwhsJKMOBd0O7ei+f5sdSUfGLLsPD32M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 616/816] fs/proc: fix the write length returned by proc_sys_call_handler()
Date: Wed, 25 Nov 2026 15:36:04 +0100
Message-ID: <20261125143903.440076277@linuxfoundation.org>
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

commit fbdc020ee1b82079102e493aaa7200de5f497a38 upstream.

proc_sys_call_handler() reads the write length from iov_iter_count() and
copies that many bytes from the iterator into kbuf.  A cgroup/sysctl BPF
program can replace the new value through bpf_sysctl_set_new_value() and
update count to the length of the replacement value.  The handler then
returns that adjusted count as the number of bytes written, even though
the iterator originally held a different number of bytes.

If the replacement value is longer than the original input, ->write_iter()
reports more bytes than the iterator held.  splice(2) passes that value to
iter_file_splice_write(), which subtracts it from the pipe length and
walks past the pipe head:

  Splice Exceeded! ret=7 tot=1 left=0
  Oops: general protection fault
  RIP: 0010:iter_file_splice_write+0xb6f/0x1170

The write path consumes at most the original iterator length in
copy_from_iter_full() before the BPF hook runs.  Return the smaller of the
adjusted and original counts on the write path, so an expanded BPF value
cannot exceed the iterator while a handler that reports a shorter parsed
length still produces a short write.  The read path keeps using the
adjusted count for copy_to_iter().

Fixes: 4e63acdff864 ("bpf: Introduce bpf_sysctl_{get,set}_new_value helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314073.648427.7892850166511253762@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -552,6 +552,8 @@ static ssize_t proc_sys_call_handler(str
 	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	size_t count = iov_iter_count(iter);
+	/* ->write_iter() must never report more than the iterator held */
+	size_t orig_count = count;
 	char *kbuf;
 	ssize_t error;
 
@@ -602,7 +604,8 @@ static ssize_t proc_sys_call_handler(str
 			goto out_free_buf;
 	}
 
-	error = count;
+	/* the write path consumed at most the original iterator length */
+	error = write ? min(count, orig_count) : count;
 out_free_buf:
 	kvfree(kbuf);
 out:


