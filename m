Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062577;
	b=WwmrMorVXlBxejiF/XegHBcUeYKT16GEXU3QXPpNQ0/zA84prw6Cmz68ueSrO21HdmBV
	 nWKldjPMhaI/ZZvujlwklIXt5c5IDwqS8mJZuaC4wIL3rKEHslfuvkRiyY/cTrHbKIs4e
	 eVKPgsJuaU8HLkfy85ImsLw7vGE+xkkUXo6ELFuQaczw0h6hi8Q+6/mlO//53dZpftSJa
	 OYUPolM1t+BZx4YSCpAxqoCoKd+lxFXd3Hkk7pOzug1ipP75RRZrS3Cu4oFgDc1V0tWA3
	 +N2GowbM+IM2z5bsnDkV/ZUCc1MxyPVn6b7Ogo3x4HcuhtAXEL6OwEV10D9WpSD9Cbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3zz07q0+3LgnCo2xF6yNX/SriiFtGXoK9Jyxl9bKlvY=;
	b=rjHMQ8WyX6epytIKmtuq/acHiwffnybjUrz21Thih8jhdw/8F6QoQ4Rsvi3GbjpEAnP1
	 oDALWlmvKavLFBgvQFnUyt0dqROrRBiKKYpQRvOfBM3oEAXCw82y1lVSzOz1z2MUGb6Ys
	 vmQ/B/2x8spWlEw/Aw82LEnL988qAkbRh0Hw7beq4H0FjRiklKYm5vYp42+1Z6+m+wZ7g
	 hnPKnII/155sIoORMcsJ8n6R616bGc5cVx7PbxwQrFAZU+YT+wL29m1YO9Ho1jdJFmUz+
	 G2dkJgfOou3dRZTOsOt1n0DuNK2uLm7+v6jyUvluB4LiFg51NRutzQeHLPG9QoaeS0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oi5cVrN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5F0606A66B;
	Sat,  7 Nov 2026 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oi5cVrN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FA31F0089F;
	Sat,  7 Nov 2026 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062576;
	bh=3zz07q0+3LgnCo2xF6yNX/SriiFtGXoK9Jyxl9bKlvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oi5cVrN9PNaaRr+bc8WykjO7LP4j+MRAb5hbzSEqqd58uogUwe0pQpg0xxYIUbXyH
	 518LxblbQWj1DYxokBTwWjvxo9KQ8oZw5mgOmo+Dxs6/69nGqH5IRTwAqSDdWrJ0QK
	 oNGEv6c/0nXbqPd5U5XAfwhqnmcN8qM55YVf2UZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1459/1536] libceph: Fix multiple unsafe decodes in ceph_oloc_decode()
Date: Sat,  7 Nov 2026 08:57:55 -0500
Message-ID: <20261107135038.817823283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index b1e95ef61761a..86935dd755a71 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3593,6 +3593,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	ceph_decode_need(p, end, len, e_inval);
 	struct_end = *p + len;
 
+	ceph_decode_need(p, end, 8 + 4 + 4, e_inval);
 	oloc->pool = ceph_decode_64(p);
 	*p += 4; /* skip preferred */
 
@@ -3605,7 +3606,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	if (struct_v >= 5) {
 		bool changed = false;
 
-		len = ceph_decode_32(p);
+		ceph_decode_32_safe(p, end, len, e_inval);
 		if (len > 0) {
 			ceph_decode_need(p, end, len, e_inval);
 			if (!oloc->pool_ns ||
@@ -3624,7 +3625,9 @@ static int ceph_oloc_decode(void **p, void *end,
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



