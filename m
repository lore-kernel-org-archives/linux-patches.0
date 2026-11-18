Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036574;
	b=KJfTCj3bA/MzpeB3kRXSVs79HugKhb5Uws8xbmGkwZ48YfJWuy8T52+iG0r3yJ9z6ujT
	 hRMP9ah24GN6xyhO4o/FMmTr/u9vKgLzdHbI15rB1Rt0Rh2MQVWWf6aPc3ef+dCnt6c0J
	 xjQSuNrE16Tn1nOJdESGETIZxh7HwKthl+ef+84w5t5YAj+CbcnSVRW2fdENZBrurUv9i
	 FqylJJYebLOudR3Fa+EjFETH6Mstm1QlQFD2Wr9Zy+jfAp41E03UZ3KCeRJwdwYwXBoVN
	 yVkg9g33bQxH9pV0mUtU6f0RxKxF9T0BiilbJ5ZIv3zfdMkB0LNatlXdRafBgxdQIWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BamOC/6oaJVZOVHWOKmMd+nPgo0ny6zxpbAulIWdKrQ=;
	b=ELFHw0sYRXiOvOkFO0earCQ6ECnnSQmpv9dv5AEGwIbM3/ZQZDzFd0AjCaKbZv/C8esq
	 w9SzDA5DR1ndcZEGR024S/2NEx6Zy51qeHJCcrccmV+sH49ife/Sjo1ybylnpfBTszAiY
	 nVGnKz00icGJp5dZdxwm7YZggfAoWbWQjvUtXnxmIZQ0rkS3fWwTzpPjyYADoQ1vR/rGP
	 b0aTo7AXFyWBbr89qAyvDS5dESoGLCdJUdq9Npn3eVcEs3vMvKHJNQiUQtm1iMYyEcaxV
	 rrSnbMWFq0ZBHt6998HOTfA+7T/8wvCBU4U3DGKtZIJ7YsqC7eRVUVKgGwzxHvUXHfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tulnsqZb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7383660A2604;
	Wed, 18 Nov 2026 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tulnsqZb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D25D1F000C5;
	Wed, 18 Nov 2026 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036574;
	bh=BamOC/6oaJVZOVHWOKmMd+nPgo0ny6zxpbAulIWdKrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tulnsqZbl4JfgvrdprJnz6QkHoCFvuwjDmjfoBTmKGt4CNkPXeoClenvrL/S/wD9a
	 LAOgtWo066k5fVd2EZ2QvQzLyS6DEJ3r5zj2Qm8iVB2wMlHlAVLpfT4+JebWVQLkUh
	 hefID6EUPjPzKANqzjOXDAQFuzuOGsbGik61bC+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1065/3318] dm-snapshot: fix crash if dm_io_client_create fails
Date: Wed, 18 Nov 2026 15:28:07 +0100
Message-ID: <20261118150351.910107343@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 829c4d21148a205eca864429e06530319e1f92d5 ]

If dm_io_client_create() fails, it stores error into the ps->io_client
variable. The code would try to free it later with
dm_io_client_destroy(ps->io_client), causing an invalid pointer
dereference. Fix this by setting ps->io_client = NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap-persistent.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 568d10842b1f4..1eefa19d02940 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -325,8 +325,11 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	}
 
 	ps->io_client = dm_io_client_create();
-	if (IS_ERR(ps->io_client))
-		return PTR_ERR(ps->io_client);
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		ps->io_client = NULL;
+		return r;
+	}
 
 	r = alloc_area(ps);
 	if (r)
-- 
2.53.0



