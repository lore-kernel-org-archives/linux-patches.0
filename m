Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041905;
	b=WGJI5jAiX3iP2qOcshBr3qlNkdk2YB0wBJToIffg1JKRej8QSYVbotDSlMMo12TIsL0T
	 ea/r545RZVVhPhf7AdS3J1pYV92v5+ztrpEejjtua+5M1P13/g8LR1Cu0KO0y1/DseLMi
	 pKFGJAv5bgHBVPmFn1dKd+jR0r3Qwp4gKYkzH6NU4fXyE0aAtSiMSaOpOVxu+lFlbWTTZ
	 CPbCluhFeCU0oOqYBscH3oK1F5ln87SAvxxF0NvsSncbPsd3qaLe+1eRKRW132v4LyXQC
	 /I4ZbT+aQkgslMCSNVZAsYlFa7ARS5joyV2ax5/h577Ckli2ZlEko8EziD2Ul0wijrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rnvh2VtKP0PIkLVMH3f4uEzyuQgEz0Nz1BDRN2TrDrs=;
	b=eeL1+uXJzrgk4Ovn3r5P0zC3KlJfMOkSA7nC5M8h+IxnMkggJDD0o0pSDOKxIAd2Yp7K
	 qWNkcBGU6oxu7ntHKZYMUTIwDm1vuR6r2/RsfnD1JhnfOz6MMgkP8KJ6twZ+JRhd9lW7w
	 kZZ2UflifaSoXC21YN0KiW/Lau73OcItjsR4WRrqTANENYlgworJBK2wQpixAXzW1d4uG
	 Miz7C2vaLHi7CD2jNuGrbkB7ax8HMLyNfhMQQ0xDnkB8sUAIIp7v/F0J4xmv9m9pnl+vL
	 Y+3lqKilQjCcQYradzJfKeRvmezDA/alsA9n40tYjI44tbewYsXM2bImn3kJ+kud2wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RnuAXF6A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36199606A31C;
	Wed, 18 Nov 2026 22:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RnuAXF6A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877A21F000C4;
	Wed, 18 Nov 2026 22:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041905;
	bh=rnvh2VtKP0PIkLVMH3f4uEzyuQgEz0Nz1BDRN2TrDrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnuAXF6AMosS5nPpYtVuP2VEbw2Cjt+IuKCZM4xGMTJJK+GaYhAuTD0dy05yxsibF
	 y9Nb0DLwlBtgQz7QInHOElOUsdK22MbdGQkLp4fYcG881aoBC8dZ3KoTLwtf2DBOfB
	 xtqmJfwKfazyaU7EC2GmLHnfRUZ+cQSe3ZcLaxUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2978/3318] bpftool: Fix inverted tracefs validation when scanning /proc/mounts
Date: Wed, 18 Nov 2026 16:00:00 +0100
Message-ID: <20261118150449.618510978@linuxfoundation.org>
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



