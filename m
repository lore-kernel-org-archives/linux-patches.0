Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015201;
	b=rKMfGwNUc1ThsNT7B7FYTXr0ECxklBoB0qnXfQt4diXWQTbTmHtQOO8PPFBdq227SmBP
	 uZbIM1/e0MgwV1nucicuN5dQevrmmMSq/YwF9UcYj3PtKnzF57JkWjAYexKde1baDhQ73
	 P2hMSOct57JNyMN2uzO0mdURzuNaGS5IP3Epy2ksmG4rzs0h/tlHWE0sPFLqdTLbnLOZ2
	 oFttA4i6z8tRDm5tP4oWcZLVsBlKzP4QI9uYM+tOOrNTgUMN0mT/eEcr0gLQcbg9R6HBA
	 WEufFJZj0Ykcv/DlmsvxWDOwfMKKFZiFIywIV5oyW88rMKuaVfnbK5t4RiN0MBua43g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CWcq6DdgdmgwpMpadQsORabwewbZ5BgKFAe0s93BV+I=;
	b=yXWYyvC6bFg51IguJPQDMvHFK/ZtAG+4gnk6qoL7y7n6E3SEcUQe2OIMS5qmLBLpqqwd
	 3iy1RAU/6bF96qLKj5Kux4f9Yq3esJDuHGHreo64/ygWqjt41toyOpS9IHLY/J0QB3J32
	 SivkoLxCa/koZAT2hMJMqF+QRyCUXO1k/gbjaN3RaufaT7FoxDDb9K0nZbhzleLBQToO0
	 7wSKVgwWL2RAhDR+ZZ5JJu0Slk8JH6h3UWngDizU6qGZX9FuajGF4CotuquPtM92v2xrn
	 MmoLdbe2GUHFsElDYXa7/vEG12On0FPb73FZX3MD9YTKXnzK+2438hf1RAQ5G8exkMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCpOxyu1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62B460A260B;
	Wed, 18 Nov 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCpOxyu1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141E91F000C4;
	Wed, 18 Nov 2026 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015201;
	bh=CWcq6DdgdmgwpMpadQsORabwewbZ5BgKFAe0s93BV+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCpOxyu1agOHhnCx1G0yHzWO1j67AmBjDUdS5i4IG5KbPikaWRY4phbCaU2I4/Gs7
	 QBmABC4u4cCE5aEeueHCThtJbPeeQhSqoA8RoOG4z3B2pDcmYrNgN3ip2PhnCwyVdA
	 NsFZtPWoi7XaE60/KY3tyqobgyakMwoy6br9JXWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0072/2651] bpf: Fix stream capacity leak in staging path
Date: Wed, 18 Nov 2026 15:21:52 +0100
Message-ID: <20261118150250.529072457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 0b157ec4e38eb..a36fc93389677 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -316,17 +316,18 @@ int bpf_stream_stage_printk(struct bpf_stream_stage *ss, const char *fmt, ...)
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



