Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022802;
	b=x/A1y8pKjIQYDEC1Q1Jfin86wDAqLOMX8ycqbvgx6lXHgpBFTTfqg7z81uy+AZWH35vj
	 U8LObeXvbNQFebJpoVbfrAH2t66vbmP+ixyc5C79SSv1kcJotxkoduunSl2euHkeZ6KKS
	 T7w4ZRpDIbzGijYkN3dfvC1Tzryc+dyqA0Sn0bHlryJzE7fGRjKPCc+WlfSQ5C79J0afK
	 nbOoXZx+yrXKz4ScCBMaFFMoUUtLnwXku5eZ825g63tGehzAMxiwogTJ/crs2OxGT6Tcs
	 enwOm5nr5huGzYsk50NIiv015HWH12ftIuzmV27EwGiQO+t19c7/Cj30woxnhIPWEZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oMZXCYgTvjlcSYYJ5+9Nah6oHz6bF3f+fbrQgccqRFg=;
	b=lKUHZmd4VRf7mpCbGox9JEiGc6TrGq4yAn3WyIsHqdrYTigNhyqUz76Qrn29LksScj8q
	 lb4VTxEy8To7rBJ4f9kvJPtfqD0m29Wd7V/ifk5jHm+lTihhf7QH69m/3t4NoQG7+IGkL
	 qIKrdokIh3MSK+BFuOQ4X7rD4KLjl0NQs1b5g+az2FrdIfw2UhCwDaf04/OQ3gDNGCWqO
	 gquSq1Gf/TL3XKGLNhXyK7QShgIzJQDLWN87S7qek+/IUIeawL0L6LEC3bcH0sgXFjIvO
	 GOE9GGTmjKgWwJfdV7p/WApVeVbHIY/QMQuUin6UilDCQOof3ZJPYPzxYinlj1q0D2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wyB+tnP/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0B606A743;
	Wed, 18 Nov 2026 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyB+tnP/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98BA1F000C5;
	Wed, 18 Nov 2026 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022802;
	bh=oMZXCYgTvjlcSYYJ5+9Nah6oHz6bF3f+fbrQgccqRFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyB+tnP/vR7rMMnERnZ3UBgVDDoL/YlqyEd6TQt7nyfFmHtFizDf0QLkE3u+zguD0
	 x+HhaOahEEGy2yObdt8n9mqbLVL3yaDurEI3VA/E/qf5O+7aNm3UoJlZT8Ox1zEOCE
	 Uop+6ELrl+1ig7+VMLgKSv+V1lc6dd3LMEp8LU2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0136/2151] bpf: Fix stream capacity leak in staging path
Date: Wed, 18 Nov 2026 15:31:11 +0100
Message-ID: <20261118150126.742688159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jianlin Shi <shijianlin11@foxmail.com>

[ Upstream commit effa6370ba89e7839c9bfeb802d8f05d6843ddf1 ]

bpf_stream_stage_printk() increments ss->len before pushing the
formatted string to the staging log. If element allocation fails,
ss->len remains inflated and bpf_stream_stage_commit() permanently
charges the stream capacity for data that was never queued.

Only account the string length after a successful push, and use
vscnprintf() so the staged length is the truncated payload without
the trailing NUL.

Fixes: 5ab154f1463a ("bpf: Introduce BPF standard streams")
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Link: https://lore.kernel.org/r/46898fb1ae482b2f8b1da459922b187378dfdc1d.1787492521.git.shijianlin11@foxmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stream.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index d2889e54e748b..612f4a7954f4d 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -441,17 +441,18 @@ int bpf_stream_stage_printk(struct bpf_stream_stage *ss, const char *fmt, ...)
 {
 	struct bpf_bprintf_buffers *buf;
 	va_list args;
-	int ret;
+	int len, ret;
 
 	if (bpf_try_get_buffers(&buf))
 		return -EBUSY;
 
 	va_start(args, fmt);
-	ret = vsnprintf(buf->buf, ARRAY_SIZE(buf->buf), fmt, args);
+	len = vscnprintf(buf->buf, ARRAY_SIZE(buf->buf), fmt, args);
 	va_end(args);
-	ss->len += ret;
 	/* Exclude NULL byte during push. */
-	ret = __bpf_stream_push_str(&ss->log, buf->buf, ret);
+	ret = __bpf_stream_push_str(&ss->log, buf->buf, len);
+	if (!ret)
+		ss->len += len;
 	bpf_put_buffers();
 	return ret;
 }
-- 
2.53.0



