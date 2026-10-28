Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215416;
	b=KcCfQ0exqhsC191widvgV/B5pVK4VAyoq3+0bZ4eSv7w0oKsGyDnB0y1LiCDCDO//wJc
	 mdYWS/LRJnHlyZD6ZsJTTaoGgrO5eLQSLA3R5fPP9JAMqZ2ZODq5rDZeUFtXE+R1FLaTX
	 CGs+6vnrrZPFPAWPjbwB9lqsNzs11EMaIIhn9M/klnu+r070Pc/HZCgjIEqMPd1iSTNJY
	 kbYxcdVJWZ5b60a3hoyPDTF/XHp+h2b6uOuLpnVYkf329HLYQt4Ppupyv4MAXaeQxPSq4
	 ykwFr/4LRv5cCM2ExZDG/e8vF5GZhoOv0HlwG+U4tpHkMiuzBfUU7ubvidYp1LDGctg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=A5oP7qunQd1A7CMaA6LRIwXU6s94n8GhaO5UznJErxU=;
	b=uBcDdk1kdoncTjEQV59840V/2mVNI2H7OWiDIuXY4V1P+nPtxaRAQDI3m5eceJ4UHFrn
	 0YLqFjgZ6dC2BZlyKGgzDRkoeMkWIfolPn/nCFOrCWaIhBlHLYqMOuHfaxyVn3AGDr9q/
	 J8+zlLH5NuO54PifwTjx+JAb5e/740biXt3Y9Qmz3tNqjbxi81qGGZ/c4oRqH8JDV+HuW
	 EAbPUVnUO2kF0puEHiM/3D0YEN+V1IQCNkRZWg9K8yMRS6P/Cc6uOxIjUTKQBd2eT+Ta9
	 IkRo/qiLD3am3j8JikyyOGQ1TvX0ranqspMYWMrazD5E85NJEmU8ypZcCkbzQo2rjLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxnFRPMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB9D606A320;
	Wed, 28 Oct 2026 19:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxnFRPMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A893D1F031E1;
	Wed, 28 Oct 2026 19:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215416;
	bh=A5oP7qunQd1A7CMaA6LRIwXU6s94n8GhaO5UznJErxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxnFRPMkdsE1f+RebvNNYuK2d6XzHfbeQI/CmSav5ECzshj0FyoLGRrToL8q2N7pR
	 Xpz+zzkiFU2rk1icvhCQNke89gz9qnzPDhSrAoAEjiWl9zfsZgWgn/L44dtfeiiRDZ
	 xS0wJW3KnSzREZjk0+b2JlwSSxUKsUpPTpUb3rsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1203/1887] dm-verity: fix buffer overflow in FEC calculation
Date: Wed, 28 Oct 2026 17:54:59 +0100
Message-ID: <20261028170526.782463829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 31d6e6c0ba8d5a7bd59660035a089307100c5e8e ]

There's a buffer overflow in dm-verity-fec:

if (neras && *neras <= v->fec->roots)
	fio->erasures[(*neras)++] = i;

This allows *neras to reach roots + 1 (the post-increment pushes it past
roots). This value is then passed as no_eras to decode_rs8(). Inside the
RS decoder (lib/reed_solomon/decode_rs.c:113-121), the erasure locator
polynomial loop writes lambda[j] where j can reach nroots + 1 — one
element past the end of lambda[] (which is sized nroots + 1, valid
indices 0..nroots). The out-of-bounds write lands on syn[0], corrupting
the syndrome buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 39bc0c6865197..b5b70cb522ace 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -272,7 +272,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				     (unsigned long long)block, PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -290,7 +290,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
-- 
2.53.0



