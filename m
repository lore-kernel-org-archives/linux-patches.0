Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052588;
	b=vUQid7FJGK1hXQKCXCJYp7sRxzARZ35tTZACtCm9MMFcvx8OhktsFPaXbqm8GgigAqaj
	 RejHvIJQub5KddQ1RucPQJz4+xUXUuJEtdFBu94AbdnjQpUSgiMuHtllrUBUsDgBLyQ/Y
	 tzTGhQYlvTMIa6fk/UOHrLUCywF5lU7ifWa1EBcPAVaPE3qfH44rSMGrDcWNJ8MIKQVP6
	 uvW2K7EDo3FCkyDWMN8o3AFk3jMfhjVo2scCArgOcqjqOnKiktOLJve1HlKZxhLLi9DO6
	 +1TBPGyS8sHpQek/2K0wOG96YX/y2DGdmk2Cu9xTqdd5WcGaMCZvqc9AesHDgKwLFCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cixfLsjCqhob+ux3vJVta+ju9QeGmhg4yagk1Yjwed8=;
	b=NfaiWbOrQl/ieWaL4dwLvavuU8PuKh22FscZGG1Ne+aDvU+463B3mdjH3Ccz3rmCseEW
	 BynRt+jF40hvO0ga9kwTVNx672Y8UZ3+0ooyV5xJMxDqAuVwUtRZMF6Cw7GtY7hlBOdso
	 npnbc/5w9u3LD97LvVVYXBkPkmzchKn/wTlHsaL32g0W/QQgLGjFUSMu85axhI6Jh4+5D
	 O7jpMaj3dzqcDanZ+xkPcIwVMH1/UnUCpsbC7VwZxRUnt6uCbdjEivhHcxXHYKKreXTTH
	 KUDdqbtP7b2ftH/FSGXGLE30uaq+f/RqD48C4ZrL9k0Gdm+w8xzN3WsNTP8E8i75BGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgQ6Ffvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A96606A325;
	Thu, 19 Nov 2026 01:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgQ6Ffvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D87F1F000C4;
	Thu, 19 Nov 2026 01:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052588;
	bh=cixfLsjCqhob+ux3vJVta+ju9QeGmhg4yagk1Yjwed8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgQ6FfvuomZtUD8MgqaPqMS6hBrw8sGZK70zH9yQuT7xoPn3E9ko9OBmyQRkPs07X
	 wHANWhHZftDTw4Yw892eSnE4ny/yn+6NDpoaxpxZhgvPzJGmgYjOVzbtr7FdaWf4Td
	 4hCxkyKwe8q38xuNGMWEq7FnThqFG8JuEBdddLgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0615/2214] dm-snapshot: fix crash if dm_io_client_create fails
Date: Wed, 18 Nov 2026 15:38:11 +0100
Message-ID: <20261118150035.996130460@linuxfoundation.org>
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
index 3bb5cff5d6fc3..4100bb4c6e8d4 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -322,8 +322,11 @@ static int read_header(struct pstore *ps, int *new_snapshot)
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



