Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045793;
	b=BkgFMjxUzfrBzPRQBQczqowzl+6MBnGDdJf31/J553iuJuOnB6lqyKje2d84U0Fk4cAA
	 0IhYXugyXxxbbgr8Rrw13g3dA0K30iU5sgugqitgaJSxjbod7bdpiQ/Cz92ZbUaZQsnen
	 RYe4Si3hg8V6SsjoMZpFloTnzxWzYKshxGaPC5ihg/K+bYxkzeOBBnaaOhj4EqyEpt3D/
	 JzrIeOcRitKm+Rrgrkr5NPqG0kN7J3OvrZil5cJblX0lXTE0cmN45D6krRuMJyZD0DmpT
	 B1BJyGZnau6n6ujFFwoOcqrImUfcKc4z//g9i67SSJrI3UsUzGUBbsVrXxNf2pwpcyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uBomruob1mLBVUjoBFKTxJqzLjDXwz5xHD0bn7ULLQA=;
	b=qtN2JcRFM829v7+uFyT9nbd1mUKa93rIeweKXjVv/vP/bPy8pdxnRN432TJcTuK38LEj
	 NgKOt1cV42fuPATmTLVamUn+d0YVTm0oYr4p1zlfnjC8FfL2BRC7yIbosZAtl9FMRKwW2
	 aB9s7I1n+gCCaBy82IC2xsZpjCEIddkJg8LXMI/XN4j39TzSA8hy7fzxNGKsdk3/pevbF
	 BE83S7nHEjMjr6OlFZfPVtyTIXHk2MCYuz76YQfpd9ayw2ON2vBIWj//Fyr9xs9mRPMga
	 88hjR5jhgMvn/aIpYvdg6sP7cohmP72eFw4867oItVkgtj6KZMtIeGhdDq95QsSgbBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWthkojf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA99606A31C;
	Wed, 18 Nov 2026 23:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWthkojf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0341F000C4;
	Wed, 18 Nov 2026 23:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045793;
	bh=uBomruob1mLBVUjoBFKTxJqzLjDXwz5xHD0bn7ULLQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWthkojfNRlJYYdM83nKzCaHSdYfT18ZgWixj4/eW+nWUZ1cMBTpXHDJG8ceU11w6
	 MiXyfDNtnYZyrOjqwoDtkwvAiWwrVyVrYn8ACI/pdAaccWwoZlc7ep/jmInNdnUKXX
	 HLm10TTNcN14NWRc4B4Kg/D0n1cpm+HCAIQbh7GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1050/2857] libceph: Fix multiple unsafe decodes in ceph_oloc_decode()
Date: Wed, 18 Nov 2026 15:34:44 +0100
Message-ID: <20261118150239.400703117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 10655007b9b679e46a9e383202c7bb791e5d1d13 ]

ceph_oloc_decode handles unchecked data received over the network from
an OSD. Currently, there are multiple decode operations that aren't
covered by any bounds check. Decoding these fields can therefore result
in out-of-bounds reads if a corrupted message is received.

This patch fixes the issue by adding bounds checks covering all
previously uncovered decode operations.

[ idryomov: use ceph_decode_64_safe() for hash ]

Cc: stable@vger.kernel.org
Fixes: 205ee1187a67 ("libceph: follow redirect replies from osds")
Assisted-by: Cursor
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 7df1b9239b4c3..5395cfa519bb7 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3507,6 +3507,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	ceph_decode_need(p, end, len, e_inval);
 	struct_end = *p + len;
 
+	ceph_decode_need(p, end, 8 + 4 + 4, e_inval);
 	oloc->pool = ceph_decode_64(p);
 	*p += 4; /* skip preferred */
 
@@ -3519,7 +3520,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	if (struct_v >= 5) {
 		bool changed = false;
 
-		len = ceph_decode_32(p);
+		ceph_decode_32_safe(p, end, len, e_inval);
 		if (len > 0) {
 			ceph_decode_need(p, end, len, e_inval);
 			if (!oloc->pool_ns ||
@@ -3538,7 +3539,9 @@ static int ceph_oloc_decode(void **p, void *end,
 	}
 
 	if (struct_v >= 6) {
-		s64 hash = ceph_decode_64(p);
+		s64 hash;
+
+		ceph_decode_64_safe(p, end, hash, e_inval);
 		if (hash != -1) {
 			pr_warn("ceph_object_locator::hash is set\n");
 			goto e_inval;
-- 
2.53.0



