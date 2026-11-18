Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050055;
	b=JRmgUtmC2OZDJkGq/Vy/NrM8Qp1pL8pW5XFd/MVod0j0WP2Nye4+gCyBhwZeWwZvTIBq
	 NwlUOLDxDvrlbi0CylXj+Z059tbN6KsS+Jz9QpijLk/ljc8iJvIOKMZJOADAF0AcUJiut
	 fwxb4CUb/S8MLhtuvyhqgTjvxuxw+V51sfsqTDHgM+cZ5kfDa7ZiwiEk98pDOrqMOoPPn
	 UoUSBjarmbg9ClgFPaogGPrJGQCBQTW5Eq7iADMmtEmdfuLfZ/OjBFtufjnK9kRT7fn4m
	 8riejZ/FBsqN6QRtD6m16tVAAZ3OdFnLD+k4Rp2Bcwbm5my+W5sk2cVeEtuU8mXjuoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n/c0w5TMBO98AgUq/QUd9z89Oukf+TJH3PDGlvWoACA=;
	b=uspjYsLML/iYgI4zxUn3fivsNq02WbhBZmbRTrgSXdZtkMTknIF+A1laE/aBw7wgwoTO
	 eqlM12R8Ng6G2Ggnd4VbgwqpXwJ37jehk/4xMrjF6YRaNsqLM6nXWCJZF/XEYC8NQVfVi
	 JPs2pHoP4BqKQgeek1LYvvuvDMI2yZoDPWcUvMHdKHbLvpzAWYmNNzweueRs3gPgGfde6
	 5UzmV3hmo8fYOC0kN2LyDVF5XTajdvO6SX58zyK3v0K4Bb8Q+UHWP6n7eKavgE071HoXi
	 CwdlFQxS7df5JpzqMf9iZ8wExhg54M22cI15QUuoHGbD2gLUovR/6aySh4cWYQLhprQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihhNGPBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE4A606A320;
	Thu, 19 Nov 2026 01:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihhNGPBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359D41F000C4;
	Thu, 19 Nov 2026 01:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050055;
	bh=n/c0w5TMBO98AgUq/QUd9z89Oukf+TJH3PDGlvWoACA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihhNGPBjLGpYZq/3Pb57+tvSty16+NqXEwcb8rvI3SQn2RCq4g0MtQh9s8M1g313F
	 dNgPEemY8UzkvvP/pNYBP33bCMIjL9DzuDnZXpSLvznEQyq+c1/p7b+vzJlvfvs0Uq
	 PhWeiUwZg60RAt6eino2NSIkgY7nFQvH4RFD+ydU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2571/2857] bpftool: Fix inverted tracefs validation when scanning /proc/mounts
Date: Wed, 18 Nov 2026 16:00:05 +0100
Message-ID: <20261118150334.060673909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



