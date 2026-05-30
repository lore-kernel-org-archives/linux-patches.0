Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115DC3403F3;
	Sat, 30 May 2026 17:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162137; cv=none; b=DgXkaLStVsn0E4EZNoM5pN39Dx8jwPGv4gWg7+3KVneVKsBcaZW4GOzkwtWZ/HJtuTAzIYizslsCAlDi4yHXokQ7HPqjiM9kQ7BMaOVLLnEoZGX5tzlWarZYxFwSe2xnzjvnREqaz45F9RV1FG/y8CUmP8L3kjZ0VJ1dVkfnUXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162137; c=relaxed/simple;
	bh=icMydOISxPH4KfliTySnjkIzebO1wnxtNM8Yev/hAWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDObu6GNOy2AB479s98nKTpyc6IPSDkZnBmqce2EwV5GO8caJcrxcAJVK/tjtCi4bKimtTl6N6FIFr2gRgDYSqUixi6c/NsF3IeIJ2bS8nVnOCGd0WDkctg13lR6ff22oHHAQNBFV2l1BjNtyITQcmsSd+j8vx60YO+f9ohvNHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9IeFUhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9IeFUhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5649D1F00893;
	Sat, 30 May 2026 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162136;
	bh=jYG/M6Im/JtwRr6X7cOE7jqGcbEfSTmmpUbDTXXL46g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9IeFUhxxM+ixraEx75UPWdG9+EjWHh7ZsUg5N9htsHSv4+HLiZXkgn3BHyiZ9M6T
	 5XW4Lh9nEeKp2M/KU+BnyLHbrkL+P+tILT4RgJKKa27MO1rCplT12zZtvd1Myls75p
	 li2CDTmmardrNIXbFOrcYKKGaLYzQNnyRjl2q45U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Gustavo Luiz Duarte <gustavold@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 802/969] netconsole: avoid out-of-bounds access on empty string in trim_newline()
Date: Sat, 30 May 2026 18:05:26 +0200
Message-ID: <20260530160322.775333419@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 7079c8c13f2d33992bc846240517d88f4ab07781 ]

trim_newline() unconditionally dereferences s[len - 1] after computing
len = strnlen(s, maxlen). When the string is empty, len is 0 and the
expression underflows to s[(size_t)-1], reading (and potentially
writing) one byte before the buffer.

The two callers feed trim_newline() with the result of strscpy() from
configfs store callbacks (dev_name_store, userdatum_value_store).
configfs guarantees count >= 1 reaches the callback, but the byte
itself can be NUL: a userspace write(fd, "\0", 1) leaves the
destination empty after strscpy() and triggers the underflow. The OOB
write only fires if the adjacent byte happens to be '\n', so this is
not a security issue, but the access is undefined behaviour either way.

This pattern is commonly flagged by LLM-based code reviewers. While it
is not a security fix, the underlying access is undefined behaviour and
the change is small and self-contained, so it is a reasonable candidate
for the stable trees.

Guard the dereference on a non-zero length.

Fixes: ae001dc67907 ("net: netconsole: move newline trimming to function")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Gustavo Luiz Duarte <gustavold@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260420-netcons_trim_newline-v1-1-dc35889aeedf@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index d150287c01a7d..988a8a0a67003 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -246,6 +246,8 @@ static void trim_newline(char *s, size_t maxlen)
 	size_t len;
 
 	len = strnlen(s, maxlen);
+	if (!len)
+		return;
 	if (s[len - 1] == '\n')
 		s[len - 1] = '\0';
 }
-- 
2.53.0



