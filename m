Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052436;
	b=TGSaZ8Cr8EVzHyOCLZNZuxCsuiUHvZhCRxmN1C1k3py+aXXNP0QlvKT9eaDgSJEj1cA0
	 NN2Gz0bqDWS2qGYG9wyroSr7ZE9wVb9F3+3lPvUqEd8egth5KCkao+AFbztB22h/7jUhb
	 nh0G/e75qa9NmGkM1p54Vbtl7wp61+Gh2fKZsM/CNHuEa42z2Quix1BGKfLux5EqPhfqV
	 Xkln7OkPACbaAUtIkHDdWhHSoXjUt37bDN/2pAVS0wSewah49Jy4QxM4UWhJhdUym1feu
	 jdvEjBO2zbtH3zQ6dOf1Vta6Frycw9O11w/frBVpfuNUM+EY+MDiyIdnlwbt4e4TU8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zTIlzMa6Pg2pIA+/dvIWP0ZGOJfQ7XLZYT8qOoPaH+k=;
	b=4DQX6dLW7aTImB4JE/5TEtiJqgs9JZaV3qa0mKEc05dbNNJifwNWABQHYmjQoAe8f/OQ
	 ktq5/7S2ogKx5jtxlVYpoJ1aZ1wr9aFOiN/GSKe9mKAP/2HAd+pljLOGJ+czdH3WZjj5d
	 0IgoGNgu3ftEuiooLDrryhw2b4hF1/WM4CLylCwUEtJzjcDgOVAR9QkorFg1CE684zztl
	 1dIiQHDqQBcSYDDDnc6LsfxId5AoA5/oKLNSMa2fuWY7JVzvyvmVb35TSGLa1yRX56f2o
	 XVUZhLtasoYg2C2rjb7bXQeQVZ54MztKDKT1HVSWDh7ioguaZkh9cQQQ8jGkBZDw5Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ip8BOyUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B272606A31C;
	Thu, 19 Nov 2026 01:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ip8BOyUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AE31F000C4;
	Thu, 19 Nov 2026 01:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052436;
	bh=zTIlzMa6Pg2pIA+/dvIWP0ZGOJfQ7XLZYT8qOoPaH+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ip8BOyUPD1qLDC4/f49OHpteD290XmcL2C90l11d5800DsnDHp6fyqi7safYvncKq
	 bnnpO1ndB7e9EhdUmManOBdcIzTeLB0SoNRz1zAAGD+l2ea8lQb6SKHidnu5boE3Qr
	 1X++Rk9F+5awXSzc7FvJL5f8raEFG/HItXNJholM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0561/2214] dm-writecache: fix a crash if we attempt to use non-dax device
Date: Wed, 18 Nov 2026 15:37:17 +0100
Message-ID: <20261118150033.443915328@linuxfoundation.org>
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

[ Upstream commit b15dc73f60ebf02410bc7014ce34fb7fd1040045 ]

If we specify a non-DAX device as a cache device in the 'P' mode,
dm-writecache crashes on NULL pointer dereference inside dax_synchronous.

Note that this is not a security bug because only root can trigger it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a46624580376 ("dm writecache: reject asynchronous pmem devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index ee61879ac0910..9be9ff6f7e3de 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2486,6 +2486,11 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (WC_MODE_PMEM(wc)) {
+		if (!wc->ssd_dev->dax_dev) {
+			r = -EOPNOTSUPP;
+			ti->error = "Cache device is not a DAX device";
+			goto bad;
+		}
 		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
 			r = -EOPNOTSUPP;
 			ti->error = "Asynchronous persistent memory not supported as pmem cache";
-- 
2.53.0



