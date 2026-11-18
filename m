Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027126;
	b=k80IDX7VdOmvfS7g977mmw78nzDv1/nZhF5TcEICQNrnkbmCBnYFdCVhqkS3AzY1nrEV
	 Eqxf1wdUVe22NWTm8TqWqb1RHiVwblX9xebQSQ0Ez+y4U0eq8G0VT0PpBWsrbe0Vg/k96
	 x5M3FICycyxoXpjtEMc8bauJH4yIkHzmbMk8JD4qAF3qNRF7Okwv+ojJk3/0gqwzDGRWP
	 y5qjVUER3AcQC+MIolkSPOfF0pGaAG22vuiqv6NxArFad/g2qMoy0oms2VJyz9XkhDBHA
	 EtSoPvqNvPZG3jJ060C+IcMtpi8cO/5ODxTqw5csU1qEgL44XFOout2gNY3+3ytykKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qR8JZs6HQ3GOhMl2Xyu6emkSTmP7Uy0M+jNEOVMN12A=;
	b=GXVBs13vhM4C+q0wwgYVuILAhL9ftLmBpW8vPQcG/vSvNcu2jk4773D3TwkGQ2n7Gt6I
	 G5g+Y6+r57iBHK/AaaXhLe9DJSqVOOTfEaOA3KCYY8zlQB0os+BpF8UVAaSq8yx6Nv3j+
	 nXJeDKO9iEmifZ1FdofhHc9etHrGox16pIMRG2qMhBD+5fLDOwUkRB1Hus8iVbNrpEgjZ
	 /6/iJEH4PPQ6ZoFjR6F7Y7VsnjBE6IBLlL8CzxxOSViEC82ZqSjSRlIFBxGktbefoGg9s
	 xZ1MIHAYNhYPcsDvM7nymq00HgtFwZxSd+Ie+upralVAT82pYa4G7KmwCp2eIaoBq4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbMkXC5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9248B606A31C;
	Wed, 18 Nov 2026 18:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbMkXC5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41B11F000C4;
	Wed, 18 Nov 2026 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027126;
	bh=qR8JZs6HQ3GOhMl2Xyu6emkSTmP7Uy0M+jNEOVMN12A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbMkXC5JPK753BtPdcTmnhxf9BqzLznj5qVNE4+ud/Qlzniwg1PrZpmfazQsGF1bf
	 sxHkUoSJi0vmVEwzj1/WiPxAQPBJyrGYezDdN193RSgYp/Z1vkGF1oeYJuCWheMdgw
	 yYYF9cG2zSm1Cp59hpZFUGFEMJSyp7ucTiq64Psg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1678/2151] bpftool: Fix inverted tracefs validation when scanning /proc/mounts
Date: Wed, 18 Nov 2026 15:56:53 +0100
Message-ID: <20261118150222.954017869@linuxfoundation.org>
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
index 573a8d99f009a..e104748c83502 100644
--- a/tools/bpf/bpftool/tracelog.c
+++ b/tools/bpf/bpftool/tracelog.c
@@ -86,7 +86,7 @@ static bool get_tracefs_pipe(char *mnt)
 	fclose(fp);
 
 	/* The string from fscanf() might be truncated, check mnt is valid */
-	if (found && validate_tracefs_mnt(mnt, TRACEFS_MAGIC))
+	if (found && !validate_tracefs_mnt(mnt, TRACEFS_MAGIC))
 		goto exit_found;
 
 	if (block_mount)
-- 
2.53.0



