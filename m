Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F974F7CDC;
	Wed, 30 Sep 2026 15:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782838; cv=none; b=a2xClcYCg9NrmNIXeoIUfx3ZB6Up16M+Y9fLfs8YMbMBTyLhK1llGUArDyo8Y4vvFNuVjG3qO9lmCjCalEFQNXLCNityEIpwR6KzXRfMJZGDTuoXW6QQMW9yPySjxVVMyPm4QwTFDZ9KROZcZV3La/677LjHczwe8x30ecb5zFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782838; c=relaxed/simple;
	bh=1M3cVzCZ2zKlmOaifZ9Sl+ZDY36jVhMqvtsGCQQNbZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmYFA+P3XuXVkQf5uT4VEc8pmYSohmRwyS9+37WXQ1Rn6uyavRgzwnrOKvrzzffTrXbRxsTf5DhQ8flyBdc1LRtJJbfCAdVFeA9DF2fQKMJ45oJuR6ro55fwJ2t9NHdK9dqebHQDRQETNfdhFP2Swkdpf/Tsdqv0rPS37QSP4Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpFH1ZFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpFH1ZFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE91F00893;
	Wed, 30 Sep 2026 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782834;
	bh=Nn34/YRj3GXGJkDTT/0nXhy0UQEYHJ0sheva0+1htd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpFH1ZFGRpkvt0kypmhc76DnHQYv2Z7xwwuYvJ220mqQ7kj1fEDL8TklQK/bgswV1
	 g23qpqzA3LmIUCnLciYXQRlZHqSDa4J1NnFaep/P24DOjrFJkBArmAazjLMRV6FRz6
	 o3fUY/Iux958gAHwONZwNBv33fGfxVWlUEYhbkMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/595] libceph: Reject monmaps advertising zero monitors
Date: Wed, 30 Sep 2026 17:21:19 +0200
Message-ID: <20260930152351.741005878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 40480eee361ed9676b3f844d532ac28b47251634 upstream.

A message of type CEPH_MSG_MON_MAP contains a monmap that is sent from a
monitor to the client. This monmap contains information about the
existing monitors in the cluster. Currently, a monmap indicating that
there are zero monitors in the cluster is treated as valid. However, it
is impossible to have zero monitors in the cluster and still receive a
valid monmap from a monitor. Therefore, such a monmap must be corrupted
and should be treated as invalid. Furthermore, a monmap with a monitor
count of zero can subsequently crash the client when attempting to open
a session with a monitor in __open_session(). This happens because the
"BUG_ON(monc->monmap->num_mon < 1)" assertion in pick_new_mon() is
triggered.

This patch extends a check in ceph_monmap_decode() to also reject
arriving mon_maps with num_mon == 0 rather than only with
num_mon > CEPH_MAX_MON.

[ idryomov: drop "log output for unusual values of num_mon" part ]

Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/mon_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index e1f01aef263e8..fac52fe7a5870 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -59,7 +59,7 @@ static struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 
 	num_mon = ceph_decode_32(&p);
 
-	if (num_mon > CEPH_MAX_MON)
+	if (num_mon == 0 || num_mon > CEPH_MAX_MON)
 		goto bad;
 	m = kmalloc(struct_size(m, mon_inst, num_mon), GFP_NOFS);
 	if (m == NULL)
-- 
2.53.0



