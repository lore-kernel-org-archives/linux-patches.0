Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054641;
	b=saiknu7A9iBg/jTy5QrslNCPmpP1bK8HK5gbWOoBVEaVNCzhpuL01mi0TcltTX/6MFMV
	 eq8sBQJsSxH1a6JTIWuDLK475+uAXXc+/jHLejrZK6mXYvM+EUGyd7jgj7FzqRteqLYhi
	 vHcAZb3COIQJOoyWfdI0LovQ7QFhGejKG+0niBTYyDRdcyilMOA2sByDsgCn+qZLMNUWI
	 l8o9eBEPESpeOPNjDs5p3JRY1dZoi1El52J9CgBs844dnswKk10LDBd9MooVoevp9rBUK
	 oyX01xXBF54FrrbR4N7VYxQVahkhxv+mLJHOomeuLBvdnYR7SlonWrMjstFgf7AOAIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tCo1wVWeUGqMjfA6Z9ykkkxYXJpLTKLyPkFk/LL+LVA=;
	b=qCwewJu/IMO0JJwAQTnSDvbGSLjW0jjE2CCPXxBZXcgmjXBxqsTeVe80pI/gHTvBctf/
	 g6Y1t/2XMEjBnecEALKv78Z4mIjgogMBro5Sobw8/RPJ3Z3SJba+90RQ97vm8/5Jvngm3
	 kRnRZ0iYGNsZ2acv8QKfh8cXbsTjEBqYhzUDKUFlkIN8W/HBKtx8GC8iMjryfN8MqOzoY
	 zjvu7gE87VPePiH4HXtT5JcxMEF2H8awlLCDzse79Ub74iBFda+Z0/OY2hfUEh/cgfi0S
	 Bf4UplGdj2LMZbuxDAZ2bI90zD7sXofhrimKsjp4i8yAkTpij3lFeAYB7Ak8Zps7bHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+gOoBme;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA60606A31C;
	Thu, 19 Nov 2026 02:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+gOoBme
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19CD1F000C4;
	Thu, 19 Nov 2026 02:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054641;
	bh=tCo1wVWeUGqMjfA6Z9ykkkxYXJpLTKLyPkFk/LL+LVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+gOoBme7rG73zfUTMaCcATca4aw1OVhFOsvUcc8DCkRc73jHYzYJNB+JSDk+XRe/
	 qsiMB+QXVZWkD6adJPa0ywMkQg0Yvc3EJJsRXS3ncWyf+rlj3pShetUgq8Y4Iwee6H
	 7AREqkuTE63t+FrmBFK3XD+Q1f1RlUK52gCCVHws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1348/2214] perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path
Date: Wed, 18 Nov 2026 15:50:24 +0100
Message-ID: <20261118150105.382158840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit bfde6848c1e24fd979d0138c57c1cc28c35093c3 ]

If the malloc() for the initial read buffer fails, jit_open() jumps to
the error label which calls funlockfile(jd->in).  However, flockfile()
is called later in the function, so at this point the stream was never
locked.  Calling funlockfile() on an unlocked stream is undefined
behavior per POSIX.

Split the error path into two labels: 'error' (after flockfile) calls
funlockfile before cleanup, 'error_noflock' (before flockfile) skips
the unlock.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index bf87e32f4bbe8..5eba0914f1709 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -163,7 +163,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
 	buf = malloc(bsz);
 	if (!buf)
-		goto error;
+		goto error_noflock;
 
 	/*
 	 * protect from writer modifying the file while we are reading it
@@ -251,6 +251,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	return 0;
 error:
 	funlockfile(jd->in);
+error_noflock:
+	free(buf);
 	fclose(jd->in);
 	return retval;
 }
-- 
2.53.0



