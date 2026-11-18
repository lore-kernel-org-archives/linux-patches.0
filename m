Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036514;
	b=fHTMih9fFYLi4SM3tFcJUiX7+LAaE+fvTcGJlgbgefrDMR3ixeecixc/UlU7YwRsAGg7
	 1Uo3bjB3urMHmROxmLu62FOfw0JcVRyKlqGjjJk3ZJQ+RB6oWKAUqfnbDNGD7syIJU/ir
	 G1lxjSxm2mbg5UyVPYagR8ffEe7rkfFTuYwj2QcpassMEZyQzE6DWyN77XumN+/eBCaCr
	 p/+1GlaDMiKPVLzPE8KAe/ZPRmJ+CHdMRe5G4Q+uYqI5bUeE3Xozyb/tF/7otXmvM07mX
	 RyBYU3f8HCUYTTDDuXgC+urBLJGzkyCfjAQDDFOFrK1tTNxA53wQazzUrqFLiAnEDGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ihcjn2RYEvMechKuRIcBn1Sy+d80LuGnztpJ69ZUKtE=;
	b=Z3Jdlskk8W6RoRJoVgDP0OYcOgQhT6ddhnTluov+YfY2+Td+NfMk7ZqQurB0n1xzcHeD
	 F7Ksu9c0gX2AB/9CJM2DmpBrtuZUeokzTXQAj4owUohDC4ESvIK5L6utUemsvvfeCjJ66
	 7fN91A1NjC0ezQyvA/S5OtLvj/SDAH8VBtXK/7k+mfs6WSF4/L7z8J8fsmt9wWPbENfTa
	 cJgSULi8TNz4f6YnZvpm78sj1b5sIgp41dWVUz0bbSNlm8ky4zuXOSC9r84Zf6wiznF2g
	 sju09S6/2FGlT3xIMo7JFHOkdz6g/QJyObz8zUeHbOVZtYvktN06CkXpsYOx/XHtw/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BAKilD1/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29804606A333;
	Wed, 18 Nov 2026 21:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAKilD1/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741FE1F000C6;
	Wed, 18 Nov 2026 21:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036514;
	bh=ihcjn2RYEvMechKuRIcBn1Sy+d80LuGnztpJ69ZUKtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAKilD1/f/haUKoWaIzXXGrXAZ+TJDv9M+N/rwfnZV8+IuSYabxV5TP1T05rff4Lv
	 IMKtcTimbPXksZ3pfHYvdMyjCIksLleFYCvKE5ULGDTQRmivpBVbA0xQCjUY8ZJqXb
	 isw8E3BI2p5wTYYfGYCCnWsCeEJSMqYzcZS0Xs7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1087/3318] dm-bufio: fix a race leading to an unsigned integer underflow
Date: Wed, 18 Nov 2026 15:28:29 +0100
Message-ID: <20261118150352.585158616@linuxfoundation.org>
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

[ Upstream commit 005d2ec5723cd4ac740de678274623f1fadd6a6e ]

The function __scan tests "count - freed <= retain_target" and then sets
"atomic_long_set(&c->need_shrink, 0);" It exits with the condition "if
(!atomic_long_read(&c->need_shrink)) break;" It may be possible that
between these two statements, another thread sets &c->need_shrink to a
non-zero value. In this case, the function __scan continues and it may
possibly the "freed" variable is larger than the "count" variable. The
expression "count - freed" underflows and the function __scan will
continue to free all the buffers, even those that are below
retain_target.

Fix this bug by immediatelly exiting if we set
"atomic_long_set(&c->need_shrink, 0)"; and don't attempt to re-read
c->need_shrink afterwards.

Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 4177d23eb7d6e..8f121a7e87bca 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2378,8 +2378,10 @@ static void __scan(struct dm_bufio_client *c)
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		while (true) {
-			if (count - freed <= retain_target)
+			if (count - freed <= retain_target) {
 				atomic_long_set(&c->need_shrink, 0);
+				break;
+			}
 			if (!atomic_long_read(&c->need_shrink))
 				break;
 
-- 
2.53.0



