Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061800;
	b=GuIVxxvMJAdooAgDZ70aHtptm7obrp6PRbUuFVmMyt1ve/NyvAHTIdV398rNy7f1mptF
	 P90TuCeu9gnw5spvu7iGn0o0/UBm26tXKqvv76664WDL0K0RxPlLgXUPH1z5ujAiZM00W
	 h/uFkQ1YKHBaZ3LqGKgoYHWG5jnBRLSI7Kbd9h0sT9DYTphHytxRejS1SO1easlMGc+Pv
	 7wi8QXSUE5Sc/j1TvXNVDGquQ7QKVeIgFeSuUTY7Oayz0zUvIo/j/f/XfxWe6cjeIpRi/
	 NkOaGNedFoyOGfGDqrqzpXow6HChlzYR1souwiRy05gZO777ALJTwRg0uyWd1elKXrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JqZhZkY2lU9RPeCSJJc4mz6l9RTMkEhPjLSZZv3iYaM=;
	b=wee9TZ3w0mMq24/0DmnX5jcczTo9f0yYRUQhADWWTOPGtAZKpadCibJzSeOdSpxCpgNO
	 Wljw8AmGztBVdSgHawcROQZ5MKmJp03O31smYh3wF8PPEOKYExdpAHfySHErHKPfCopoy
	 /G4NOThzHPQgKdoj/jo9V7FfTTqE2x7CPZ6TLOpv0NfivUO51AGyI4PLzf2FlYuyOjOb5
	 lBpas0je62PIEKwzAZjhRJD4hEwis4mVKcKi5BK7WPuWM9FLKPw6aZZiA2a/Fd6TUfxXZ
	 ByZO7ELQz7GSqHZf9dBkXQkSB92LgJ1rUmElLddfER1KiltueI8QxEprjno9PUs6CBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFzMfsV4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C926606A320;
	Thu, 19 Nov 2026 04:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFzMfsV4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0AF1F000C4;
	Thu, 19 Nov 2026 04:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061799;
	bh=JqZhZkY2lU9RPeCSJJc4mz6l9RTMkEhPjLSZZv3iYaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFzMfsV4Eo5qckRAWKcpVGYUp4TTCmAdLBB36aJFXJpzDSp/TFUiEd0NsJ39SjF+t
	 Uzmbk5wIdAAirVs4Nl4ZjP48bM5mKPz24xn2gN7ZbZ6ni1RSfAApWARxBHSv3dCYDs
	 JIWaQYN+vwonwqCsdIIg0xY2pw+O2xOa5CTSTQ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1680/1848] bpftool: Fix inverted tracefs validation when scanning /proc/mounts
Date: Wed, 18 Nov 2026 16:01:58 +0100
Message-ID: <20261118150030.120851848@linuxfoundation.org>
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
index e80a5c79b38f0..e060d04485fd1 100644
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



