Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617870;
	b=fLZ9OT5x//qQ2+MkPlkeojh8XD5uKAGEqBiadNNpLVGjCQ0JafrTm+7UwaqCWZbWunvK
	 sEhgC2K+4YmiR+TH0oEBX4grTDFDY9f3izSyG7Kl4nSyYsj9lFefMSWxUW44vVz5C3lz9
	 JrMmsq1OlsB+5T62StHwakrTopAV2kyqjn5hJwKieqW2xAyzxcho+XnmURr31ZqA2ceKX
	 RE4TmjxERU59+sjDyHRHV6dHQK20taxJp+ILcEaYndWT6fseRDNjEgAzy0r0whv5G3J62
	 OURXAj7qf9vhcWWg+lAvHBJzEx6L+t+7Ye8QwANqrohP/w7izkWSabagBf0wJQGS54Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bTIUG2ykpPB+bR54cW726l2e9uACKZLwUuqhros4AZg=;
	b=W+jMpmsim236MJc8+cGAM07HGO3yoJgfjIkDKHMI5PBNGnHOHHQ6UnV+101B4UdXtsTO
	 BA8pdzv+DlV3Cp6eFFSmmPZrEEjY6/gnF4YpbOYThYcWHufSDT1ZHZyJawT4xJkzcfqXo
	 6bYYbgNpurIBXb/Nmd5hddRPID37/37F8igoMJyJ9KtR/5VQXswJEo7NW6SXDOMdVfmwM
	 TwfC6k8fWul3v/bZ1qq07s/3oF8y78r8YluP7XIp6q+8GR3IzL+icyzfGrTO/devXn37X
	 0Oo+wQAs2yKxgd36aC7QzZ3/CxOB9lUuhJ9lYTxb37tfRU0n1eDUGOwOkwcpG1JYS9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btg5AcqW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554D1606A31E;
	Wed, 25 Nov 2026 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btg5AcqW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210551F000C0;
	Wed, 25 Nov 2026 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617869;
	bh=bTIUG2ykpPB+bR54cW726l2e9uACKZLwUuqhros4AZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btg5AcqWf+HuxFDDxbSjij40bydC+Y8zHFK+NHHtGAoXekzNzWAUhbnT14fTQjyFF
	 6PqN4E/zmZNmNG37s3jYrYyW3aB2l8pVKgoJzIfmA4yzV3qzonWi1HsfzflmxpQWHM
	 AQ/CT2NSJrhJgwz6xqGGNMNKekNyH99MyU00K/VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0100/1005] bpf: Refuse to map an arena at address 0
Date: Wed, 25 Nov 2026 15:23:58 +0100
Message-ID: <20261125143824.088387448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit ca580b034380fa9a69cc973637d1859ec4f5b344 ]

The first mmap() of an arena sets user_vm_start and user_vm_end. Each
subsequent mmap() must use the same range. The value 0 in user_vm_start
means that the range is not set, but a mapping can start at address 0. Then
arena_map_mmap() does not check vm_start and sets user_vm_start again. The
range tree counts pages from user_vm_start. With a new user_vm_start it
reports allocated pages as free, and apply_range_set_cb() fails with
-EBUSY.

An arena at address 0 is not useful, because the verifier rejects all progs
that refer to it. Return -EINVAL from arena_get_unmapped_area(). It runs
before mmap() removes the old mappings in the range.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-4-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 868589f073301..a10981be21fe6 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -650,6 +650,9 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 	ret = mm_get_unmapped_area(filp, addr, len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
+	if (!ret)
+		/* user_vm_start == 0 means that the user range is not set yet */
+		return -EINVAL;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
 		return ret;
 	if (WARN_ON_ONCE(arena->user_vm_start))
-- 
2.53.0



