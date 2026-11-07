Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063708;
	b=1U0xR+IGkkGoQZpgJkCMFLd7P75GBskHWS8UtnteuimjdS531W/zqhaA2gvNBPeD+RFg
	 EDzzabMDqVYibVY0Sb8RHMm9mROwsBw3elRcY3EaqNYHq2AivSjihHqMOYLQqvHceSMdW
	 +lXjXHm3Tak3p1W/TmmJvqVD/EaJUEUQeqKPlRjJTTA/C/ydBMzw+zSKx+uCi2JMX5RsM
	 2Y+G/ggrMPtZqRc8xr/8izFIl9XMJQyG6Rxji8EE8jqtU252XR5ZLl2hmdKFhXiG3IlCk
	 trv+4oR+fWBe6odnzrRuIhdWHEAKEFgW34dzVbQwf9XpEdDOE6KVtehJorZq8VhwcHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sqL+Mczg5dR23IK+xOUPY64s9Ieq633sAP3QZIFBYtw=;
	b=Rx9vdSpPGL8tnROt7pNaRf8b+44tpWLEE65ZUwoYFeQOBlrp0TiFkz/ipQ2+AY/6jrWx
	 RlSD6NJKFGyLQXC5EHE5eSNcR0l25ebaNCnMyJCa6+F6HfDws4Xkd4+qgDT/j0ykb2vP7
	 PNCptlwFbWAVpZsbYcEvHkcijwwor9h23Z7lqhoKWxHPdkwjdWDEltdKiyfyFVoDi4rzB
	 GYLddf2BKva9YYcAZ7jUtmFarS/r084xAwyvVABkAYU0Y1VWwXBE+c2hzH0pKJ1diO3uZ
	 WzSEKm+v8fzUXKE1AsD+r1WlA4ICcMRhFbSbc7cYkLmKED7tw2A71Br4IedZkySX84A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+vVViz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB19606B8AF;
	Sat,  7 Nov 2026 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+vVViz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2C81F0089F;
	Sat,  7 Nov 2026 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063707;
	bh=sqL+Mczg5dR23IK+xOUPY64s9Ieq633sAP3QZIFBYtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+vVViz5fZp771TkuCbjzpobef1nxreKuQsFFSk82Ddfo91Suk1aExr+puKkxMwQe
	 MKyF41GG3qX4TyYsqgcuNVujjQopzWmTERliAFcwbDVLxdujzcLEvMy3nmlOakmldo
	 2ZSUk+E1bVqK+kE2NudnBEK1nxZqwwkuE5hVFoEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 771/869] libceph: Fix unsafe decode in ceph_redirect_decode()
Date: Sat,  7 Nov 2026 08:57:33 -0500
Message-ID: <20261107134918.849014561@linuxfoundation.org>
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

[ Upstream commit 0405670e50f213594366ab7eddc07002bd7f84c0 ]

ceph_redirect_decode handles unchecked data received over the network
from an OSD. Currently, there is only a bounds check covering the first
three decode operations. After decoding the first len field from the
message, the only remaining check ensures there is enough buffer space
to hold len bytes. However, there is no guarantee that this value is
large enough to hold the subsequently decoded fields. The decoding of
the second len field is missing an explicit bounds check. Consequently,
a corrupted message can trigger an out-of-bounds read.

This patch fixes the issue by switching the decoding from
ceph_decode_32() to the bounds-checked version ceph_decode_32_safe().

Cc: stable@vger.kernel.org
Fixes: 205ee1187a67 ("libceph: follow redirect replies from osds")
Assisted-by: Cursor
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 92d76df2701ef..47879d73029aa 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3642,7 +3642,7 @@ static int ceph_redirect_decode(void **p, void *end,
 	if (ret)
 		goto out;
 
-	len = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {
 		pr_warn("ceph_request_redirect::object_name is set\n");
 		goto e_inval;
-- 
2.53.0



