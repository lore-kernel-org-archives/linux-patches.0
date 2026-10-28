Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207063;
	b=M+W55zhNWwXM5OB8JHZMJDqkZGVoSZsJp0JFtv2D1pBQa683EpYjzQ2nnwqhKCqtH9mH
	 wh965eQnNwwLuF49s35YEr8PhmMGqwiCZ1lY8uECKMz/xypHRTUVtDOTyzCwBf4kloiIE
	 v1I5oeou839OHSHGrFdkyIgYX/h2QPhlJbiL9QHGhVHGt/7iDr/5dxmhtBBrPC4OLl24Z
	 GdrpeS4plhMvlXu5we8hxceRE2eadBh9iRWm4k85dobgS+odEVCK3tv6m/slnZq6M2K49
	 t4q4L0RKv1Prz58xk6xmgcH0dMUr6D0vFeKBo6xLVXW75mk36U659GpeAQsfUMebVMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3uImfBZCmF5cJxFRRpeUzTjk6Fzpi7ltwkXGqIWb6NE=;
	b=Yk+i5DQGLRAN6arz1+PU2w0GzRpfHS27GQQhdQOTjeKq8KiPX3juxXcTiQ+zpm3kW4K6
	 2lygATtHeH7vaB0ZRQ8Lz1AWyeVMiTFL2uBD9WM6QnOebbriuatM21lxiRhXuQbYCuUJv
	 tZ+GvXclYH68frGMq3SN48DD5TrcwHTcUiDV6LCz8QcCZRhZx8+kVRRpIC1AOggRV9iPw
	 CAxKz+HwWGcaO6FrH8SO0/dyNN4dy9JknVXQ5ZB2oRXkCVwZ9A/GMsXzR8auD0G5uH7pp
	 ds+CLk/j4+vQDtG+/Wk+OghqjLItNzG8720Ok47OHBJji9yptCT4c9n64iPr1B8HSpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgJDpl+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3BC606A31A;
	Wed, 28 Oct 2026 17:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgJDpl+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97B41F01825;
	Wed, 28 Oct 2026 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207062;
	bh=3uImfBZCmF5cJxFRRpeUzTjk6Fzpi7ltwkXGqIWb6NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgJDpl+AiQR5CnI6Zv1Lc2qEuIlIck6wYrPvysgC2XgMBSQslGZl9DpI+wz7OqwSs
	 XplzJEAY9jS28xZQZmXaQujnOIZlpMinwq2vce5fBQ4dXm8b2ltWhnaNhiw6dWHzFt
	 lAuUrMKG0m6oARyVELQ4/rMj/iKyPrXNXlQqCHGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Wang <haoranwangsec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 13/38] tracing/syscalls: Use copy_from_user for the faultable syscall buffer
Date: Wed, 28 Oct 2026 18:00:00 +0100
Message-ID: <20261028165940.736219865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

From: Haoran Wang <haoranwangsec@gmail.com>

commit 097fd0050089df17b032f2b852b9b65e548e342a upstream.

syscall_copy_user_array() copies the buffer argument of faultable
syscalls (write, pwrite64, ...) with __copy_from_user(), which skips
access_ok(). Use copy_from_user() instead so a non-user address is
rejected and the entry is recorded as faulted.

It could be a security concern for machines that trust perf a bit too
much.

Cc: stable@vger.kernel.org
Fixes: baa031b7bd2ce ("tracing: Allow syscall trace events to read more than one user parameter")
Link: https://patch.msgid.link/6ad19afd.a938ce27.16851e.3440@mx.google.com
Signed-off-by: Haoran Wang <haoranwangsec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_syscalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -683,7 +683,7 @@ static int syscall_copy_user_array(char
 
 	for (int i = 0; i < args->uargs; i++, buf += SYSCALL_FAULT_ARG_SZ) {
 		ptr = (char __user *)args->ptr_array[i];
-		ret = __copy_from_user(buf, ptr, size);
+		ret = copy_from_user(buf, ptr, size);
 		args->read[i] = ret ? -1 : size;
 	}
 	return 0;


