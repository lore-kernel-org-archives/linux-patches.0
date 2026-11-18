Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032218;
	b=ZWxvc9Zw6c8K9lo3OTCpdka7GsfIdfMDSvK1FHMVc3cjt4gIALZWcmo3IiW1uD9Nob9c
	 Nw5oBuD+mpVZhUWDgl/UymGww3MbsgRvHbFpl+5/KD4N4cVNGFDOqJMccvvxR+PnVM+wH
	 MMTtATDa59acHCt4S0XgJD8XABKyuPlgeVCIGQfuCQTq1mlQroTb84Z+Rp2DyktyJpWEs
	 HdhmQaDsZPbK2T16c1p7yRIVnhD08mECrmF1880ofTigsTqVFAX6LfJy60WKPh1G5w3kz
	 W/gAhOrwfwYYsIiM9NDkckdFAmcwt6a/Iv7mF+JLlF9l2s1UYWnmTEx1GwgCXiIPNKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2CmjQbJ/82OLrLMMrd9cvLg8rDqRQ59g0P6+2jgUMrU=;
	b=prtaQm7f0q2Ph0IjtMTkwh2Zr231c2dcBgOPY/wKJG/ZnCJrHEnnlsKEB4FWeD+kXPL2
	 ghd836Lf5Znp1jDDVF77ova7XhKeAwGTwrRLs4WwazEqQLKyyYkyKi7rStTC+33s/jbkw
	 GErnqF7umqDQgUkyvARNlxgyiPXRjNpFV6W3ASu3zkKVbbn30HD4PNL26j4MTLr56r5Qr
	 Bop4oDLZpqaHOlyAEZZSSTegB3hX2MM4ZdcX7NCoJFO5UpCIzcvHQuG0nAGrsfi35mLfB
	 Bn00XgRGmyeuf+aALGTUvsMkIJGk7BA9FcAJQlcZVqrVLyW487lmrDRgdx+VqKC2VFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbrRZt1v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B859660A2601;
	Wed, 18 Nov 2026 20:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbrRZt1v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CF81F000C7;
	Wed, 18 Nov 2026 20:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032218;
	bh=2CmjQbJ/82OLrLMMrd9cvLg8rDqRQ59g0P6+2jgUMrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbrRZt1vKf6JpGQBwGDigkLwoZf90DhprDlqiC0PgwT9KBC6J9q9dSFagPijvpvL5
	 XGKZR0LPnld+20qAakLHs4Q0sUKf+yuOViFYRpPbrm/48twMcX3C7Pn/xPZKcDRuTy
	 hAAMgTU0ZW0qfYll+7X41SoVIScqAszOSW/JlqGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1335/1756] bpftool: Fix inverted tracefs validation when scanning /proc/mounts
Date: Wed, 18 Nov 2026 15:57:42 +0100
Message-ID: <20261118150102.514000946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 21c755efaab1f40c2588ae5acbfa319a6d7d3638 ]

The /proc/mounts fallback in get_tracefs_pipe() accepts only non-tracefs
mount points, so a tracefs mounted outside the default locations is
ignored: bpftool prog tracelog then mounts a second tracefs, or exits
silently with --nomount. Negate the condition.

Fixes: be3245e22d22 ("tools: bpftool: attempt to mount tracefs if required for tracelog cmd")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261016015057.127061-1-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/tracelog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/tracelog.c b/tools/bpf/bpftool/tracelog.c
index bf1f022127972..c48deb69d24a5 100644
--- a/tools/bpf/bpftool/tracelog.c
+++ b/tools/bpf/bpftool/tracelog.c
@@ -88,7 +88,7 @@ static bool get_tracefs_pipe(char *mnt)
 	fclose(fp);
 
 	/* The string from fscanf() might be truncated, check mnt is valid */
-	if (found && validate_tracefs_mnt(mnt, TRACEFS_MAGIC))
+	if (found && !validate_tracefs_mnt(mnt, TRACEFS_MAGIC))
 		goto exit_found;
 
 	if (block_mount)
-- 
2.53.0



