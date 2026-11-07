Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065473;
	b=yKP3EX1iVjMGi2NJ+hjLsypJ3JaXnN7cnmGQ8+mvyT50BInI3ObwThQRS+2P3Pton9Qj
	 HgiyTRitcE9ATDBWXO37tv9r7sy5QZeMXEht087i60KCWRS5jwMKloDFInjBzRcf+Bv24
	 Yy69kjxBQa/E/hwfMLyNurFEfHuAvtJz0fiK93oxxxBDREXyj/JJuEWEtHOMFIDqLNPrV
	 VYtMwilH3v/hreX4+0QNB/xGTFq1PIgj9o1qn/AdFIGBwnIq0FKUJrmYH8NqWJG9yU0gw
	 TdwICq/dDvY+rI7/5ugfqGC3Qpei/l6UtI2FSONJ2OQf20cR6JwI+5MRA3Xp2UwrryQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c6C5YPt/w4wlF7QgeQ2fiFvny64oOkzLX1oAIZgQxZc=;
	b=jAT3wUHZR9OZiq8IGKZTBIoKivuqwG9PWcrCG5KDLKGlvi7Sd2eij94STy88fzqhP6gh
	 +zSCY1Ss9zYliK6k+B3lNVxp3+rHxfP2hybOmMIKpkNovn87CrzfPi/phyp65lqqfyJzT
	 +beuPd0An3aPZU0W0Qs6MMCpajgws1Hh7pTsZ88WojpHCVxT1B6dsrb0HqQ7K6LoxB4by
	 Fv7wV6spb5P8rP9vE9w+lfeQhly9UscrDbbeVfbOTnByExZn3r4BqaQbhPBDYJPOYg+YA
	 puJNfc0YoZnqTPCPt9SF/c0LfZEnqHXCLb0HGTxLgm9wFBT6wm/Z0/LuDKh8VRFt86g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Twe96QOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A401A606A32C;
	Sat,  7 Nov 2026 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Twe96QOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0296A1F0089F;
	Sat,  7 Nov 2026 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065473;
	bh=c6C5YPt/w4wlF7QgeQ2fiFvny64oOkzLX1oAIZgQxZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Twe96QOzSl2RTaat2fKTU6LSaYQTrq5+Bu6lV4fh+RqTUXsvwEv6ieTvfaevB4WCM
	 MVzrmmFzL1JXjutJNDG0LvtOaHJ4luQ4lXS30gLqkn7zqKU0rIm+9ipillzgUeXv6o
	 IoTZUJXebbuXIguP54j4EBtM+t213VM/P8CFHMuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1121/1257] libceph: Fix multiple unsafe decodes in ceph_oloc_decode()
Date: Sat,  7 Nov 2026 08:56:57 -0500
Message-ID: <20261107135010.200221260@linuxfoundation.org>
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
index 3f23027fba3c0..b8e4740d07fe2 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3567,6 +3567,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	ceph_decode_need(p, end, len, e_inval);
 	struct_end = *p + len;
 
+	ceph_decode_need(p, end, 8 + 4 + 4, e_inval);
 	oloc->pool = ceph_decode_64(p);
 	*p += 4; /* skip preferred */
 
@@ -3579,7 +3580,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	if (struct_v >= 5) {
 		bool changed = false;
 
-		len = ceph_decode_32(p);
+		ceph_decode_32_safe(p, end, len, e_inval);
 		if (len > 0) {
 			ceph_decode_need(p, end, len, e_inval);
 			if (!oloc->pool_ns ||
@@ -3598,7 +3599,9 @@ static int ceph_oloc_decode(void **p, void *end,
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



