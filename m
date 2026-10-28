Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207179;
	b=CUv7OJcelhq2TCxzjgtIAmcCtANuQ+dyvJlmpTlnkoVcgl8aX7vkiAB9e5NeYx1vgd1j
	 zC2f1qJhNo/O7J4Hs4YiVJWbApoCWzgL9V4ou2CA/EKQ8kjtLJPubM0DMSUboxW3q5j4g
	 l/HZxXPqo61CbpV75ucmYpNfWZhfjpBzQo9i7dT5XKZIvEKpHCUj72HH01MDGPpJI5eYd
	 pGNJOEJEXDOgI6JyW04qb0tr5EyZydsxaYLdAEk/2xyeuVv+MczKTffi52MyVCNQ6H33y
	 yng87+viAP85hKR7KmdloCbLbwFqMA/hDFgiwzOQfTVjaQT9CW1IfB9r1km2u08WmmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UeKxag1gzXJ7oJgS91tdeG3gh3pO1LUYxYvCZyzQHIg=;
	b=j+8ZfFkbHxws5jgkL65LtVgjF1AmOE9ja6cKKPUjZdNoM8dv1wcB9P1clYTiQwqxQ+90
	 aNnPO12+LdZI5hH73NZmP3iFCsNJ/SawnZaYHEq5S2KmDZ9/S6x9QIV+U8wwnguUfQrrD
	 s9ijT5Ypo/0Ahkmlb6PM0BtX5shWKliK3F1V7JNtiOkSh1qyYGKmz4HxlK1K2Igzk2wth
	 YM3TRClXLPL+AlnDHFaOI68QeF0KEjbLP5Lz6M5SzYNM15+bbjKYwCSnZnlPE2FsLMV3i
	 s2FaBSO6pnSQ/7okwSBIVmdUcb/OLDojum+4Qgw27irQCr3gxH31aKi1OUR5YN0GwXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5AmqMAp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE846606A31A;
	Wed, 28 Oct 2026 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5AmqMAp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB641F01829;
	Wed, 28 Oct 2026 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207178;
	bh=UeKxag1gzXJ7oJgS91tdeG3gh3pO1LUYxYvCZyzQHIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5AmqMApubNPsMn8K0aqP20uVXdZMZnBVxMZBLYxLlHOngGaMImF2yz1U4ZbmGF3Y
	 fbFcNqAZAiaDW6WFEmGMaLh4PQpiqXGn0keLptOVohfv0uN4w9ND8BLKTY0vuGBU9D
	 ZJDBX14Esx9NrAbhIjHlLA7tSPsTMLpiq/wNIXZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Wang <haoranwangsec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 15/88] tracing/syscalls: Use copy_from_user for the faultable syscall buffer
Date: Wed, 28 Oct 2026 17:59:23 +0100
Message-ID: <20261028165942.474744056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -682,7 +682,7 @@ static int syscall_copy_user_array(char
 
 	for (int i = 0; i < args->uargs; i++, buf += SYSCALL_FAULT_ARG_SZ) {
 		ptr = (char __user *)args->ptr_array[i];
-		ret = __copy_from_user(buf, ptr, size);
+		ret = copy_from_user(buf, ptr, size);
 		args->read[i] = ret ? -1 : size;
 	}
 	return 0;


