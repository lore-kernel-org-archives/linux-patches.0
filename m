Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57F03A9D9D;
	Mon, 23 Mar 2026 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274608; cv=none; b=lblNFyGdyj2weuXC0Yh21x4KN6EWuLszosoDvLIZp5OOOWbXcpObg36AuVZBJypjQVolSrfWyzIXBFgx/FBlNMJYu351fQO4nU4u3UKQibRVxT9iW6/csmGEgYYZH/hsrutrvgi4bvVNX4glh5ialb+gjgrvLC9QhXjBvrp8Qac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274608; c=relaxed/simple;
	bh=98s1gaOyclYAbiG44fi0zvqsDq+Iq1umpgyH224B3JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXo5LSfDLYKpPsomM8rH03rKG5dTbyH2DsU2p0+e5tDqq3wMuxUgZDNQYE9OT5k2HTSuhHE3hElIisRSiUFSlMXlOt1+ZIC/vrnfw2SmEQO6T+QxSfkyAZlU+nBdKG5oo+UUHoDKSAHfI19FHP+HEs7GyUrG8AUWNV74Q8HxwGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhcZlOpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhcZlOpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8A1C4CEF7;
	Mon, 23 Mar 2026 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274608;
	bh=98s1gaOyclYAbiG44fi0zvqsDq+Iq1umpgyH224B3JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhcZlOpk/m2ag+uMqL41vHcoq3PJAqSncnEHLKhuMO8dkZGfE15U8AW+tcddmL3xo
	 UVQ2DHClepgoCv00nYRqyRE8B6qm0lZtH36yAGW9DvUyxLBEMLxhFjlYVDe7AshEO2
	 KE5IpiTKGpAamSJCEIg8oI1ttXg8F6DyMSXZEqBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/212] crypto: atmel-sha204a - Fix OOM ->tfm_count leak
Date: Mon, 23 Mar 2026 14:44:15 +0100
Message-ID: <20260323134504.840855072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d240b079a37e90af03fd7dfec94930eb6c83936e ]

If memory allocation fails, decrement ->tfm_count to avoid blocking
future reads.

Cc: stable@vger.kernel.org
Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ adapted kmalloc_obj() macro to kmalloc(sizeof()) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -52,9 +52,10 @@ static int atmel_sha204a_rng_read_nonblo
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc(sizeof(*work_data), GFP_ATOMIC);
-		if (!work_data)
+		if (!work_data) {
+			atomic_dec(&i2c_priv->tfm_count);
 			return -ENOMEM;
-
+		}
 		work_data->ctx = i2c_priv;
 		work_data->client = i2c_priv->client;
 


