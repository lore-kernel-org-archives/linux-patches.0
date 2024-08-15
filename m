Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A27914AD0A;
	Thu, 15 Aug 2024 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732062; cv=none; b=QXEfafL8/s18y8R58vjQ/LyEfSjI6aY/aeng6b61Ev5N2Dz6j5uLSLYUlbW6+NB23xyiZqgOwmos+fUTl1gwAf/diMgCqbGvwnomLHx7xsrrrqGZ+H62Fr9/0dHLuMm7SxXgvM9UY4r2Uw6Z6wktfbXy6ysHcyqBOQpxvsXI+N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732062; c=relaxed/simple;
	bh=B7SeswzibBg6MzelrBlBdw/9SZ6zR1OTGPyZ1gJ43wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsF7WVwyqKti7+q07kNaIgjxQU9GUSRZrtZUYo3/QMekjWtuGu0DHFaZccH0ojKdEEwBNy2AJQa0eeqCA88uQzQwtajg6e/ex4hSsu95B2rVPZqyRtIH3eGsc9IJyqXJzNay/eXKzHJNl1kQO0dE0Vvd3Tkz4AAOv5HM7rCYpHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1ltv6TL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1ltv6TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59205C32786;
	Thu, 15 Aug 2024 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732061;
	bh=B7SeswzibBg6MzelrBlBdw/9SZ6zR1OTGPyZ1gJ43wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1ltv6TL00WEK7H4zROa1Wb8rDag0+61U2+IScVe0T6SVMaq6mREkC73R29YIAQMW
	 WIwyulCAaFW2CYWaHRufCTd0T4lieitadhxz773pJEhLh7QRf/dlGXuW9k8nLbXeGC
	 SnDEeiD8icIK6cD910QGx36FYx9z/3YtGshLei7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/352] bpf: Eliminate remaining "make W=1" warnings in kernel/bpf/btf.o
Date: Thu, 15 Aug 2024 15:22:09 +0200
Message-ID: <20240815131921.679068450@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 2454075f8e2915cebbe52a1195631bc7efe2b7e1 ]

As reported by Mirsad [1] we still see format warnings in kernel/bpf/btf.o
at W=1 warning level:

  CC      kernel/bpf/btf.o
./kernel/bpf/btf.c: In function ‘btf_type_seq_show_flags’:
./kernel/bpf/btf.c:7553:21: warning: assignment left-hand side might be a candidate for a format attribute [-Wsuggest-attribute=format]
 7553 |         sseq.showfn = btf_seq_show;
      |                     ^
./kernel/bpf/btf.c: In function ‘btf_type_snprintf_show’:
./kernel/bpf/btf.c:7604:31: warning: assignment left-hand side might be a candidate for a format attribute [-Wsuggest-attribute=format]
 7604 |         ssnprintf.show.showfn = btf_snprintf_show;
      |                               ^

Combined with CONFIG_WERROR=y these can halt the build.

The fix (annotating the structure field with __printf())
suggested by Mirsad resolves these. Apologies I missed this last time.
No other W=1 warnings were observed in kernel/bpf after this fix.

[1] https://lore.kernel.org/bpf/92c9d047-f058-400c-9c7d-81d4dc1ef71b@gmail.com/

Fixes: b3470da314fd ("bpf: annotate BTF show functions with __printf")
Reported-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Suggested-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240712092859.1390960-1-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 326feb2301700..cfbb038d150c4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -340,7 +340,7 @@ static const char *btf_type_str(const struct btf_type *t)
 struct btf_show {
 	u64 flags;
 	void *target;	/* target of show operation (seq file, buffer) */
-	void (*showfn)(struct btf_show *show, const char *fmt, va_list args);
+	__printf(2, 0) void (*showfn)(struct btf_show *show, const char *fmt, va_list args);
 	const struct btf *btf;
 	/* below are used during iteration */
 	struct {
-- 
2.43.0



