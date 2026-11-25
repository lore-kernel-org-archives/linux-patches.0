Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626052;
	b=m/nwszhSBNev3BaLuDO9fC/7ASFSmwsx0qv6vs6WIXOMJZbwnHULRrF8S0WC+1lWlklP
	 d3yLEOSblJjYYRjAQ+c1ba8tRcGV66QBsfr+4/NO6ihAC+/YLfRB1RDMQH0Iolsn56Azm
	 zxIcyolGmYx/CmDski+F9D9+Yi4fFEAhi3p7qG6TEjCKPKr2cOvOJ48a/tpT2+p30Ybn+
	 nEyvHcQxzZ7P9p6zUVXhBTWnywlHz5X28Oge2ML4fcWQdNHH8wLcdruSawg9K5VXUvcPt
	 Kd6pszWm91vj4DohJGNxwvmMICK97HrE6gXRuffEsHsSATYryVoXpYB2cPC40HwnxYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A1AZcrcc/P8rMExc3vL2LZCiVz7w5lBiKsH9WBYZE+Y=;
	b=L8dquNCIzbtMgRz3lN/7hDZw8dKc2PPI7ERv9WbM3bHyncZWrNMQCgIXiprAqy5x12sq
	 vqUfNnyOBAtv+wVOFoedyILgAL9KBsLLADfXNooYGOM1jV+S1CkkY1YkcteTfa/mo7xuQ
	 TEOBNOFlUuU6r0U6J6DjRyBdgYiYb9tliSwJFnp8TVs08L94b80NaJsMoWW0QFiCKZ8aB
	 +t4WVIMUU/P5D1jaWIoLGDyAwR+243uPZuCqSEmDB20mIWKPl1wCnnguiaJfx6TKxQ0Ga
	 m7Li7LdpOxoPBGtnAhL08a3LZMPEyGOuqt6oPyrMKpImx5XA4honODKDVK/cMkJH37A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D26UYE0E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AF6606A31E;
	Wed, 25 Nov 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D26UYE0E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312ED1F000C0;
	Wed, 25 Nov 2026 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626052;
	bh=A1AZcrcc/P8rMExc3vL2LZCiVz7w5lBiKsH9WBYZE+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D26UYE0E9EHBQ36dbPbHtIDS5n/2Q12e+NFIWmx+ukeLhVkzzhwd10pZIUgti+pZ2
	 dE+vrKuAA9PZGtB4W9xeTfeEhEsHAPGPaFfSs8Pjfysob6hcJsePycNVSgh7o1eaku
	 jfQR6+64Rb+CAKecLoONNFg39CayVg8jaO2iD5H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 717/816] dm-thin: fix data corruption if discard races with regular I/O
Date: Wed, 25 Nov 2026 15:37:45 +0100
Message-ID: <20261125143905.773750899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 62ee9c09366cad69410330087d990e469dd92314 upstream.

In the function break_up_discard_bio, if a discard hits the same block as
regular I/O, it was intended to skip the discard for the affected range.
However, the skip code only advances "data_begin", it doesn't advance
"virt_begin". So, the data_begin and virt_begin variables become
unsynchronized.

process_prepared_discard_passdown_pt1 calculates "data_end =
m->data_block + (m->virt_end - m->virt_begin);" - if m->data_block is
incremented and m->virt_begin isn't, it will overshoot the intended
discard range.

Cc: stable@vger.kernel.org
Fixes: e2dd8aca2d76 ("dm bio prison v1: improve concurrent IO performance")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1705,6 +1705,7 @@ static void break_up_discard_bio(struct
 			(void) build_key(tc->td, PHYSICAL, data_begin, data_begin + len, &data_key);
 			if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
 				/* contention, we'll give up with this range */
+				virt_begin += len;
 				data_begin += len;
 				continue;
 			}


