Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063666;
	b=3qn4FtV2IkXyWKx5Z04Q4aJk1CalSqWhX3BNIC84oWi15aFo6iLMkaV/orJvG/GIIubt
	 7EO3vMDPiq6lPZSRun0uviA+0PffHRDfSIi5xxQ9qM5eMXyVX6NbV1G1V83ELTi9zHVxY
	 qTaAlFaFgfCoWgDsqggOePgGGfc9Z5aVheHMhQ51uu3HlvwL1fTWudqTdUxo7q9DBK8IM
	 gqKtYWzFSKDV8b95LgtDoDNpmxIrDaxjIwhy9Pgbo3ZNNLQo9Xu4JRVr+mgsxbM7EaiGQ
	 /D66hPdjXPCd/EZAoY1Pr0M1aO2MfGP66XgEpolT0aw0Cdy6Ai4x5cS8MHB4+/Xl12g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CZBPI3B2W1Bq13zKXLJbJ3qofSeZuEQ3qmQYbZZK9wU=;
	b=s6X5r1yFIO5ZdId0ANZdo4VBExTGzMMSpeoMNL7kkceIbiEf/3E90NcrshewGqqCE89R
	 OZ5mjESdPLW192ZeHQvSmApl3IPeRkd3Dgrk4wqZTA90D1CJWgx9jF0c5eHHiPkUpVoSu
	 K0VpkVISMnIvixw5zmF37O/VQnoBGkkVVVtvZKGKsS65sziCl1w4UFBsW15pU8coLKWm8
	 oyTVIuZqZIsNY2dxuBCGIiQo+OxSw8dWTGIYEwJHAPROuG6JOKtPZaekAAZGxXROmZUog
	 BRd4DpWS2EecwetW4Aw1IwR11kuqOyCAL7l5pYLqQfOW2DXf2/4KmNEew85ZsQFmcwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjI6TnL+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D18606A9CA;
	Sat,  7 Nov 2026 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjI6TnL+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF371F0089F;
	Sat,  7 Nov 2026 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063666;
	bh=CZBPI3B2W1Bq13zKXLJbJ3qofSeZuEQ3qmQYbZZK9wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjI6TnL+12Dl4tfY1VmC5e9W7mO380WisayfpgX7cCd9wMa+zlTmzvE+k4QOHPNz5
	 zBNKEiuF9McFkhy/m9ZBmL297BOfTldQ14RNRiEnN8cZKgCeXXqJ3VZKspohy1HIg9
	 wmLDqqZ82HwDNu7AmL2CgBdKL+0acsWc2Tm3zW1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 779/869] libceph: fix out-of-bounds reads from repeated CRUSH bucket entries
Date: Sat,  7 Nov 2026 08:57:41 -0500
Message-ID: <20261107134919.098316235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 569a9bb1e5615c2b88b8d76f03a4ab82e65a673e ]

decode_choose_arg() assumes that its destination is zero-initialized.
Although decode_choose_args() zeroes the argument array, it does not reject
a repeated bucket_index and can decode into an already populated entry.

Repeating a bucket with weight_set_size=0 preserves its existing weight_set
pointer but clears the count. Placement then reads weight_set[-1].weights
and dereferences the resulting pointer.

A malformed monitor OSDMap triggers this during RBD placement:

  BUG: KASAN: slab-out-of-bounds in crush_bucket_choose+0xdd1/0xf90
  Read of size 8 at addr ffff88800290df70 by task init/75

Reject populated arguments before decoding another entry, so the error
path can free their original allocations.

Cc: stable@vger.kernel.org
Fixes: c7ed1a4bf4b4 ("crush: assume weight_set != null imples weight_set_size > 0")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index e812b30778d57..803514a1bc7ce 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -387,6 +387,8 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 				goto e_inval;
 
 			arg = &arg_map->args[bucket_index];
+			if (arg->ids || arg->weight_set)
+				goto e_inval;
 			ret = decode_choose_arg(p, end, arg);
 			if (ret)
 				goto fail;
-- 
2.53.0



