Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622809;
	b=OaMJ1hMJqlHb1up+8Dt47s8B5HNx9fBbaVitYuefoP7qLvnNi6ul5gexRj1E4ayuA2Yo
	 Crs1/3A5NeYqpH6N6x0Eas0LSPtsx+Py5VcDxAJvQL1k3TuAjWOlAGJjrCJp2QrZPDoTz
	 XKKxeIRofJK8oOU++L9FiYVV1cBm3aKBmFgKx3lawOo5wltqdn+PldeJ4QghZps3inHAn
	 N17CJ+PHQCtfJ0anWIs6ODZcoEpsfRgEHymPzqfH/4aHadSPbFUhKKjtLUG6MXo7iSAX5
	 IDHGZ9Sdg4HOkjY3xcoa2HysFF0TiuPOQGbEyspfjKj4Mz/Cdv9E8f4LYcUBKXpiT0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bG4FUDVFA7ZO3HCw7eWK/aRrrXBNzjJo742scxSIZjw=;
	b=aIkEMPHi3TAGTtdqEWsVMDSWvqZhRl+kX0FFj4p62PxLE4SSZXwoWnSc9jG2aeu8yc6T
	 2f5gbH0teOT266n1XjYW2w8mr64mzP6z3UwYlY9z8qZRuWsCXGEihbUxvMCRpFTlgwwxO
	 q7WjL//w/y+9MRFsXexES1c+cS1POtK3cMQK1zI8jYlsIF+j/YHP4pvnHHr3rGRW8eMJr
	 YRGQ0gY7zrhTPA1oyS/Joz8Wt0uNTSqWTQjPrzuYu26Bwazz3biPRDO/n+KOVGOkZe8Z1
	 Rvi731c5jQzuVqvGMsFWNpIK7LRSr+RO6pdqJ6ox8bB9YJV+VJamly9Hq3d65NTxZKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hus8USYu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB96606A33C;
	Wed, 25 Nov 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hus8USYu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3891F000C6;
	Wed, 25 Nov 2026 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622809;
	bh=bG4FUDVFA7ZO3HCw7eWK/aRrrXBNzjJo742scxSIZjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hus8USYu5G27U7N8+UbiNLJM0lq0nnJvNH6AZpKtpp4J+d5nwzfXSouzYWlsESdwH
	 mout1tdHxa580IP0qPql7dqlSiY58Mb8asxC4OyP2GNaGz/NvCinIB1fQHXw6c9FaN
	 ikq7KhHVr4b9wchao7MMcMBzevEaHJfBbEQg95FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 657/990] kprobes: Fix error return and slot leak in __register_kprobe()
Date: Wed, 25 Nov 2026 15:33:44 +0100
Message-ID: <20261125143837.479981888@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 6a658cc2d605e5acf35e638c62f480460d5939cd upstream.

When arm_kprobe() fails in __register_kprobe(), the probe is removed
from kprobe_table and synchronize_rcu() is executed, but the error code
ret was ignored and try_to_optimize_kprobe(p) was executed, returning 0.
Additionally, the instruction slot allocated by prepare_kprobe() was
leaked.

Fix this by releasing the instruction slot via arch_remove_kprobe(p)
and returning ret when arm_kprobe() fails.

Link: https://lore.kernel.org/all/179375030756.247640.10859474201266455798.stgit@devnote2/

Fixes: 587e8e6d640b ("kprobes: Adopt guard() and scoped_guard()")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1631,6 +1631,8 @@ static int __register_kprobe(struct kpro
 		if (ret) {
 			hlist_del_rcu(&p->hlist);
 			synchronize_rcu();
+			arch_remove_kprobe(p);
+			return ret;
 		}
 	}
 


