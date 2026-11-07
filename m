Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063658;
	b=lU6//ccjVDzKHgK00uNFFSy+Ws6dZzUSZ3nD1BY1joSu/XQf61UQu9sz1t6EdmZustZE
	 PgvU3ON7yBSs4wwH+43jiyFnSXkYkDn31tBA8nxXRDDZip0ukzn8aIEJyYqr1G97AHXSm
	 yhP+RMxO55aaMd6c5XUEug5GZieslADvBphteoAQDIJOofFHju95gou1SjDHjysrQfY6h
	 ZkzkD+z6dcRxy2rMs3vAj14+8if5ZPsqhda/piZVKC04T84CxO/RqEjwUZzWZjQr5PZLg
	 f2dOPl6Nn+cKgwDHr8InFc3XKln5OzOEHOXJKpLdjI0RK7sXhyEvgoZp2Wj8Vxk+CLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6aZULJQtjtU/r23I+WdUKY0eIEXjMSEGVsVQ5p5xvFU=;
	b=S/bla//+L1YaDrNro6G00cw1JpNSLGplMRbl4VYHYqO5cmKRE8l+NpeB0ph0ljsNe+bW
	 b5MGcDAjINwD4UGaHUdhETYwrlJQY6JzIGadJsR8UJMUXxhizxUvkuaA9ifyUkNcGbLej
	 0mwY+04cC0kpI4U6m5qxK+IQobW4my8kin08APUoPWTs9BxGIWwHWF2PD6qSbsRG3Na2q
	 2em+6PTpgUPS35gLWiu/XO06uMp5tw6ycpAhiyTWYdYQy85KmLgMnwrqgqvoDCtSMT9LK
	 r0BGGiBeslByyqd5YcMwHc224Szz2q84jou8875o6Ur80a2Pz7R0XolsCc/zIdQksNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bc7+BJk8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E68606A9DA;
	Sat,  7 Nov 2026 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bc7+BJk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5AE1F0089F;
	Sat,  7 Nov 2026 15:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063658;
	bh=6aZULJQtjtU/r23I+WdUKY0eIEXjMSEGVsVQ5p5xvFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bc7+BJk8tvX0KfB3AcmiFCtf10CQhrZJ12BoOFBGXbnlurDtePbE43mmTHxGnxKjO
	 Mx/mZijWICMOdMghARxUq/OW3nqeDXnZtjIeof+mpvbCg9POOyMZSVTpSLLqUVPy5B
	 1t9Mqvv9LA5KSu1kxE+FIzSF4qy4CaDMf0fhyRk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 772/869] libceph: Fix multiple unsafe decodes in ceph_oloc_decode()
Date: Sat,  7 Nov 2026 08:57:34 -0500
Message-ID: <20261107134918.878016205@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 47879d73029aa..0b37fb3c62644 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3570,6 +3570,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	ceph_decode_need(p, end, len, e_inval);
 	struct_end = *p + len;
 
+	ceph_decode_need(p, end, 8 + 4 + 4, e_inval);
 	oloc->pool = ceph_decode_64(p);
 	*p += 4; /* skip preferred */
 
@@ -3582,7 +3583,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	if (struct_v >= 5) {
 		bool changed = false;
 
-		len = ceph_decode_32(p);
+		ceph_decode_32_safe(p, end, len, e_inval);
 		if (len > 0) {
 			ceph_decode_need(p, end, len, e_inval);
 			if (!oloc->pool_ns ||
@@ -3601,7 +3602,9 @@ static int ceph_oloc_decode(void **p, void *end,
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



