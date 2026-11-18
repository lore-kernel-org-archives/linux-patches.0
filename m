Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020700;
	b=W/y+8RyFLIZNeMjeyHvKpd2yf5mZB3ZPRe0BlO+GLbmPwmFy/CQ1dvHKO4RWSvenTG2B
	 6udKnj900ujl7gS3ist3WYpO4ENXTdVh2R9DwbDnqiU/vcOY/R4j4tNbq6qpkx3FPVMLW
	 d0i7ZcMrVFng9iPx5wxThsWKizlNKbWhKkdgiiLymoSIQl+nefdS/AmHolDKzainpsLzr
	 omI5wy+88C5N6xMbrrBzSzYVn2SV6+9i7t+jCMZTGm0Zi+ADFwXd7UEiRFmiGteHhEbQg
	 5FCSqU92F+hPDiK4k+OOjgY6HqEGd1+ZpQLitFvFt3b7m+JjrvTpbbtxyRLD7Ixz24w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qJOWdQqJ31NVDI+W7gn4dHmx8pZ/SLGakfY/3+9Dn/o=;
	b=zElz9KnB908Uta5h3SWJZK7Dfs06hzQGDSLVXfSfZ9ox7J2q2iudD4sr/PTpdfi1nHfp
	 ymFOY9WujWkjooJXMziC1XfqXPjlN+1Ssfd2hck1eD3lbPnSg3wj2Nv00YFVwh0z+tGKe
	 afv8PLDKsTsPv0Ul08tV0u3YoNmCVPLbMIHqwvtwUjLPP1JcbMc3RTES+RNBgAQvmwalD
	 OHtuqjeN0FjnCDKj5wFowdrzh3IgmMtpmHWYsIbe0BEWFriwJzayIVxW320oDJqV6v/HQ
	 PlNXi1Y31xScJY+1EwPmwEuVlXZ2mJHOwZBsWX8Hmq8v1Seyewko2m87+R7KpTIPElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TB+Zrfq3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2BA60A2619;
	Wed, 18 Nov 2026 16:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TB+Zrfq3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E31F000C5;
	Wed, 18 Nov 2026 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020700;
	bh=qJOWdQqJ31NVDI+W7gn4dHmx8pZ/SLGakfY/3+9Dn/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TB+Zrfq3/+O/okVbpkxScv8dsw5nZzI4N76e8W8kS1VHblMyvXPS7Qo6I0fKkNeDX
	 LCoNkRUYVtJ5rdmDZCf5hEZwkc6O9iOd4dJyipwutQ+C9cwmNs3x1xGga96INEXBFA
	 BN6ipOfW4vDDbR8FLSbw1SmEtydHOH/AivXoL4gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2044/2651] bpftool: Fix inverted tracefs validation when scanning /proc/mounts
Date: Wed, 18 Nov 2026 15:54:44 +0100
Message-ID: <20261118150359.672147374@linuxfoundation.org>
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



