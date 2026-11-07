Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065469;
	b=owPspgYFMBT7uZMRE3ojsug+adugTx21yY4YDctminL8HOMn1jpTXfX2NGayfhjubTc9
	 C1N97vZJZPjFMDQB2tJAqPLqVqnBh+OHWk/Ixjd5zNxXsUbbJKt9gNmlUp48tjGKQ7cNH
	 LB+2mHIXhtC22HtVwS3WIsuOm1HOikFW6DtEn0RP5qZMn77owAwwwpnd+p57NdCzdag1d
	 L9v+8i9J9lPGUY0rvoU4dq/jUmdsUmVy17ar5Xz21QzNdTenA+tMOIby1egERae0ccOJt
	 mWDHpd2IMxvDU0QWgGD7tPOY9as9C7JJMPwJVOG66O8FZMekXVEmNJs5dEndFxb+E9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=D8+K2CrsQLeDtInDbn8WV4XNv2YjHzI0hCxE6PSZYww=;
	b=dKadcMuGBFqW6WqKHLmSLjLC4PVaP7vB0sAPmwyqYUyhXl4VSjPUDrPFolad1Gog98IG
	 HoCeaKYxp3uEQy5vf497ZRxpr6p9gEvwLJbFpWSa9YTBtVSij41OwLacW28pnE8/VqCeT
	 3l85t3UzWYCTZjh/CnMZkmE7ATtVmst2cuyG1mlrovYU8t2qHlIFt2/EsrKWB79ITqyfz
	 eiymfemjtXl8uC83qd3lwdNmbM4jm5+Q3GTGfFNr9emnUkau6Nbcay1PYdEwNFjHHly1G
	 7bc0yzHTNjH5Oiqa/rqjUYKmTfd27KqsvGXPRqfSqvQ98MHG45Y0CGPx8HxrTsQVmvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jsKDKyE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C79606A337;
	Sat,  7 Nov 2026 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jsKDKyE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305401F0089F;
	Sat,  7 Nov 2026 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065469;
	bh=D8+K2CrsQLeDtInDbn8WV4XNv2YjHzI0hCxE6PSZYww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsKDKyE8DjDzJnD6sHTxaYOKOUJM5ACu0XHn5gBWPjFJvrenbpjR5qNCvQZ+QAXq4
	 NWRnmoSq1Bw7UakxrIP78qR47JkX2cnA8bTKyRoSWgH7suW+RovlBbSLhxe3VjRqdf
	 PTpybG7ZiSERiAMslT3UTWVnhUsyudavNigCsbus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1128/1257] libceph: fix out-of-bounds reads from repeated CRUSH bucket entries
Date: Sat,  7 Nov 2026 08:57:04 -0500
Message-ID: <20261107135010.389439438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7bd27c2fc8726..7d65a81148166 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -385,6 +385,8 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 				goto e_inval;
 
 			arg = &arg_map->args[bucket_index];
+			if (arg->ids || arg->weight_set)
+				goto e_inval;
 			ret = decode_choose_arg(p, end, arg);
 			if (ret)
 				goto fail;
-- 
2.53.0



