Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6259D18A6BA;
	Mon, 24 Feb 2025 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408512; cv=none; b=jmx1kIUcVPInHiJyC6k2JUSLeNmXiYIYpmTTJTmgWFWG/KeSo1UH0a9pZ2fS7PEzybwKrsZ5Lu8F3BVdkKGFe2pqEaFBG33rx89OpvJ3pRFpdt7zJBjUeE/nA75pd8fbBiz097OW+QrDEAMSBUCWD5TtBYkv5Q/V2jZmSXQtVuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408512; c=relaxed/simple;
	bh=Ncziw3ojDIUUWFrdLaxk5Eu0o35Xw73ShBNigKvS4IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8h24nEQXVpK4KRCcauaz7WvcPuKs3fiIBxqGghgvyVxC+5gWr3kFYhcEjzmCEbZPdocLUYiUZNIB4kbkxeCMGJry8HiiyKw8TpuYM/G5JqY2Ruqy3EAIlZVqRwTh/U/XiE0g22cBx69Qe5jp7FH//8S9ISYHWn8RdktgC4nnd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7pkUFIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7pkUFIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B620AC4CEE9;
	Mon, 24 Feb 2025 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408512;
	bh=Ncziw3ojDIUUWFrdLaxk5Eu0o35Xw73ShBNigKvS4IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7pkUFIvZ75uRRKpNLFzzdC1ojy2oY5z8SbzjlOTAuYEiU5lMEGmPJupGjNJOZuAE
	 evQc8HmkJhkJJ+p9/fHxurukx3EIbE2Iu121ldMFfyohDTHXxXJJ2ICRhMjAWJcE4V
	 QHMYj1mVs0aONm9ks2pTquX2ALa3Eqw1xcdIWlGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/154] bpf: Disable non stream socket for strparser
Date: Mon, 24 Feb 2025 15:34:38 +0100
Message-ID: <20250224142610.174186149@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 5459cce6bf49e72ee29be21865869c2ac42419f5 ]

Currently, only TCP supports strparser, but sockmap doesn't intercept
non-TCP connections to attach strparser. For example, with UDP, although
the read/write handlers are replaced, strparser is not executed due to
the lack of a read_sock operation.

Furthermore, in udp_bpf_recvmsg(), it checks whether the psock has data,
and if not, it falls back to the native UDP read interface, making
UDP + strparser appear to read correctly. According to its commit history,
this behavior is unexpected.

Moreover, since UDP lacks the concept of streams, we intercept it directly.

Fixes: 1fa1fe8ff161 ("bpf, sockmap: Test shutdown() correctly exits epoll and recv()=0")
Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://patch.msgid.link/20250122100917.49845-4-mrpre@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2f1be9baad057..82a14f131d00c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -303,7 +303,10 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
-		ret = sk_psock_init_strp(sk, psock);
+		if (sk_is_tcp(sk))
+			ret = sk_psock_init_strp(sk, psock);
+		else
+			ret = -EOPNOTSUPP;
 		if (ret) {
 			write_unlock_bh(&sk->sk_callback_lock);
 			sk_psock_put(sk, psock);
-- 
2.39.5



