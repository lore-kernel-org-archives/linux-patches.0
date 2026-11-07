Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065519;
	b=ZhJvQar0UjEEm852YiMnElngONba4SBlnqE3l/o7vnicXO88G5ptCQLV2lMNx9NHkN1U
	 Kghbcquo6yUP9aVYfLnXHZZy6jUt7q0uZD7xVScMqJLgWCtVRUd5e+zVKH6LdcO1G//oQ
	 C1a9HvmGq67LTO/CvQjHgdN+NY9gmvNeBlp6bEH6YV6ESNxA2BVk0D09D0/1suVl7Uax1
	 YG3dzQW6UuyUu5rNFrW96gDR2sgaoCGCjHkAXAqT72yZnl+7p42VYp4Se7KL2RSgPk1Wi
	 Mw8gZNyBFWk1ndbG5BLDJyj1pbBq4d8jWvV1Aolq66aLDlDvj/tJOIHChC11NclujoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ssza+YUrofN+aNIo1ppGVZ2KVXO2MwWk4STf9kg/x8A=;
	b=tXn5z1hczOc3vsZoVU+yUdnCjBFb9M+I1DyhWtLGyKHlKpY2+kVgzaRo3O8v7r9PQ6HL
	 ui7U6HkI734+/zJqFjn+FtqAWHxREiLHQxI7Fu9EjewXhRbszyGhOGaaYJeR3J+kiQIj4
	 dkD9ceYzED3RbuVgWf3ky8t59zxPV948egkdTLr5VZCeROESbCekBzP+M+vJbhW16Nl46
	 2lH0edgpg9p8KcHIO/bnPZyukj2IkCWXiv3QRQIQpx7umo12/v9wpLUX63r8xSns/lHg4
	 VqY9tKHQWxqcPmx73BSiCm53CA+Dh8/ns7B3FZgPoha/SC52eeBPfXLiWSz4s9NHicQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wL2r3lzS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B849606A32C;
	Sat,  7 Nov 2026 15:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wL2r3lzS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE831F0089F;
	Sat,  7 Nov 2026 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065519;
	bh=Ssza+YUrofN+aNIo1ppGVZ2KVXO2MwWk4STf9kg/x8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wL2r3lzSGbkKHhs/QkqtvoXWIZwqUY62d1wBgGuu+WgETetpe4bVq0T7ArohjUyXl
	 ZDU7brrNlFhj8fMS5TMVXJiCLNs8QmkEoNxsxDNjPMYe79zhAseJDaGhbyMkriENbN
	 JPhvsk4RvaE0gH0zasxPt8yCdAGha2YaGTzZv7nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1200/1257] ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek
Date: Sat,  7 Nov 2026 08:58:16 -0500
Message-ID: <20261107135012.498483712@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 1e860f42f41c6fbf3304f6a52be38245b9394982 ]

ppp_ccp_peek() caches a pointer to skb->data in dp after the first
pskb_may_pull(), then uses dp after a second pskb_may_pull(skb, len + 2)
in the CCP_CONFACK handler. If the second pull triggers
pskb_expand_head() due to a cloned skb or frag linearization,
skb->head is freed and reallocated, leaving dp stale.

The stale dp is subsequently used in CCP_OPT_LENGTH() and passed to
decomp_init()/comp_init() which read from the freed memory.

Re-derive dp from skb->data after the second pskb_may_pull.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 1a610a18893ba..3998ce4332f42 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -3157,6 +3157,7 @@ ppp_ccp_peek(struct ppp *ppp, struct sk_buff *skb, int inbound)
 		len = CCP_LENGTH(dp);
 		if (!pskb_may_pull(skb, len + 2))
 			return;		/* too short */
+		dp = skb->data + 2;
 		dp += CCP_HDRLEN;
 		len -= CCP_HDRLEN;
 		if (len < CCP_OPT_MINLEN || len < CCP_OPT_LENGTH(dp))
-- 
2.53.0



