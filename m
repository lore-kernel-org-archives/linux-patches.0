Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036929;
	b=V/aGpq1ryzkpnZ00JRZiP0CPHxEr7rdw0GVwKYyZDJ0T+aocnrZztYTgBT9qXMInQsLx
	 nM0iR1HWyYR+hIKG9eNHNos+wka+/lCFHEGYICsyrEx+3UGaeC92o7c+osxpFHeSLCZ0q
	 YJYY1BGRcCAX9nBYCxhG1BAa75tsli2Guf3x8/aGgvRwmSoKX9z4n2+8ed2MA71ypXa8u
	 pE/9yrdsmjoVZjZ6gizFjovDWZQZr1DGwbqa45eDuZnObEVOGuBN+CyAHVJ64V8VEJhxF
	 AJogS5sc82SqvUeXuUxT3mpxraTvnkdEczFKMLfugigx2UQYBCRii/9wZP+rOiMUmeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dW1YeU8Gl1DyiBNltJ++6k9ytV4JADE2A/q5gz+6elI=;
	b=pnrtaE48gWjCEyH9SaQTqScFgAVn5/e9DKcWaBxX6jzPaNEw2bSAkUa6zQyEyENdKGsE
	 mGhW7BUjc6jhGE8iopS/f4I4YybJxrfgcg66i8xcRZOlP4ex8ezB+9GUAWTBCPsDFTMrS
	 Gf5eeWzySKSzsALCKMLsA356q/dN1mg4A+Q3rlWSXZZrx8c9or1rpIMg2HnRfr4X6TiYu
	 m6SfhI3AWKOKlIQodnAOSvwB1SXnhdZG6lKP5QZ5azkVG5CNmVA7pwcTTKOhzVc3XO1VD
	 nIxJN+P9Te+m7CYDVnmJcww39Bw9Iq/np4iLglYBGmZwdzxsmQZmvrrq2JmIRUCYr3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcyqDWMI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB3D606A325;
	Wed, 18 Nov 2026 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcyqDWMI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500211F000C4;
	Wed, 18 Nov 2026 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036928;
	bh=dW1YeU8Gl1DyiBNltJ++6k9ytV4JADE2A/q5gz+6elI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcyqDWMIaaYEmur3esdTl4x8YAcrmqrqkx2fS/ma/FtRUM8CNqHrjeUcjDXp6G3+A
	 Uq+2ThEgo8f4avkcpfHC2Uivrffg+XztrkqLi1rJgAbgC28XZCnbs1d5O1lpzG1HHz
	 JJmWS/58OkCkbpckc16oCJOui0Gk5OFojhJCb6b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1232/3318] libceph: Fix multiple unsafe decodes in ceph_oloc_decode()
Date: Wed, 18 Nov 2026 15:30:54 +0100
Message-ID: <20261118150357.153883342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7892c15d74993..fca5ed58c7e73 100644
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



