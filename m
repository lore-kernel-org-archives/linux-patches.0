Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039305;
	b=f7Y2wJ9ioo9XGECdKBcN2iK6nxScz2dZKzP++fnil0yLw0mUT/Ym1Gb+U3dZVN063994
	 TBVkUHhl/LX5390z8eC89CFc661GpSiL5KMMjcckTA4cLUwvcWO7qCR8tweYGfFoE3xti
	 BkTJsiEEY0jts+2AoeE/1HrQ7fs16K18a3CbWFvk6qmTllKEBYMVrTJzthI5c2cY+8j/T
	 iEMGd3YSof2BPK7X+y2NITHi59GzmmumfYOL+juWsY3P7qMnU7PVKWt9TeZQ8ccXVANP8
	 4H0ongYCkLkZfLNar4tipRkzchZtA0W+ECqG2eAm8NvBJZLfnmFNwFKk1AM81bzjOfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JdYDznrTVBep9Z1BarCR8qzht95jdrQUIHaGznqrMzE=;
	b=Ldsnr01e0TG/D1aFE93ij4wRlnnk+BXYsVFMvjWRqek1bZpqCq4o2oWHSBzH/YV4/n65
	 Ho8fzpGXT1sza8paqXroRXRu/jijtVbM/IAn+kg9AehUgiohvT1WCkPn3edxxtPtmovHC
	 yqjpyDVJfQI6mJ5cHhcK+yuetXOfX1JFPaqAcTo6IcBAL9QSki3GNE2XTsBdvAuzfuWAa
	 ipbyGskgJZQAy3QOoof343TNsQwZLTiTqSqsmfrdFVGfoPh6+k4rTyjFtiv+Kxj6SjPEZ
	 uXGtYY6+YQ8sDr6qIVfS3bI28LY2lo+MNMFrr/ottBBsSsdnTi7mLYnhvsUNqJe17rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z34/AWCd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5DF606A31C;
	Wed, 18 Nov 2026 22:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z34/AWCd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839081F000C4;
	Wed, 18 Nov 2026 22:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039305;
	bh=JdYDznrTVBep9Z1BarCR8qzht95jdrQUIHaGznqrMzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z34/AWCdIXFfB2c8xdy9RkUuIcuOdUCtFDfQ7HurTaV2/QbIS7lbkNpgOSwsqde7U
	 0BAsVZC3eulRZ0Jlt89H7xvNJ9nGiYDHMXy8cJ53NDqA2rw49BlpA5GnESE0xFDi+S
	 cifwBEoh13L+rT0pCu3Dl2hXfItx+kbeBHcN2xQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2012/3318] perf jitdump: Validate sym string NUL-termination in code load
Date: Wed, 18 Nov 2026 15:43:54 +0100
Message-ID: <20261118150422.402483620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 98bfe1142ccbaa5ffdca5dcdddd26f238ad33585 ]

jit_repipe_code_load() computes sym = (void *)jr + sizeof(jr->load) and
passes it to jit_emit_elf() which calls strlen(sym) via jit_write_elf().
If code_size equals total_size - sizeof(jr->load), the sym pointer
aliases the code blob with no NUL terminator, and strlen() scans past
the buffer into adjacent heap memory.

Add a memchr() check to verify the symbol name is NUL-terminated within
the region between the load header and the code blob before use.

Fixes: 598b7c6919c7bbcc ("perf jit: add source line info support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 2f8c4045c7ba5..12daa9cece627 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -486,6 +486,13 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	sym   = (void *)((unsigned long)jr + sizeof(jr->load));
 	code  = (unsigned long)jr + jr->load.p.total_size - csize;
+
+	/* sym string lives between the load header and the code blob */
+	if (!memchr(sym, '\0', code - (unsigned long)sym)) {
+		pr_warning("jitdump: unterminated symbol name in code_load record\n");
+		return -1;
+	}
+
 	count = jr->load.code_index;
 	idr_size = jd->machine->id_hdr_size;
 
-- 
2.53.0



