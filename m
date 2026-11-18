Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060275;
	b=RpPeMgHPq1xhnvqJVr+S2utnzauzDNAz049YPTbOrOrbNdlMZB8lFWtVkioGcQVKD0SZ
	 UVf7/dGcCN4w0MKOz14magnmWQca73YkFGUlKXj7NGNiPAo1I2DE4bskZSDxomWohXhE4
	 1RZj3Ll56t2qnC05DrXptFGRq9v48ruXHxosMhIPC24ezQYp/aQkfmE/QER4NLdPjSvAv
	 ipKr8AcpuU0dS0vX0tntvQJP65etP2tSoEOm4FDhUUxVcbSe738z5h9Mfo51Kxlv2DJX8
	 EXam9qJJ7jfLsYVbM18K+4EDQ+TNtckPWgFX1Cjx96b/lQnfnTwqwk8EYXxsTkQ3UPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vjfGQ1SDUsAI88givF0nlo1GoSD1lQO23YWkexWiVBA=;
	b=epHSNmtNsluraCcA+2/6MTw2/TUhppmjpVSkpHQDtL7aaeYd0zaC/XqPH2j15I/3K/zD
	 r2/FD7QeM824D3l3KledtpjH8FD3PU+FuEjrbIbPNe/Xk71i/YyTVpOZIatQkohZChG/3
	 MDEfNTYyr3/PZD9t5W56sM9i5gtJxyncINMxVwNLhxaEEz7snPbU1zv7N+wwlqrMLpkC4
	 xMDOohBJGEidypfvZlxhocglMD36NC20jiKNyjVdlcuhKIvIhHmHaxqXOF7+UmE4stq1b
	 ngsu4qhHeuSO1zxasv+x34KQqwNH4HanIePyOaJgaMremdowd+GU4ZV4zqD/1tGF4fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ni8cSE0Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A433606A325;
	Thu, 19 Nov 2026 03:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ni8cSE0Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCA81F000C4;
	Thu, 19 Nov 2026 03:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060274;
	bh=vjfGQ1SDUsAI88givF0nlo1GoSD1lQO23YWkexWiVBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ni8cSE0Y18hxhpbBO0HD/KSwzgsN1Y9CzkbQ7fTHcAMWXA5q9EZiJ5OWRNbqVkrgJ
	 gipgw3m456rRlcTOWJLWQ33BLk0yTAqI579e4Wsom4rOwhXwRuILevhkmgSh6YmR0z
	 Dp9A8Q7HhaFPBFIjsux3XrCknjpy8K032iDbplZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1139/1848] perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path
Date: Wed, 18 Nov 2026 15:52:57 +0100
Message-ID: <20261118150007.256831671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a9f2be429ebf2..3797318b5fa60 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -150,7 +150,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
 	buf = malloc(bsz);
 	if (!buf)
-		goto error;
+		goto error_noflock;
 
 	/*
 	 * protect from writer modifying the file while we are reading it
@@ -238,6 +238,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



