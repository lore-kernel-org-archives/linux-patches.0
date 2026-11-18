Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052865;
	b=A5XiOZuZLpXxVHlAHmsVmcsLHolCp1NvGUVbmlQEyTzcahk4ZYrPnD/tgk5INhgNqrk+
	 YnzeO8zXXQYODOYhSIuzTRMRAI713qkVx/i/UOtWyzBGWNoOpUdJgNrbYglMeUczRvpzM
	 EIrceCSTrtpmGHaFTb5UX1yIP819NUAFvBUrr9IwL2SW/HV/QiRCeZEiunh7Q3QWndQ8h
	 3MB5sMRULdRzKAWSMGi67VfqUJ/sRBuQkh3M5aWG/s3/oyVQ3+G7MZAFqC38C3VscDrE+
	 CSGQBeAbAKA8uOM40xj95+9sokAOeB1WH4rAUaZ8/mULRQsncmiswohVB76+j8l+CZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pCLtDF7WDI8r3io/+r8Bs1iAP9e1QzDJXXwHqr1erXc=;
	b=hqdg6wEkTa6rzqwta+tHFedm+3sZUBlSqPhDRT0YMTMB9QXNL2AQ0PAX98sFO9xMLm1g
	 b1RCAME//gzp0QiuYMbBk0/e/gj0bWrYQ3KHQVaKzvndZDeP4V4OTbZTzW+yiFrgUZGe7
	 sA7enoOkJdJLxzclbXCD36xOM7dwv4bj2qN1UOrGRX6fMZVNO6r0eZa327IfgYqGwlm7q
	 MjCgylC+oTRguI/ujPa/yNhD6n2qlp+8lqJ7URuIRTGxnnj9GKaDCXlwl89ZYFgayjcfd
	 itzTRkzY/ThKctxsdhKr5sWPclVyYjcnw5BxWpE+o+QeaS2rFeXbU8FLodAV/q1FVlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khtOrqYe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C3606A31C;
	Thu, 19 Nov 2026 01:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khtOrqYe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEBD1F000C5;
	Thu, 19 Nov 2026 01:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052865;
	bh=pCLtDF7WDI8r3io/+r8Bs1iAP9e1QzDJXXwHqr1erXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khtOrqYea3d3BEHfiF3i9de38l/RZ+wpLBoVNrVA+5jQvX/m8fL+IS9Lo2d5BpRfW
	 X+QwHCPnYHeRlyT6IpRT+eSVzhYa2HkQ26D0uaC4nN7aSWXOXJ7PoV66jvU79LZG2Y
	 B69gfREdkrsM34UeWNoS6l7XpAUtcCoQrzJLbSFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0714/2214] libceph: Fix multiple unsafe decodes in ceph_oloc_decode()
Date: Wed, 18 Nov 2026 15:39:50 +0100
Message-ID: <20261118150040.368663067@linuxfoundation.org>
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
index 3d91e8092d0ee..e0d5781061494 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3503,6 +3503,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	ceph_decode_need(p, end, len, e_inval);
 	struct_end = *p + len;
 
+	ceph_decode_need(p, end, 8 + 4 + 4, e_inval);
 	oloc->pool = ceph_decode_64(p);
 	*p += 4; /* skip preferred */
 
@@ -3515,7 +3516,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	if (struct_v >= 5) {
 		bool changed = false;
 
-		len = ceph_decode_32(p);
+		ceph_decode_32_safe(p, end, len, e_inval);
 		if (len > 0) {
 			ceph_decode_need(p, end, len, e_inval);
 			if (!oloc->pool_ns ||
@@ -3534,7 +3535,9 @@ static int ceph_oloc_decode(void **p, void *end,
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



